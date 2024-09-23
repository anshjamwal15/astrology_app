import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

createCallNotification(String title, String body, String callType, String roomId, String type) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 84893,
        channelKey: "call_channel",
        title: title,
        body: body,
        payload: {
          'callType': callType,
          'roomId': roomId,
          'type': type
        },
        category: NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        locked: true,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.white,
      ),
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
          actionType: ActionType.DisabledAction
        )
      ]);
}

createMessageNotification(String title, String body, String senderId, String type) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 84894,
        channelKey: "message_channel",
        title: title,
        body: body,
        payload: {
          'senderId': senderId,
          'type': type
        },
        category: NotificationCategory.Message,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.white,
      ));
}
