import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:unnati_app/services/api_service.dart';

class LiveVideoConferenceScreen extends StatefulWidget {
  final String sessionId;
  final int appId;
  final String appSign;
  final String channelName; // Zego roomID
  final String userId;
  final String userName;
  final bool isLead;
  final String? studentName;
  final String? subject;

  const LiveVideoConferenceScreen({
    super.key,
    required this.sessionId,
    required this.appId,
    required this.appSign,
    required this.channelName,
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
  Widget? _localVideoWidget;
  Widget? _remoteVideoWidget;
  int? _localViewID;
  int? _remoteViewID;
  String? _remoteStreamId;

  bool _muted = false;
  bool _videoOff = false;
  bool _useFrontCamera = true;
  int _secondsElapsed = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _initZego();
  }

  Future<void> _initZego() async {
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
      // 2. Initialize ZEGOCLOUD Engine with platform views enabled for native Android SurfaceView
      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          widget.appId,
          ZegoScenario.Default,
          appSign: widget.appSign,
          enablePlatformView: true,
        ),
      );

      final myRole = widget.isLead ? 'lead' : 'student';
      final myStreamId = '${widget.channelName}_$myRole';

      // 3. Register Event Callbacks
      ZegoExpressEngine.onRoomStreamUpdate = (
        String roomID,
        ZegoUpdateType updateType,
        List<ZegoStream> streamList,
        Map<String, dynamic> extendedData,
      ) {
        debugPrint("ZEGO STREAM UPDATE: $updateType in room $roomID, count: ${streamList.length}");
        for (final stream in streamList) {
          debugPrint("Found stream: ${stream.streamID} from user: ${stream.user.userID}");
          if (updateType == ZegoUpdateType.Add) {
            if (stream.streamID != myStreamId) {
              _startListeningToRemoteStream(stream.streamID);
            }
          } else if (updateType == ZegoUpdateType.Delete) {
            if (_remoteStreamId == stream.streamID) {
              _stopListeningToRemoteStream();
            }
          }
        }
      };

      // 4. Log into Room with isUserStatusNotify = true to receive live stream updates
      final roomResult = await ZegoExpressEngine.instance.loginRoom(
        widget.channelName,
        ZegoUser(widget.userId, widget.userName),
        config: ZegoRoomConfig(0, true, ''),
      );

      debugPrint("ZEGO Login Room Result errorCode: ${roomResult.errorCode}");

      // 5. Create Local Video Preview
      final localWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) {
        _localViewID = viewID;
        ZegoExpressEngine.instance.startPreview(
          canvas: ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill),
        );
      });

      if (mounted) {
        setState(() {
          _localVideoWidget = localWidget;
        });
      }

      // 6. Publish Local Video Stream
      await ZegoExpressEngine.instance.startPublishingStream(myStreamId);
      debugPrint("ZEGO Started Publishing stream: $myStreamId");

      _startCallTimer();
    } catch (e) {
      debugPrint("ZEGOCLOUD initialization error: $e");
    }
  }

  Future<void> _startListeningToRemoteStream(String streamID) async {
    if (_remoteStreamId == streamID && _remoteVideoWidget != null) return;

    try {
      final remoteWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) {
        _remoteViewID = viewID;
        ZegoExpressEngine.instance.startPlayingStream(
          streamID,
          canvas: ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill),
        );
      });

      if (mounted && remoteWidget != null) {
        setState(() {
          _remoteStreamId = streamID;
          _remoteVideoWidget = remoteWidget;
        });
        debugPrint("ZEGO Successfully started playing remote stream: $streamID");
      }
    } catch (e) {
      debugPrint("Error starting remote stream playback: $e");
    }
  }

  Future<void> _stopListeningToRemoteStream() async {
    if (_remoteStreamId != null) {
      await ZegoExpressEngine.instance.stopPlayingStream(_remoteStreamId!);
      if (_remoteViewID != null) {
        await ZegoExpressEngine.instance.destroyCanvasView(_remoteViewID!);
      }
      if (mounted) {
        setState(() {
          _remoteStreamId = null;
          _remoteVideoWidget = null;
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

  Future<void> _endCall() async {
    _callTimer?.cancel();
    try {
      if (_localViewID != null) {
        await ZegoExpressEngine.instance.destroyCanvasView(_localViewID!);
      }
      if (_remoteViewID != null) {
        await ZegoExpressEngine.instance.destroyCanvasView(_remoteViewID!);
      }
      await ZegoExpressEngine.instance.logoutRoom(widget.channelName);
      await ZegoExpressEngine.destroyEngine();
    } catch (_) {}

    await ApiService.endLiveCall(widget.sessionId);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _endCall();
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
              child: _remoteVideoWidget != null
                  ? SizedBox.expand(child: _remoteVideoWidget!)
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
                  child: _localVideoWidget != null && !_videoOff
                      ? SizedBox.expand(child: _localVideoWidget!)
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
                      ZegoExpressEngine.instance.muteMicrophone(_muted);
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
                      ZegoExpressEngine.instance.enableCamera(!_videoOff);
                    },
                    icon: Icon(_videoOff ? Icons.videocam_off : Icons.videocam),
                  ),

                  // Switch Front / Back Camera
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() => _useFrontCamera = !_useFrontCamera);
                      ZegoExpressEngine.instance.useFrontCamera(_useFrontCamera);
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
