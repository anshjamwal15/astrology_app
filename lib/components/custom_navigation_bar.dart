import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/screens/communication/chat/chat_list.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(GetUnreadCount(UserManager.instance.user!.id));
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DotNavigationBar(
        marginR: const EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 0),
        paddingR: const EdgeInsets.only(bottom: 1, top: 1),
        itemPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        dotIndicatorColor: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        items: [
          /// Home
          DotNavigationBarItem(
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            selectedColor: Colors.blue.shade900,
          ),

          /// Chat
          DotNavigationBarItem(
            icon: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                int unreadCount = 0;
                if (state is UnreadCountLoaded) {
                  unreadCount = state.count;
                }
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatListScreen(),
                      ),
                    );
                  },
                  icon: badges.Badge(
                    badgeContent: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    showBadge: unreadCount > 0,
                    child: const Icon(
                      Icons.email_outlined,
                      size: 25,
                    ),
                  ),
                );
              },
            ),
            selectedColor: Colors.pink,
          ),

          /// Call
          DotNavigationBarItem(
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            selectedColor: Colors.orange,
          ),

          /// Meeting
          DotNavigationBarItem(
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.meeting_room),
            ),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, chat, call, meeting }
