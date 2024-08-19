import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/repository/chat_repository.dart';
import 'package:astrology_app/screens/communication/chat/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            selectedColor: Colors.blue,
          ),

          /// Chat
          DotNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ChatBloc(ChatRepository()),
                      child: const ChatListScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_outlined),
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
