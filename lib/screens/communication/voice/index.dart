import 'dart:async';
import 'package:astrology_app/services/user_manager.dart';
import 'package:astrology_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceCall extends StatefulWidget {
  final String? mentorName;
  final String roomId;
  final bool isCreating;

  const VoiceCall({
    super.key,
    required this.roomId,
    required this.isCreating,
    this.mentorName,
  });

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  SignalingService signaling = SignalingService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  int _seconds = 0;
  bool _isMuted = false;
  // bool _isSpeakerOn = true;

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeRenderersAndMedia();
    _startTimer();

    signaling.onAddRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };
  }

  Future<void> _initializeRenderersAndMedia() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    MediaStream localStream =
        await navigator.mediaDevices.getUserMedia({'audio': true});

    _localRenderer.srcObject = localStream;

    _remoteRenderer.srcObject = await createLocalMediaStream('remoteStream');

    setState(() {});

    if (widget.isCreating) {
      await signaling.createRoom(
        UserManager.instance.user!.id,
        localStream,
        _remoteRenderer.srcObject!,
        false,
      );
    } else {
      await signaling.joinRoom(
        widget.roomId,
        localStream,
        _remoteRenderer.srcObject!,
        false,
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: SingleChildScrollView(
        child: _remoteRenderer.srcObject != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.3),
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _invisibleWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "On call ${widget.isCreating ? "" : widget.mentorName}",
                              style: GoogleFonts.acme(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          _remoteRenderer.srcObject!.getAudioTracks().isNotEmpty ?
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 120),
                                child: Container(
                                  width: size.width * 0.4,
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      "assets/images/astologer.jpg",
                                      scale: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                  horizontal: size.width * 0.4,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/hd.png",
                                      scale: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      _formatTime(_seconds),
                                      style: GoogleFonts.acme(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.4),
                            ],
                          ) :
                          Center(
                            child: SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.4,
                              child: Image.asset(
                                "assets/images/waiting-room.png",
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                  Border.all(color: Colors.white, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: _toggleMute,
                                  icon: Icon(
                                    _isMuted ? Icons.mic_off : Icons.mic,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.04),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: IconButton(
                                  onPressed: _hangUp,
                                  icon: const Icon(
                                    Icons.call_end,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue.shade900,
                    ),
                    SizedBox(width: size.width * 0.02),
                    const Text(
                      "Please wait, connecting....",
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _localRenderer.srcObject?.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted;
      });
    });
  }

  void _hangUp() {
    signaling.hangUp(
      widget.roomId,
      _localRenderer.srcObject!,
      _remoteRenderer.srcObject!,
      false,
    );
    Navigator.pop(context);
  }

  _invisibleWidget() {
    return Visibility(
      visible: false,
      child: Row(
        children: [
          RTCVideoView(
            filterQuality: FilterQuality.medium,
            _remoteRenderer,
          ),
          RTCVideoView(
            filterQuality: FilterQuality.medium,
            _localRenderer,
            mirror: true,
          )
        ],
      ),
    );
  }
}
