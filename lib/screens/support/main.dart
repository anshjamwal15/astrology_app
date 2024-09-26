import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as mentor;
import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:astrology_app/screens/support/cubits/mentor_cubit.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum RequestType {
  video,
  voice,
  chat
}

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
    final me = UserManager.instance.user;
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
              return Center(
                child: CircularProgressIndicator(color: Colors.blue.shade900),
              );
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
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade900,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading mentor'),
                        );
                      } else if (snapshot.hasData) {
                        final mentor = snapshot.data!;
                        final perMinRate = mentor.mentorRate?.videoMRate;
                        final mentorName = '${mentor.firstName} ${mentor.lastName}';
                        if (mentor.userId != me!.id) {
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
                                          mentorName,
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
                                          "${mentor.totalExpYrs} years | \u{20B9}$perMinRate/minute",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: size.width * 0.12),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {

                                            // _customDialogBox(RequestType.chat, perMinRate.toString(), mentorName, {'mentorId': mentor.userId});
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
                                            final roomId = UniqueIdGenerator.generate();
                                            final data = {
                                              'roomId': roomId,
                                              'isCreating': true,
                                              'userName': me.name,
                                              'creatorId': me.id,
                                              'mentorId': mentor.userId,
                                            };
                                            _customDialogBox(RequestType.voice, perMinRate.toString(), mentorName, data);
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
                                            final roomId = UniqueIdGenerator.generate();
                                            final data = {
                                              'roomId': roomId,
                                              'isCreating': true,
                                              'userName': me.name,
                                              'creatorId': me.id,
                                              'mentorId': mentor.userId,
                                            };
                                            _customDialogBox(RequestType.video, perMinRate.toString(), mentorName, data);
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
                                                  color: Colors.black,
                                                ),
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

  void _customDialogBox(RequestType type, String amount, String userName, [Map<String, dynamic>? payload]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call confirmation to $userName'),
          content: Text(
            'You will be charged \u{20B9}$amount/minute. Click ok to proceed',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: AppConstants.bgColor,
          actionsPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                if (type == RequestType.chat) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(
                            senderId: payload?['mentorId'],
                          ),
                    ),
                  );
                } else if (type == RequestType.voice) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VoiceCall(
                            roomId: payload?['roomId'],
                            isCreating: payload?['isCreating'],
                            userName: payload?['userName'],
                            creatorId: payload?['creatorId'],
                            mentorId: payload?['mentorId'],
                          ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VoiceCall(
                            roomId: payload?['roomId'],
                            isCreating: payload?['isCreating'],
                            userName: payload?['userName'],
                            creatorId: payload?['creatorId'],
                            mentorId: payload?['mentorId'],
                          ),
                    ),
                  );
                }
              },
              child:
              const Text('Proceed', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  showErrorDialog() {
    showDialog(
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
             onPressed: () {
                Navigator.pop(context);
             },
              child: const Text('CLOSE', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  checkUserWalletBalance() {

  }
}

