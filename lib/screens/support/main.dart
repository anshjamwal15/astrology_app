import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as mentor;
import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:astrology_app/screens/support/cubits/mentor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MentorCubit>().loadMentors();
  }

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
        child: BlocBuilder<MentorCubit, MentorState>(
          builder: (context, state) {
            if (state is MentorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MentorLoaded) {
              final mentors = state.mentors;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: mentors.map((mentorFuture) {
                  return FutureBuilder<mentor.Mentor>(
                    future: mentorFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading mentor'),
                        );
                      } else if (snapshot.hasData) {
                        final mentor = snapshot.data!;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${mentor.firstName} ${mentor.lastName}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Business support | ${mentor.rating}/ 5",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${mentor.totalExpYrs} years | 1 Rs/ minute",
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
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChatScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.green.shade100,
                                          ),
                                          width: size.width * 0.16,
                                          height: size.height * 0.03,
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Chat",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const VoiceCall(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.green.shade100,
                                          ),
                                          width: size.width * 0.16,
                                          height: size.height * 0.03,
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Call",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const VideoCallScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.green.shade100,
                                          ),
                                          width: size.width * 0.16,
                                          height: size.height * 0.03,
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Meeting",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  );
                }).toList(),
              );
            } else if (state is MentorError) {
              return const Center(
                  child: Text('Something went wrong, Please try again'));
            } else {
              return const Center(child: Text('No mentors available'));
            }
          },
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
