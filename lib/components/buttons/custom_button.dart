import 'package:astrology_app/screens/home/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 10,
        shadowColor: Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.white, width: 0.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Text(
        'LOGIN',
        style: GoogleFonts.acme(
          fontSize: 20,
          shadows: [
            Shadow(
              offset: const Offset(0, 3.0),
              blurRadius: 6,
              color: Colors.white60.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
