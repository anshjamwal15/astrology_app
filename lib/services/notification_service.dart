import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? _navigatorKey;

  static Future<void> initializeNotifications(
      GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle iOS local notification
        if (payload != null) {
          _handleNotificationPayload(payload);
        }
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Check if app was launched from notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationResponse(response);
      },
    );

    // Handle app launch from notification in killed state
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp &&
        notificationAppLaunchDetails.notificationResponse != null) {
      // Delay handling to ensure app is fully initialized
      Future.delayed(const Duration(milliseconds: 1000), () {
        _handleNotificationResponse(
            notificationAppLaunchDetails.notificationResponse!);
      });
    }

    // Request notification permissions
    await _requestNotificationPermissions();
  }

  static Future<void> _requestNotificationPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    const DarwinInitializationSettings iosImplementation =
        DarwinInitializationSettings();

    /*  await iosImplementation.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    */
  }

  static Future<void> createCallNotification(
    String title,
    String body,
    String callType,
    String roomId,
    String type,
    String callerId,
    String calleeId,
  ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'Notifications for incoming calls',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("incoming_call"),
      category: AndroidNotificationCategory.call,
      ongoing: true,
      autoCancel: false,
      actions: [
        AndroidNotificationAction(
          'ANSWER',
          'Answer',
          titleColor: Colors.green,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'DECLINE',
          'Decline',
          titleColor: Colors.red,
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      categoryIdentifier: 'call_category',
      interruptionLevel: InterruptionLevel.critical,
    );

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload:
          'roomId=$roomId&type=$type&callerId=$callerId&calleeId=$calleeId&callType=$callType',
    );
  }

  static Future<void> createMessageNotification(
      String title, String body, String senderId, String type) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'message_channel',
      'Message Notifications',
      channelDescription: 'Notifications for new messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
      payload: 'senderId=$senderId&type=$type',
    );
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      _handleNotificationPayload(response.payload!);
    }
  }

  static void _handleNotificationPayload(String payload) {
    final context = _navigatorKey?.currentContext;
    if (context == null) {
      // If context is not available, retry after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationPayload(payload);
      });
      return;
    }

    var data = Uri.splitQueryString(payload);
    String type = data['type'] ?? 'message';

    if (type == 'call') {
      String roomId = data['roomId'] ?? '';
      String callerId = data['callerId'] ?? '';
      String calleeId = data['calleeId'] ?? '';
      String callType = data['callType'] ?? 'video';

      navigateToCallScreen(context, roomId, callType, callerId, calleeId);
    } else if (type == 'message') {
      String senderId = data['senderId'] ?? '';
      navigateToMessageScreen(context, senderId);
    }
  }

  static void navigateToCallScreen(
    BuildContext context,
    String roomId,
    String callType,
    String callerId,
    String calleeId,
  ) {
    // Cancel any existing call notifications
    _flutterLocalNotificationsPlugin.cancel(0);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => (callType == "video")
            ? VideoCallScreen(
                roomId: roomId,
                isCreating: false,
                mentorId: calleeId,
                creatorId: callerId,
                isMentor: false,
              )
            : VoiceCall(
                roomId: roomId,
                isCreating: false,
                mentorId: calleeId,
                creatorId: callerId,
                isMentor: false,
              ),
      ),
      (route) => false,
    );
  }

  static void navigateToMessageScreen(BuildContext context, String senderId) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ChatScreen(senderId: senderId, isMentor: true),
      ),
      (route) => false,
    );
  }

  // Method to clear all notifications
  static Future<void> clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Method to clear specific notification
  static Future<void> clearNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
