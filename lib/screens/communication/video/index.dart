import 'dart:async';
import 'dart:convert';

import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as model;
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/services/signaling_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  final String roomId;
  final bool isCreating;
  final String? mentorId;
  final String? userName;
  const VideoCallScreen({
    super.key,
    required this.roomId,
    required this.isCreating,
    this.mentorId,
    this.userName
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  SignalingService signaling = SignalingService();
  final Dio dio = Dio();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool isMuted = false;
  bool isCameraOpen = false;
  bool isRemoteCameraOpen = true;

  @override
  void initState() {
    super.initState();
    _initializeRenderersAndMedia();

    signaling.onAddRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    signaling.onAddConnectionStream = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _localRenderer.dispose();
        _remoteRenderer.dispose();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => const HomeScreen(),
          ),
        );
      }
    };

    signaling.onAddIceConnectionStream = (state) {
      if (widget.isCreating && state == RTCIceGatheringState.RTCIceGatheringStateGathering) {
        final req = model.VideoCallRequest(
          roomId: widget.roomId,
          userId: widget.mentorId!,
          callType: "video",
          userName: widget.userName!,
        );
        _sendCallNotification(req);
        signaling.createCallEntry(
          widget.roomId,
          widget.roomId,
          widget.mentorId!
        );
      }
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
        widget.roomId,
        localStream,
        _remoteRenderer.srcObject!,
        true,
      );
    } else {
      await signaling.joinRoom(
        widget.roomId,
        localStream,
        _remoteRenderer.srcObject!,
        true,
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
      backgroundColor: AppConstants.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SizedBox.expand(
                child: _remoteRenderer.srcObject != null && _remoteRenderer.renderVideo
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: _remoteRenderer.srcObject!
                                  .getVideoTracks()
                                  .isNotEmpty
                              ? (isRemoteCameraOpen
                                  ? RTCVideoView(
                                      filterQuality: FilterQuality.medium,
                                      _remoteRenderer,
                                      objectFit: RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitCover,
                                    )
                                  : Container(
                                      color: Colors.grey.shade800,
                                      child: Center(
                                        child: SizedBox(
                                          width: size.width * 0.4,
                                          height: size.height * 0.4,
                                          child: const Icon(Icons.videocam_off,
                                              color: Colors.white, size: 100),
                                        ),
                                      ),
                                    ))
                              : Container(
                                  color: Colors.grey.shade800,
                                  child: Center(
                                    child: SizedBox(
                                      width: size.width * 0.4,
                                      height: size.height * 0.4,
                                      child: Image.asset(
                                        "assets/images/waiting-room.png",
                                      ),
                                    ),
                                  ),
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
                            const Text(
                              "Please wait, connecting....",
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 10,
              child: Container(
                width: size.width * 0.25,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: !isCameraOpen && _localRenderer.srcObject != null
                    ? RTCVideoView(
                        filterQuality: FilterQuality.medium,
                        _localRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
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
                      onPressed: () async {
                        _toggleMute();
                        // await signaling.updateMediaStatus(
                        //   widget.roomId,
                        //   widget.isCreating ? "caller" : "callee",
                        //   isMicOn: !isMuted,
                        // );
                      },
                      icon: Icon(
                        Icons.mic_off,
                        size: 24,
                        color: isMuted ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                      color: isCameraOpen ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        _toggleCamera();
                        // await signaling.updateMediaStatus(
                        //   widget.roomId,
                        //   widget.isCreating ? "caller" : "callee",
                        //   isCameraOn: isCameraOpen,
                        // );
                      },
                      icon: Icon(
                        isCameraOpen ? Icons.videocam : Icons.videocam_off,
                        size: 24,
                        color: isCameraOpen ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await signaling.hangUp(
                            widget.roomId,
                            _localRenderer.srcObject!,
                            _remoteRenderer.srcObject!,
                            true);
                        await _routeToHome();
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

  void _toggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    var audioTracks = _localRenderer.srcObject?.getAudioTracks();
    if (audioTracks != null) {
      for (var track in audioTracks) {
        track.enabled = !isMuted;
      }
    }
    await signaling.updateMediaStatusInCall(
      widget.roomId,
      widget.isCreating ? "caller" : "callee",
      !isCameraOpen,
      !isMuted
    );
  }

  void _toggleCamera() async {
    setState(() {
      isCameraOpen = !isCameraOpen;
    });
    var videoTracks = _localRenderer.srcObject?.getVideoTracks();
    if (videoTracks != null) {
      for (var track in videoTracks) {
        track.enabled = !isCameraOpen;
      }
    }
    await signaling.updateMediaStatusInCall(
        widget.roomId,
        widget.isCreating ? "caller" : "callee",
        !isCameraOpen,
        !isMuted
    );
  }

  void _sendCallNotification(model.VideoCallRequest req) async {
    String url = "${AppConstants.SERVER_IP}/notify/call-mentor";
    final body = {
      "userId": req.userId,
      "userName": req.userName,
      "callType": req.callType,
      "roomId": req.roomId
    };
    await dio.post(url, data: body);
  }
}
