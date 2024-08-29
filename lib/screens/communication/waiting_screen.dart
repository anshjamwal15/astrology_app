import 'package:astrology_app/blocs/video/video_call_bloc.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class WaitingScreen extends StatefulWidget {
  final bool isCreatingRoom;
  final String? roomId;

  const WaitingScreen({
    super.key,
    required this.isCreatingRoom,
    this.roomId,
  });

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final String userId = UserManager.instance.user!.id;

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    context.read<VideoCallBloc>().add(OpenUserMedia(localRenderer: _localRenderer, remoteRenderer: _remoteRenderer));
    if (widget.isCreatingRoom) {
      context.read<VideoCallBloc>().add(CreateRoom(roomId: userId, remoteRenderer: _remoteRenderer));
    } else if (widget.roomId != null) {
      context.read<VideoCallBloc>().add(JoinRoom(mentorId: widget.roomId!, remoteRenderer: _remoteRenderer));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          if (state is VideoCallRoomCreated || state is VideoCallJoined) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoCallScreen(
                  localRenderer: _localRenderer,
                  remoteRenderer: _remoteRenderer,
                  roomId: widget.isCreatingRoom ? userId : widget.roomId!,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Image.asset("assets/images/waiting.png", scale: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  "Please wait, while we connect your call...",
                  style: GoogleFonts.acme(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(color: Colors.blue.shade900),
              ),
            ],
          );
        },
      ),
    );
  }
}
