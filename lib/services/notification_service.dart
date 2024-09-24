import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle iOS local notification
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        notificationTapBackground(response, navigatorKey);
      },
    );
  }

  static Future<void> createCallNotification(
      String title,
      String body,
      String callType,
      String roomId,
      String type,
      String callerId,
      String calleeId) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'call_channel', // Channel ID
      'Call Notifications', // Channel Name
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      // playSound: true,
      actions: [
        AndroidNotificationAction(
            'ANSWER', // Action Key
            'Answer', // Action Title
            titleColor: Colors.green,
            showsUserInterface: true),
        AndroidNotificationAction(
            'DECLINE', // Action Key
            'Decline', // Action Title
            titleColor: Colors.red,
            showsUserInterface: true),
      ],
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload:
          'roomId=$roomId&type=$type&callerId=$callerId&calleeId=$calleeId&callType=$callType', // Custom payload to handle tap
    );
  }

  static Future<void> createMessageNotification(
      String title, String body, String senderId, String type) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'message_channel', // Channel ID
      'Message Notifications', // Channel Name
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      1, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'senderId=$senderId&type=$type', // Custom payload to handle tap
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse, GlobalKey<NavigatorState> navigatorKey) {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      var data = Uri.splitQueryString(payload);
      printError(data);
      if (data['type'] == 'call') {
        String roomId = data['roomId']!;
        String callerId = data['callerId']!;
        String calleeId = data['calleeId']!;
        String callType = data['callType']!;
        _isCallScreen(true, navigatorKey, roomId, callType, callerId, calleeId);
      } else if (data['type'] == 'message') {
        String senderId = data['senderId']!;
        _isCallScreen(false, navigatorKey, senderId);
      }
    }
  }

  static _isCallScreen(bool isCall, GlobalKey<NavigatorState> navigatorKey, String id, [String? callType, String? callerId, String? calleeId]) {
    if (isCall) {
      Navigator.of(navigatorKey.currentState!.context).pushReplacement(
        MaterialPageRoute(
          builder: (builder) => (callType == "video" || callType == null)
              ? VideoCallScreen(roomId: id, isCreating: false, mentorId: calleeId, creatorId: callerId)
              : VoiceCall(roomId: id, isCreating: false),
        ),
      );
      return;
    }
    Navigator.of(navigatorKey.currentState!.context).pushReplacement(
        MaterialPageRoute(
          builder: (builder) => ChatScreen(senderId: id),
        )
    );
  }
}
