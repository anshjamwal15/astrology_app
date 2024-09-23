import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/index.dart';
import 'package:astrology_app/services/notification_controller.dart';
import 'package:astrology_app/services/notification_service.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  String title = message.data['title'];
  String body = message.data['body'];
  String type = message.data['type'];

  if (type == "call") {
    String callType = message.data['callType'];
    String roomId = message.data['roomId'];
    createCallNotification(title, body, callType, roomId, type);
  } else {
    String senderId = message.data['senderId'];
    createMessageNotification(title, body, senderId, type);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await NotificationController.initNotifications();
  await NotificationController.initEventListeners(navigatorKey);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UserManager.instance.loadUser();
  runApp(App(navigatorKey: navigatorKey, authenticationRepository: AuthenticationRepository()));
}
