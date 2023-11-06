import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/home.dart';
import 'package:news_app/post_screen.dart';

class NotificationService {
  //
  //static const platform = MethodChannel('notifications.pocotua');
  //
  static initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/poco_not',
        [
          appNotificationChannel(),
          //newOrderNotificationChannel(),
        ]);
    //requet notifcation permission if not allowed
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  /*static Future<void> clearIrrelevantNotificationChannels() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      // get channels
      final List<dynamic> notificationChannels =
          await platform.invokeMethod('getChannels');

      //confirm is more than the required channels is found
      final notificationChannelNames = notificationChannels
          .map(
            (e) => e.toString().split(" -- ")[1],
          )
          .toList();

      //
      final totalFound = notificationChannelNames
          .where(
            (e) =>
                e.toLowerCase() ==
                appNotificationChannel().channelName!.toLowerCase(),
          )
          .toList();

      if (totalFound.length > 1) {
        //delete all app created notifications
        for (final notificationChannel in notificationChannels) {
          //
          final notificationChannelData = "$notificationChannel".split(" -- ");
          final notificationChannelId = notificationChannelData[0];
          final notificationChannelName = notificationChannelData[1];
          final isSystemOwned =
              notificationChannelName.toLowerCase() == "miscellaneous";
          //
          if (!isSystemOwned) {
            //
            await platform.invokeMethod(
              'deleteChannel',
              {"id": notificationChannelId},
            );
          }
        }

        //
        await initializeAwesomeNotification();
      }
    } on PlatformException catch (e) {
      print("Failed to get notificaiton channels: '${e.message}'.");
    }
  }*/

  static NotificationChannel appNotificationChannel() {
    //firebase fall back channel key
    //fcm_fallback_notification_channel
    return NotificationChannel(
      channelKey: 'pocotua',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for Pocotua app',
      importance: NotificationImportance.High,
      soundSource: "resource://raw/alert",
      playSound: true,
    );
  }

  /*static NotificationChannel newOrderNotificationChannel() {
    return NotificationChannel(
      channelKey: 'new_order_channel',
      channelName: 'New Order notifications',
      channelDescription: 'New Order notification channel for app',
      importance: NotificationImportance.High,
      soundSource: "resource://raw/neworderalert",
      playSound: true,
    );
  }*/

  static listenToActions() {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      //if notification is from order

      if (receivedNotification.payload != null) {
        print(receivedNotification.payload!["link"]!);
        Get.to(() => PostScreen(receivedNotification.payload!["link"]!));
      }
    });
  }
}
