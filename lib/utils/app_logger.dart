// ignore_for_file: unused_field
import 'package:flutter/foundation.dart';

class _AnsiColor {
  static const reset = '\x1B[0m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
  static const magenta = '\x1B[35m';
  static const white = '\x1B[37m';
}

class AppLogger {
  static void info(String message) {
    _printColored(message, _AnsiColor.green, label: 'INFO');
  }

  static void warning(String message) {
    _printColored(message, _AnsiColor.yellow, label: 'WARNING');
  }

  static void error(String message) {
    _printColored(message, _AnsiColor.red, label: 'ERROR');
  }

  static void debug(String message) {
    _printColored(message, _AnsiColor.cyan, label: 'DEBUG');
  }

  static void _printColored(String message, String color,
      {required String label}) {
    final timestamp = DateTime.now().toIso8601String();
    if (kDebugMode) {
      print('$color[$label][$timestamp] $message${_AnsiColor.reset}');
    }
  }
}
