import 'dart:async';

import 'package:astrology_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    user?.sendEmailVerification();

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    final verified = refreshedUser?.emailVerified ?? false;
    if (!mounted) return;

    setState(() {
      isEmailVerified = verified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      if (mounted) {
        _showSnackBar();
        _navigateBack();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("We have sent you an email. Please check your inbox."),
      ),
    );
  }

  void _showSnackBar() {
    if (!mounted) return;
    showFloatingSnackBar(context, "Email Successfully Verified, Please Login");
  }

  void _navigateBack() {
    if (!mounted) return;
    Navigator.pop(context);
  }
}
