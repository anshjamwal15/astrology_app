import 'dart:async';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/models/index.dart' as model;
import 'package:astrology_app/services/signaling_service.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceCall extends StatefulWidget {
  final String? mentorId;
  final String? userName;
  final String? creatorId;
  final String roomId;
  final bool isCreating;
  final int? chatRate;
  final int? walletBalance;
  final bool isMentor;

  const VoiceCall({
    super.key,
    required this.roomId,
    required this.isCreating,
    this.userName,
    this.mentorId,
    this.creatorId,
    this.chatRate,
    this.walletBalance,
    required this.isMentor
  });

  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  SignalingService signaling = SignalingService();
  final Dio dio = Dio();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final user = UserManager.instance.user;
  final PaymentRepository _paymentRepository = PaymentRepository();
  int _seconds = 0;
  bool _isMuted = false;
  StreamSubscription<Map<String, dynamic>?>? mediaStatusSubscription;
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
            builder: (builder) => const HomeScreen(),
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
          callType: "audio",
          userName: widget.userName!,
        );
        _sendCallNotification(req);
        signaling.createCallEntry(
            widget.roomId,
            widget.creatorId!,
            widget.mentorId!,
            "audio"
        );
      }
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
        widget.roomId,
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

  void _stateUserTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _minutesElapsed++;
      if (mounted) {
        _remoteRenderer.dispose();
        checkUserBalance(widget.walletBalance!, widget.chatRate!);
      } else {
        timer.cancel();
      }
    });
  }

  void checkUserBalance(int walletBalance, int chatRate) {
    int totalCost = _minutesElapsed * chatRate;
    if (totalCost >= walletBalance) {
      if (mounted) {
        _remoteRenderer.dispose();
        showErrorDialog(context);
      }
      _timer?.cancel();
    } else {
      _paymentRepository.updateWalletBalance(userId: user!.id, transactionAmount: totalCost, isAdding: false);
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
        false
    );

    _timer?.cancel();
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
                              "On call",
                              // "On call ${widget.isCreating ? "" : widget.userName}",
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
                                  color: _isMuted ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: _toggleMute,
                                  icon: Icon(
                                    _isMuted ? Icons.mic_off : Icons.mic,
                                    size: 24,
                                    color: _isMuted ? Colors.red : Colors.white,
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
                                  onPressed: () async {
                                    await signaling.hangUp(
                                        widget.roomId,
                                        _localRenderer.srcObject!,
                                        _remoteRenderer.srcObject!,
                                        false,
                                        Timestamp.now(),
                                        _formatTime(_seconds)
                                    );
                                    await _routeToHome();
                                  },
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

  _routeToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
      _localRenderer.srcObject?.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted;
      });
    });

    await signaling.updateMediaStatusInCall(
        widget.roomId,
        widget.isCreating ? "caller" : "callee",
        null,
        !_isMuted,
        widget.creatorId,
        widget.mentorId
    );
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
}