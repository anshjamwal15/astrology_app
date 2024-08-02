import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      backgroundColor: AppConstants.bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.04,
          horizontal: size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: testAstrologers.length,
              itemBuilder: (context, index) {
                final astrologer = testAstrologers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/user-1.jpg",
                            scale: 8,
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                astrologer.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Business support | ${astrologer.rating.toString()}/ 5",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${astrologer.experience.toString()} years | ${astrologer.rupeesPerMinute.toString()} Rs/ minute",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.18),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.shade100,
                                  ),
                                  width: size.width * 0.16,
                                  height: size.height * 0.03,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Chat",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const VoiceCall()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.shade100,
                                  ),
                                  width: size.width * 0.16,
                                  height: size.height * 0.03,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Call",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const VideoCallScreen()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.shade100,
                                  ),
                                  width: size.width * 0.16,
                                  height: size.height * 0.03,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Meeting",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
