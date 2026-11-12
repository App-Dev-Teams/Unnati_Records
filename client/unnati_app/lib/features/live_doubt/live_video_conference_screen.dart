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
  State<LiveVideoConferenceScreen> createState() => _LiveVideoConferenceScreenState();
}

class _LiveVideoConferenceScreenState extends State<LiveVideoConferenceScreen> {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;

  bool _muted = false;
  bool _videoOff = false;
  bool _useFrontCamera = true;
  int _secondsElapsed = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // 1. Request hardware permissions
    final permissions = await [Permission.camera, Permission.microphone].request();
    if (permissions[Permission.camera] != PermissionStatus.granted ||
        permissions[Permission.microphone] != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera and Microphone permissions are required.')),
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      // 2. Create and initialize Agora RTC Engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        RtcEngineContext(
          appId: widget.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // 3. Register Event Handlers
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("Agora onJoinChannelSuccess: channel=${connection.channelId}, uid=${connection.localUid}");
            if (mounted) {
              setState(() {
                _isJoined = true;
              });
              _startCallTimer();
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("Agora onUserJoined: remoteUid=$remoteUid");
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("Agora onUserOffline: remoteUid=$remoteUid, reason=$reason");
            if (mounted) {
              setState(() {
                if (_remoteUid == remoteUid) {
                  _remoteUid = null;
                }
              });
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("Agora onError: $err, msg: $msg");
          },
        ),
      );

      // 4. Enable Video and Start Local Preview
      await _engine!.enableVideo();
      await _engine!.startPreview();

      // 5. Join Channel
      await _engine!.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      debugPrint("Agora initialization error: $e");
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

  Future<void> _endCall() async {
    _callTimer?.cancel();
    try {
      if (_engine != null) {
        await _engine!.leaveChannel();
        await _engine!.release();
        _engine = null;
      }
    } catch (e) {
      debugPrint("Error releasing Agora engine: $e");
    }

    await ApiService.endLiveCall(widget.sessionId);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    if (_engine != null) {
      _engine!.leaveChannel();
      _engine!.release();
      _engine = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Remote Video Stream (Full Screen)
            Positioned.fill(
              child: _remoteUid != null && _engine != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine!,
                        canvas: VideoCanvas(uid: _remoteUid),
                        connection: RtcConnection(channelId: widget.channelName),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: Colors.white70),
                          const SizedBox(height: 20),
                          Text(
                            widget.isLead
                                ? 'Connecting with student video...'
                                : 'Connecting with mentor video...',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  child: _isJoined && !_videoOff && _engine != null
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine!,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.videocam_off, color: Colors.white54, size: 28),
                        ),
                ),
              ),
            ),

            // 3. Header Bar with Subject and Live Call Timer
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fiber_manual_record, color: Colors.redAccent, size: 12),
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
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ]
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
                    },
                    icon: Icon(_videoOff ? Icons.videocam_off : Icons.videocam),
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
    );
  }
}
