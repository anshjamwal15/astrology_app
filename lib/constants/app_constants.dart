import 'package:flutter/material.dart';

export 'test_data_astrologer.dart';

class AppConstants {
  static final Color bgColor = Colors.grey.shade100;

  static final Color primaryColor = Colors.blue.shade900;

  static final Color primaryColorTwo =
      Color.lerp(Colors.blue.shade900, Colors.white, 0.2)!;
  // Colors.blue.shade700;

  static final Color primaryColorThree =
      Color.lerp(Colors.blue.shade900, Colors.white, 0.4)!;
  // Colors.blue.shade500;

  static const Color secondaryColor = Color(0xFF121130);

  static const Color accentColor = Color(0xFFff811d);

  static bool isUserMentor = false;

  static bool isLoaderRunning = false;

  // ignore: constant_identifier_names
  static const String SERVER_IP = "http://dekhokaun.com:3000";
}
