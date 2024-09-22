import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static ReceivedAction? action;

  static Future<void> initNotifications() async {
    AwesomeNotifications().initialize('resource://mipmap/ic_launcher', [
      NotificationChannel(
        channelKey: "call_channel",
        channelName: "Call Channel",
        channelDescription: "Channel of calling",
        // defaultColor: Colors.blue.shade900,
        // ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ),
      NotificationChannel(
        channelKey: "message_channel",
        channelName: "Message Channel",
        channelDescription: "Channel of messaging",
        // defaultColor: Colors.blue.shade900,
        // ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      )
    ]);
  }

  static Future<void> initEventListeners(GlobalKey<NavigatorState> navigatorKey) async {
    AwesomeNotifications().setListeners(onActionReceivedMethod: (action) => onActionReceivedMethod(action, navigatorKey));
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action, GlobalKey<NavigatorState> navigatorKey) async {
    if (action.payload != null) {
      // printError(navigatorKey.currentState!);
      String? type = action.payload?['type'];
      String? senderId = action.payload?['senderId'];
      // String? title = action.payload?['title'];
      // String? body = action.payload?['body'];
      if (type == "call") {
        String? callType = action.payload?['callType'];
        String? roomId = action.payload?['roomId'];
      } else {
        _isCallScreen(false, navigatorKey, senderId!);
      }
    }
  }

  static _isCallScreen(bool isCall, GlobalKey<NavigatorState> navigatorKey, String id) {
    if (isCall) {
      Navigator.of(navigatorKey.currentState!.context).pushReplacement(
          MaterialPageRoute(
            builder: (builder) => VideoCallScreen(roomId: id, isCreating: true),
          )
      );
    }
    Navigator.of(navigatorKey.currentState!.context).pushReplacement(
        MaterialPageRoute(
          builder: (builder) => ChatScreen(senderId: id),
        )
    );
  }
}