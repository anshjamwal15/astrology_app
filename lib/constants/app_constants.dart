// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

export 'test_data_astrologer.dart';

// TODO: Change urls using custom remote config solution
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

  static const String FCM_URL = "http://dekhokaun.com:3000";

  static const String SERVER_URL = "http://3.108.112.130:3000/api";
}
