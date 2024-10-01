import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/index.dart';
import 'package:astrology_app/services/notification_service.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  String title = message.data['title'];
  String body = message.data['body'];
  String type = message.data['type'];

  if (type == "call") {
    String callType = message.data['callType'];
    String roomId = message.data['roomId'];
    String callerId = message.data['creatorId'];
    String calleeId = message.data['calleeId'];
    NotificationService.createCallNotification(title, body, callType, roomId, type, callerId, calleeId);
  } else {
    String senderId = message.data['senderId'];
    NotificationService.createMessageNotification(title, body, senderId, type);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  await NotificationService.initializeNotifications(navigatorKey);
  await UserManager.instance.loadUser();
  runApp(App(navigatorKey: navigatorKey, authenticationRepository: AuthenticationRepository()));
}
