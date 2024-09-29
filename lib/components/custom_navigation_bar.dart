import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astrology_app/screens/call_logs/cubits/call_logs_cubit.dart';
import 'package:astrology_app/screens/call_logs/main.dart';
import 'package:astrology_app/screens/communication/chat/chat_list.dart';
import 'package:astrology_app/screens/home/main.dart';
import '../screens/communication/chat/cubits/chat_message_list_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    BlocProvider(create: (context) => ChatMessageListCubit(), child: const ChatListScreen()),
    BlocProvider(create: (context) => CallLogsCubit(), child: const CallLogsScreen()),
  ];

  void onTabTapped(int index) {
    if (index == 3) { // If Profile tab is selected
      showUpcomingSnackBar("Profile update coming soon");
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
  void showUpcomingSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OKAY',
          textColor: Colors.blue,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double iconWidth = size.width * 0.06;
    Color iconColor = Colors.blue.shade900;
    return Container(
      height: size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, iconColor, iconWidth, "Home", Icons.home_outlined, size),
          _buildNavItem(1, iconColor, iconWidth, "Messages", Icons.email_outlined, size),
          _buildNavItem(2, iconColor, iconWidth, "Calls", Icons.call_outlined, size),
          _buildNavItem(3, iconColor, iconWidth, "Profile", Icons.person_outlined, size),
        ],
      ),
    );
  }
  Widget _buildNavItem(int index, Color iconColor, double iconWidth, String label, IconData icon, Size size) {
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        decoration: BoxDecoration(
          border: selectedIndex == index
              ? Border(
            top: BorderSide(color: Colors.blue.shade900, width: 2),
          )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: iconWidth, color: selectedIndex == index ? iconColor : Colors.black),
              Text(
                label,
                style: TextStyle(
                    letterSpacing: 1,
                    color: selectedIndex == index ? iconColor : Colors.black,
                    fontSize: size.height * 0.016,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
