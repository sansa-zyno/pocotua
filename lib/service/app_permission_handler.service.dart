/*import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';

class AppPermissionHandlerService {
  //MANAGE BACKGROUND SERVICE PERMISSION
  Future<bool> handleBackgroundRequest() async {
    //check for permission
    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      final result = await Get.defaultDialog(
        barrierDismissible: false,
        title: "Background Permission Request",
        middleText:
            "This app requires your background permission to enable app receive new post notifications even when app is in background",
        textConfirm: "Next",
        onConfirm: () {
          Get.back(result: true);
        },
        textCancel: "Cancel",
        onCancel: () {
          Get.back(result: false);
        },
      );

      print(result);
      //
      if (result != null && (result is bool) && result) {
        hasPermissions = result;
      }
    }
    return hasPermissions;
  }
}*/
