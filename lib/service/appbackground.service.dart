/*import 'dart:io';

import 'package:flutter_background/flutter_background.dart';

import 'app_permission_handler.service.dart';

class AppbackgroundService {
  //

  startBg() async {
    if (Platform.isAndroid) {
      //
      final androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "",
        notificationText: "",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon: AndroidResource(
          name: 'notification',
          defType: 'drawable',
        ), // Default is ic_launcher from folder mipmap
      );

      //check for permission
      //CALL THE PERMISSION HANDLER
      final allowed =
          await AppPermissionHandlerService().handleBackgroundRequest();
      //
      if (allowed) {
        await FlutterBackground.initialize(androidConfig: androidConfig);
        await FlutterBackground.enableBackgroundExecution();
      }
    }
  }

  /*void stopBg() {
    // Platform.isAndroid
    if (Platform.isAndroid) {
      bool enabled = FlutterBackground.isBackgroundExecutionEnabled;
      if (enabled) {
        FlutterBackground.disableBackgroundExecution();
      }
    }
  }*/
}*/
