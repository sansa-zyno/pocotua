import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:news_app/home.dart';
import 'package:news_app/service/notification.service.dart';
import 'package:news_app/service/local_storage.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> api() async {
  Response response = await Dio().get("http://pocotua.com/wp-json/wp/v2/posts");
  List list = response.data;
  String lastItem = jsonEncode(list.last);
  //dev.log(lastItem);
  return lastItem;
}

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  //print(taskId);
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    BackgroundFetch.finish(taskId);
    return;
  }
  // Do your work here...
  SharedPreferences? prefs;
  setString(key, data) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(key, data);
  }

  getString(key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getString(key);
  }

  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
  String lastItem = await api();
  //dev.log("before first time calling shared prefs");
  Map llastItem = jsonDecode(lastItem);
  String savedLastItem = await getString("lastItem") ?? "{\"id\":0}";
  Map ssaveLastItem = jsonDecode(savedLastItem);
  if (llastItem["id"] != ssaveLastItem["id"]) {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            autoDismissible: false,
            id: Random().nextInt(20),
            channelKey:
                NotificationService.appNotificationChannel().channelKey!,
            title: "${llastItem["title"]["rendered"]}",
            body: "",
            icon: "resource://drawable/poco_not",
            notificationLayout: NotificationLayout.Default,
            //largeIcon: "resource://drawable/poco_not",
            //roundedLargeIcon: true,
            payload: {"link": "${llastItem["link"]}"}),
        schedule: NotificationInterval(interval: 900, timeZone: localTimeZone));
  }
  await setString("lastItem", lastItem);
  //dev.log("from headless task");

  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterStatusbarcolor.setStatusBarColor(Color(0xffff0036));
  await NotificationService.initializeAwesomeNotification();
  await NotificationService.listenToActions();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            startOnBoot: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      //print("[BackgroundFetch] Event received $taskId");
      String lastItem = await api();
      Map llastItem = jsonDecode(lastItem);
      String savedLastItem =
          await LocalStorage.getString("lastItem") ?? "{\"id\":0}";
      Map ssaveLastItem = jsonDecode(savedLastItem);
      if (llastItem["id"] != ssaveLastItem["id"]) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(20),
              autoDismissible: false,
              channelKey:
                  NotificationService.appNotificationChannel().channelKey!,
              title: "${llastItem["title"]["rendered"]}",
              body: "",
              icon: "resource://drawable/poco_not",
              notificationLayout: NotificationLayout.Default,
              //largeIcon: "resource://drawable/poco_not",
              //roundedLargeIcon: true,
              payload: {"link": "${llastItem["link"]}"}),
        );
      }
      await LocalStorage.setString("lastItem", lastItem);
      //dev.log("from foreground/background");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      //print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    //print('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //FGBGService().fbListener();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Pocotua',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}
