import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/screens/auth/login.dart';
import 'package:astrology_app/screens/communication/chat/chat_list.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  final _authRepository = AuthenticationRepository();

  Future<void> _requestPermission(bool isVideo) async {
    if (isVideo) {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();
    } else {
      await [
        Permission.microphone,
      ].request();
    }
  }

  Future<bool> _checkPermission() async {
    var camStatus = await Permission.camera.request();
    var micStatus = await Permission.microphone.request();
    if (camStatus.isDenied || micStatus.isDenied) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    User user = UserManager.instance.user!;
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("assets/images/logo.png", scale: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name.isNotEmpty == true
                                ? user.name
                                : "New User",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),
                          const Icon(Icons.edit, size: 20),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.4,
                        child: Text(
                          user.email.isNotEmpty == true
                              ? user.email
                              : "Not found",
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    _drawerOptions(size, "Home", Icons.home),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(
                      size,
                      "Wallet Transactions",
                      Icons.account_balance_wallet,
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatListScreen(),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder<ChatBloc, ChatState>(
                            builder: (context, state) {
                              int unreadCount = 0;
                              if (state is UnreadCountLoaded) {
                                unreadCount = state.count;
                              }
                              return badges.Badge(
                                badgeContent: Text(
                                  unreadCount.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                showBadge: unreadCount > 0,
                                child: const Icon(
                                  Icons.email_outlined,
                                  size: 25,
                                  color: Colors.black54,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: size.width * 0.03),
                          const Text(
                            "Inbox",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    InkWell(
                      onTap: () async {
                        final isGranted = await _checkPermission();
                        if (isGranted) {
                          _navigateToWaitingScreen(user.id, false);
                        } else {
                          _requestPermission(false);
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoiceCall(roomId: user.id, isCreating: true),
                            ),
                          );
                        },
                        child: _drawerOptions(size, "Test video call", Icons.call),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () async {
                        final isGranted = await _checkPermission();
                        if (isGranted) {
                          _navigateToWaitingScreen(user.id, true);
                        } else {
                          _requestPermission(true);
                        }
                      },
                      child: _drawerOptions(
                        size,
                        "Create Meeting",
                        Icons.meeting_room,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(size, "Order History", Icons.history),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(size, "Settings", Icons.settings),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () async {
                        await _authRepository.logOut();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: _drawerOptions(size, "Logout", Icons.logout),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToWaitingScreen(String userId, bool isVideo) {
    if (isVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            isCreating: true,
            roomId: userId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCall(
            isCreating: true,
            roomId: userId,
          ),
        ),
      );
    }
  }
}

Widget _drawerOptions(Size size, String name, IconData icon) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, color: Colors.black54, size: 25),
      SizedBox(width: size.width * 0.03),
      Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    ],
  );
}
