import 'package:astrology_app/constants/app_constants.dart';
import 'package:astrology_app/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.initialMessage});

  final RemoteMessage? initialMessage;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeIn = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Handle initial message after splash screen
    if (widget.initialMessage != null) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _handleInitialMessage();
        }
      });
    }
  }

  void _handleInitialMessage() {
    if (widget.initialMessage == null) return;

    final message = widget.initialMessage!;
    String type = message.data['type'] ?? 'message';

    if (type == 'call') {
      String roomId = message.data['roomId'] ?? '';
      String callerId = message.data['creatorId'] ?? '';
      String calleeId = message.data['calleeId'] ?? '';
      String callType = message.data['callType'] ?? 'video';

      NotificationService.navigateToCallScreen(
          context, roomId, callType, callerId, calleeId);
    } else if (type == 'message') {
      String senderId = message.data['senderId'] ?? '';
      NotificationService.navigateToMessageScreen(context, senderId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                scale: 6,
              ),
              const SizedBox(height: 20),
              Text(
                'Mindaro Sewa',
                style: TextStyle(
                  fontSize: 24,
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // TODO: Make use of Remote message
              Text(
                'Loading your experience...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
