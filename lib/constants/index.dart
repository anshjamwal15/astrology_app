import 'package:astrology_app/models/index.dart';
import 'package:flutter/material.dart';

export 'test_data_astrologer.dart';

class AppConstants {

  static final Color bgColor = Colors.grey.shade100;

  static bool isUserMentor = false;

  static User? appStateUser;

  static const String SERVER_IP = "http://192.168.11.19:3000";

}