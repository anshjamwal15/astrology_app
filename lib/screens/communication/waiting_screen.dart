import 'package:astrology_app/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: Image.asset("assets/images/waiting.png", scale: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              "Please wait, While we connect your call...",
              style: GoogleFonts.acme(
                color: Colors.black,
                fontSize: 18
              ),
            ),
          )
        ],
      ),
    );
  }
}
