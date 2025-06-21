import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/index.dart';
import 'package:astrology_app/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final AuthenticationRepository _authRepository = AuthenticationRepository();

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  print('Handling a background message: ${message.messageId}');
  
  String title = message.data['title'] ?? message.notification?.title ?? 'New Message';
  String body = message.data['body'] ?? message.notification?.body ?? '';
  String type = message.data['type'] ?? 'message';

  if (type == "call") {
    String callType = message.data['callType'] ?? 'video';
    String roomId = message.data['roomId'] ?? '';
    String callerId = message.data['creatorId'] ?? '';
    String calleeId = message.data['calleeId'] ?? '';
    
    await NotificationService.createCallNotification(
        title, body, callType, roomId, type, callerId, calleeId);
  } else {
    String senderId = message.data['senderId'] ?? '';
    await NotificationService.createMessageNotification(title, body, senderId, type);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Set device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize notification service first
  await NotificationService.initializeNotifications(navigatorKey);
  
  // Set up Firebase Messaging background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Handle foreground messages
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  
  // Handle notification taps when app is in background but not killed
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    _handleNotificationTap(message);
  });
  
  // Check if app was launched from a notification (killed state)
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('App launched from notification: ${initialMessage.messageId}');
    // Handle the initial message after app initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNotificationTap(initialMessage);
    });
  }
  
  // Refresh user data
  await _authRepository.refreshUser();
  
  runApp(App(
      navigatorKey: navigatorKey, 
      authenticationRepository: _authRepository,
      initialMessage: initialMessage));
}

void _handleNotificationTap(RemoteMessage message) {
  final context = navigatorKey.currentContext;
  if (context == null) return;
  
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