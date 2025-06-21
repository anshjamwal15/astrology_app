import 'package:flutter/services.dart';

class PlatformNotificationService {
  static const MethodChannel _channel = MethodChannel('com.example.astrology_app/notification');

  static Future<Map<String, dynamic>?> getInitialNotification() async {
    try {
      final result = await _channel.invokeMethod('getInitialNotification');
      return result != null ? Map<String, dynamic>.from(result) : null;
    } on PlatformException catch (e) {
      print("Failed to get initial notification: '${e.message}'.");
      return null;
    }
  }

  static void setNotificationTapHandler(Function(Map<String, dynamic>) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationTap') {
        final arguments = Map<String, dynamic>.from(call.arguments);
        handler(arguments);
      }
    });
  }
}