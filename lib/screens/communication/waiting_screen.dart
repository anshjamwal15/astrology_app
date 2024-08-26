import 'package:astrology_app/blocs/video_call/video_call_bloc.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingScreen extends StatefulWidget {
  final String? userAId;
  final String? userBId;
  final bool isUserACreating;

  const WaitingScreen({
    super.key,
    this.userAId,
    this.userBId,
    this.isUserACreating = false,
  });

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WebRTCBloc>().add(InitializeWebRTC());
    if (widget.isUserACreating) {
      context.read<WebRTCBloc>().add(CreateOffer(widget.userAId!, widget.userBId!));
    } else {
      context.read<WebRTCBloc>().add(JoinRoom(widget.userAId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: BlocListener<WebRTCBloc, WebRTCState>(
        listener: (context, state) {
          print(state);
          if (state.isCallActive) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VideoCallScreen(),
              ),
            );
          }
        },
        child: Column(
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
        ),
      ),
    );
  }
}
