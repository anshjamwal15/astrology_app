import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/communication/waiting_screen.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/services/video_signaling_service.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  final String roomId;
  final bool isCreating;
  const VideoCallScreen({
    super.key,
    required this.roomId,
    required this.isCreating,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  VideoSignalingService signaling = VideoSignalingService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderersAndMedia();

    signaling.onAddRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };
  }

  Future<void> _initializeRenderersAndMedia() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    MediaStream localStream = await navigator.mediaDevices
        .getUserMedia({'audio': true, 'video': true});

    _localRenderer.srcObject = localStream;

    _remoteRenderer.srcObject = await createLocalMediaStream('remoteStream');

    setState(() {});

    if (widget.isCreating) {
      await signaling.createRoom(
        UserManager.instance.user!.id,
        localStream,
        _remoteRenderer.srcObject!,
      );
    } else {
      await signaling.joinRoom(
        widget.roomId,
        localStream,
        _remoteRenderer.srcObject!,
      );
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => _showConnectingDialog());
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SizedBox.expand(
                child: _remoteRenderer.srcObject != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: RTCVideoView(
                            filterQuality: FilterQuality.medium,
                            _remoteRenderer,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitCover,
                          ),
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.blue.shade900,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              "Please wait, ${signaling.connectionState.toString()}",
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 100.0,
              right: -20.0,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: SizedBox.expand(
                    child: RTCVideoView(
                      filterQuality: FilterQuality.medium,
                      _localRenderer,
                      mirror: true,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMuted ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: IconButton(
                      onPressed: () => _toggleMute(),
                      icon: const Icon(
                        Icons.mic_off,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 0.2),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await signaling.hangUp(
                          widget.roomId,
                          _localRenderer.srcObject!,
                          _remoteRenderer.srcObject!,
                        );
                        _routeToHome();
                      },
                      icon: const Icon(
                        Icons.call_end,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _routeToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    var audioTracks = _localRenderer.srcObject?.getAudioTracks();
    if (audioTracks != null) {
      for (var track in audioTracks) {
        track.enabled = !isMuted;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isMuted ? "Microphone muted" : "Microphone unmounted",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
