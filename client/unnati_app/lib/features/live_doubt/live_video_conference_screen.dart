import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:unnati_app/services/api_service.dart';

class LiveVideoConferenceScreen extends StatefulWidget {
  final String sessionId;
  final String appId;
  final String token;
  final String channelName; // Agora channelId
  final int uid;
  final String userId;
  final String userName;
  final bool isLead;
  final String? studentName;
  final String? subject;

  const LiveVideoConferenceScreen({
    super.key,
    required this.sessionId,
    required this.appId,
    required this.token,
    required this.channelName,
    this.uid = 0,
    required this.userId,
    required this.userName,
    required this.isLead,
    this.studentName,
    this.subject,
  });

  @override
  State<LiveVideoConferenceScreen> createState() =>
      _LiveVideoConferenceScreenState();
}

class _LiveVideoConferenceScreenState extends State<LiveVideoConferenceScreen> {
  static final RegExp _agoraAppIdRegex = RegExp(r'^[0-9a-fA-F]{32}$');

  RtcEngine? _engine;
  RtcEngineEventHandler? _eventHandler;
  VideoViewController? _localController;
  VideoViewController? _remoteController;

  bool _localPreviewReady = false;
  bool _isJoined = false;
  int? _remoteUid;
  String? _errorMessage;

  bool _muted = false;
  bool _videoOff = false;
  bool _useFrontCamera = true;
  bool _isEnding = false;
  int _secondsElapsed = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    final trimmedAppId = widget.appId.trim();
    if (!_agoraAppIdRegex.hasMatch(trimmedAppId) ||
        widget.channelName.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Video service configuration is invalid or outdated on the server. Please deploy the latest Agora backend and try again.';
        });
      }
      return;
    }

    // 1. Request hardware permissions
    final permissions = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (permissions[Permission.camera] != PermissionStatus.granted ||
        permissions[Permission.microphone] != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone permissions are required.'),
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      // 2. Create and initialize Agora RTC Engine
      final engine = createAgoraRtcEngine();
      _engine = engine;

      await engine.initialize(
        RtcEngineContext(
          appId: trimmedAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Cache local video controller once instead of recreating on every timer tick
      _localController = VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
      );

      // 3. Register Event Handlers
      _eventHandler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
            'Agora onJoinChannelSuccess: channel=${connection.channelId}, uid=${connection.localUid}',
          );
          if (mounted) {
            setState(() {
              _isJoined = true;
              _errorMessage = null;
            });
            _startCallTimer();
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Agora onUserJoined: remoteUid=$remoteUid');
          if (!mounted || _engine == null) return;
          _remoteController?.dispose();
          _remoteController = VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(uid: remoteUid),
            connection: RtcConnection(channelId: widget.channelName),
          );
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          debugPrint(
            'Agora onUserOffline: remoteUid=$remoteUid, reason=$reason',
          );
          if (mounted && _remoteUid == remoteUid) {
            _remoteController?.dispose();
            _remoteController = null;
            setState(() {
              _remoteUid = null;
            });
          }
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) async {
          debugPrint('Agora token expiring soon, refreshing...');
          final res = await ApiService.startLiveCall(widget.sessionId);
          final freshToken = res['token']?.toString() ?? '';
          if (freshToken.isNotEmpty && _engine != null) {
            await _engine!.renewToken(freshToken);
          }
        },
        onConnectionStateChanged: (
          RtcConnection connection,
          ConnectionStateType state,
          ConnectionChangedReasonType reason,
        ) {
          debugPrint('Agora connection state: $state, reason: $reason');
          if (mounted &&
              state == ConnectionStateType.connectionStateFailed) {
            setState(() {
              _errorMessage =
                  'Unable to connect to video call ($reason). Please check your internet connection and try again.';
            });
          }
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint('Agora onError: $err, msg: $msg');
          if (!mounted) return;
          if (err == ErrorCodeType.errInvalidAppId ||
              err == ErrorCodeType.errInvalidToken ||
              err == ErrorCodeType.errTokenExpired ||
              err == ErrorCodeType.errInvalidChannelName ||
              err == ErrorCodeType.errJoinChannelRejected) {
            setState(() {
              _errorMessage =
                  'Agora connection failed (${err.name}). Please verify backend Agora credentials/token.';
            });
          }
        },
      );
      engine.registerEventHandler(_eventHandler!);

      // 4. Enable Audio & Video and Start Local Preview
      await engine.enableAudio();
      await engine.enableVideo();
      await engine.startPreview();

      if (mounted) {
        setState(() {
          _localPreviewReady = true;
        });
      }

      // 5. Join Channel with explicit publish & auto-subscribe options
      await engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );
    } catch (e) {
      debugPrint('Agora initialization error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to start video conference: $e';
        });
      }
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _releaseEngine() async {
    final engine = _engine;
    _engine = null;
    if (engine == null) return;

    try {
      if (_eventHandler != null) {
        engine.unregisterEventHandler(_eventHandler!);
        _eventHandler = null;
      }
      await _remoteController?.dispose();
      _remoteController = null;
      await _localController?.dispose();
      _localController = null;
      await engine.stopPreview();
      await engine.leaveChannel();
      await engine.release();
    } catch (e) {
      debugPrint('Error releasing Agora engine: $e');
    }
  }

  Future<void> _endCall() async {
    if (_isEnding) return;
    _isEnding = true;
    _callTimer?.cancel();

    await _releaseEngine();
    await ApiService.endLiveCall(widget.sessionId);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    if (!_isEnding) {
      _isEnding = true;
      unawaited(_releaseEngine());
      unawaited(ApiService.endLiveCall(widget.sessionId));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _endCall();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Remote Video Stream (Full Screen) or Status/Error Overlay
              Positioned.fill(
                child: _errorMessage != null
                    ? Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.redAccent,
                              size: 52,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _endCall,
                              icon: const Icon(Icons.call_end),
                              label: const Text('Leave Call'),
                            ),
                          ],
                        ),
                      )
                    : (_remoteUid != null && _remoteController != null)
                        ? AgoraVideoView(controller: _remoteController!)
                        : Container(
                            color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  !_isJoined
                                      ? 'Joining video room...'
                                      : (widget.isLead
                                          ? 'Connecting with student video...'
                                          : 'Connecting with mentor video...'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),

              // 2. Picture-in-Picture Local User Preview (Top Right)
              Positioned(
                top: 16,
                right: 16,
                width: 110,
                height: 155,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.grey.shade900,
                    child: _localPreviewReady &&
                            !_videoOff &&
                            _localController != null
                        ? AgoraVideoView(controller: _localController!)
                        : const Center(
                            child: Icon(
                              Icons.videocam_off,
                              color: Colors.white54,
                              size: 28,
                            ),
                          ),
                  ),
                ),
              ),

              // 3. Header Bar with Subject and Live Call Timer
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.redAccent,
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(_secondsElapsed),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (widget.subject != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          '|  ${widget.subject}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // 4. Bottom Controls Bar
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute / Unmute
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() => _muted = !_muted);
                        _engine?.muteLocalAudioStream(_muted);
                      },
                      icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                    ),

                    // End Call Button
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        iconSize: 32,
                      ),
                      onPressed: _endCall,
                      icon: const Icon(Icons.call_end, color: Colors.white),
                    ),

                    // Camera On / Off
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() => _videoOff = !_videoOff);
                        _engine?.muteLocalVideoStream(_videoOff);
                        _engine?.enableLocalVideo(!_videoOff);
                      },
                      icon: Icon(
                        _videoOff ? Icons.videocam_off : Icons.videocam,
                      ),
                    ),

                    // Switch Front / Back Camera
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() => _useFrontCamera = !_useFrontCamera);
                        _engine?.switchCamera();
                      },
                      icon: const Icon(Icons.switch_camera),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
