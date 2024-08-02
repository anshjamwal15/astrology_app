  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class VoiceCall extends StatefulWidget {
    const VoiceCall({super.key});

    @override
    State<VoiceCall> createState() => _VoiceCallState();
  }

  class _VoiceCallState extends State<VoiceCall> {
    int _seconds = 0;
    Timer? _timer;

    void _startTimer() {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }

    String _formatTime(int seconds) {
      // int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    @override
    void initState() {
      super.initState();
      _startTimer();
    }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final Size size = MediaQuery.of(context).size;
      return Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Saayeesha D'souza",
                    style: GoogleFonts.acme(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),  // Ensure the clipping matches the container's border radius
                      child: Image.asset(
                        "assets/images/astologer.jpg",
                        scale: 20,
                        fit: BoxFit.cover,  // This ensures the image covers the entire container
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.4),
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
                            color: Colors.white,
                            fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mic_off, size: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up_sharp, size: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 0.2),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call_end, size: 24, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
