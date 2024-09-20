import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

createCallNotification(RemoteNotification notification) {
  return AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 84893,
          channelKey: "call_channel",
          color: Colors.white,
          title: notification.title ?? "",
          body: notification.body ?? "",
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.orange),
      actionButtons: [
        NotificationActionButton(
          key: "ACCEPT",
          label: "Accept Call",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: "REJECT",
          label: "Reject Call",
          color: Colors.red,
          autoDismissible: true,
        )
      ]);
}
