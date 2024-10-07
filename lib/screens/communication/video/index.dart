import 'dart:async';

import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as model;
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:astrology_app/services/signaling_service.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  final String roomId;
  final bool isCreating;
  final String? mentorId;
  final String? userName;
  final String? creatorId;
  final int? chatRate;
  final int? walletBalance;
  final bool isMentor;
  const VideoCallScreen({
    super.key,
    required this.roomId,
    required this.isCreating,
    this.mentorId,
    this.userName,
    this.creatorId,
    this.chatRate,
    this.walletBalance,
    required this.isMentor
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
  bool isRemoteMicOpen = true;
  StreamSubscription<Map<String, dynamic>?>? mediaStatusSubscription;
  int _seconds = 0;
  final user = UserManager.instance.user;
  final PaymentRepository _paymentRepository = PaymentRepository();
  Timer? _timer;
  int _minutesElapsed = 0;

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

    signaling.onAddRemoteStream = (stream) {
      _startTimer();
      if (!user!.isMentor) {
        _stateUserTimer();
      }
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    signaling.onAddConnectionStream = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected || state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _localRenderer.dispose();
        _remoteRenderer.dispose();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (builder) => const MainScreen(),
          ),
        );
      }
    };

    signaling.onAddIceConnectionStream = (state) {
      if (widget.isCreating && state == RTCIceGatheringState.RTCIceGatheringStateGathering) {
        final req = model.CallRequest(
          roomId: widget.roomId,
          userId: widget.mentorId!,
          creatorId: widget.creatorId!,
          callType: "video",
          userName: widget.userName!,
        );
        _sendCallNotification(req);
        signaling.createCallEntry(
          widget.roomId,
          widget.creatorId!,
          widget.mentorId!,
          "video"
        );
      }
    };

    mediaStatusSubscription = signaling
        .listenToStatus(
      widget.roomId,
      widget.isCreating ? "callee" : "caller",
      widget.creatorId,
      widget.mentorId,
    ).listen((mediaStatus) {
      if (mediaStatus != null) {
        setState(() {
          isRemoteCameraOpen = mediaStatus['isCameraOn'] ?? true;
          isRemoteMicOpen = mediaStatus['isMicOn'] ?? true;
        });
      }
    });
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

  void _stateUserTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _minutesElapsed++;
      if (mounted) {
        checkUserBalance(widget.walletBalance!, widget.chatRate!);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> checkUserBalance(int walletBalance, int chatRate) async {
    int totalCost = _minutesElapsed * chatRate;
    if (_remoteRenderer.srcObject == null) return;
    if (totalCost >= walletBalance) {
      if (mounted) {
        _remoteRenderer.dispose();
        showErrorDialog(context);
        await _paymentRepository.updateWalletBalance(userId: user!.id, transactionAmount: totalCost, isAdding: false);
        await _paymentRepository.updateWalletBalance(userId: widget.mentorId!, transactionAmount: totalCost, isAdding: true);
      }
      _timer?.cancel();
    } else {
      await _paymentRepository.updateWalletBalance(userId: user!.id, transactionAmount: totalCost, isAdding: false);
      await _paymentRepository.updateWalletBalance(userId: widget.mentorId!, transactionAmount: totalCost, isAdding: true);
    }
  }

  @override
  void dispose() {
    var localTracks = _localRenderer.srcObject?.getTracks();
    localTracks?.forEach((track) {
      track.stop();
    });

    signaling.hangUp(
        widget.roomId,
        _localRenderer.srcObject!,
        _remoteRenderer.srcObject!,
        true
    );

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
                          child: _remoteRenderer.srcObject != null &&
                              (_remoteRenderer.srcObject!.getVideoTracks().isNotEmpty ||
                                  _remoteRenderer.srcObject!.getAudioTracks().isNotEmpty)
                              ? (isRemoteCameraOpen
                              ? RTCVideoView(
                            filterQuality: FilterQuality.medium,
                            _remoteRenderer,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          )
                              : Container(
                            color: Colors.grey.shade800,
                            child: Center(
                              child: SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.4,
                                child: const Icon(
                                  Icons.videocam_off,
                                  color: Colors.white,
                                  size: 100,
                                ),
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
                    ? Stack(
                    children: [
                      RTCVideoView(
                        filterQuality: FilterQuality.medium,
                        _localRenderer,
                        mirror: true,
                        objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                      if (isMuted)
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.mic_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        )
                    ],
                )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.videocam_off,
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
                            true,
                            Timestamp.now(),
                            _formatTime(_seconds)
                        );
                        if (widget.walletBalance != null &&
                            widget.chatRate != null) {
                          await checkUserBalance(
                            widget.walletBalance!,
                            widget.chatRate!,
                          );
                        }
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

  showErrorDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text(
            'You do not have enough balance to proceed',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppConstants.bgColor,
          actionsPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () async {
                signaling.hangUp(
                    widget.roomId,
                    _localRenderer.srcObject!,
                    _remoteRenderer.srcObject!,
                    true
                );
                await _routeToHome();
              },
              child: const Text('CLOSE', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  _routeToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
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
      !isMuted,
      widget.creatorId,
      widget.mentorId
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
        !isMuted,
        widget.creatorId,
        widget.mentorId
    );
  }

  void _sendCallNotification(model.CallRequest req) async {
    String url = "${AppConstants.SERVER_IP}/notify/call-mentor";
    final body = {
      "userId": req.userId,
      "creatorId": req.creatorId,
      "userName": req.userName,
      "callType": req.callType,
      "roomId": req.roomId
    };
    await dio.post(url, data: body);
  }

  String _formatTime(int seconds) {
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
