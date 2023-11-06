  //await initializeBackgroundService();
 /* Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: false);
      
  // Periodic task registration
  Workmanager().registerPeriodicTask(
      "2",

      //This is the value that will be
      // returned in the callbackDispatcher
      "simplePeriodicTask",

      // When no frequency is provided
      // the default 15 minutes is set.
      // Minimum frequency is 15 min.
      // Android will automatically change
      // your frequency to 15 min
      // if you have configured a lower frequency.
      initialDelay: Duration(seconds: 5),
      frequency: Duration(minutes: 15),
      constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false));*/

//Due to some reasons,didnt not work on android 12
/*Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId:
          NotificationService.appNotificationChannel().channelKey!,
      initialNotificationTitle: 'Pocotua background service',
      initialNotificationContent: 'Background notification to keep app running',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  /*WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);*/

  return true;
}

@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  //DartPluginRegistrant.ensureInitialized();
  SharedPreferences? prefs;

  setString(key, data) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(key, data);
  }

  getString(key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getString(key);
  }

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 15), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /*String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();*/
        String lastItem = await api();
        Map llastItem = jsonDecode(lastItem);
        String savedLastItem = await getString("lastItem") ?? "{\"id\":0}";
        Map ssaveLastItem = jsonDecode(savedLastItem);
        print("xxxxxxxxxx");
        if (llastItem["id"] != ssaveLastItem["id"]) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 888,
                channelKey:
                    NotificationService.appNotificationChannel().channelKey!,
                title: "${llastItem["title"]["rendered"]}",
                body: "",
                icon: "resource://drawable/notification",
                // notificationLayout: NotificationLayout.BigPicture,
                //bigPicture: "resource://drawable/launcher_icon",
                payload: {"link": "${llastItem["link"]}"}),
            /*schedule: NotificationInterval(
                  interval: 60, timeZone: localTimeZone, repeats: true)*/
          );
        }
        setString("lastItem", lastItem);
        service.invoke(
          'update',
          {
            "current_date": DateTime.now().toIso8601String(),
          },
        );
      }
    }
  });
}*/

/*
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
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
      dev.log("before first time calling shared prefs");
      Map llastItem = jsonDecode(lastItem);
      String savedLastItem = await getString("lastItem") ?? "{\"id\":0}";
      Map ssaveLastItem = jsonDecode(savedLastItem);
      if (llastItem["id"] != ssaveLastItem["id"]) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: Random().nextInt(20),
                channelKey:
                    NotificationService.appNotificationChannel().channelKey!,
                title: "${llastItem["title"]["rendered"]}",
                body: "",
                icon: "resource://drawable/notification",
                // notificationLayout: NotificationLayout.BigPicture,
                //bigPicture: "resource://drawable/launcher_icon",
                payload: {"link": "${llastItem["link"]}"}),
            schedule: NotificationInterval(
                interval: 900, timeZone: localTimeZone, repeats: true));
      }
      setString("lastItem", lastItem);
    } catch (e) {
      // Logger flutter package, prints error on the debug console
      dev.log(e.toString());
      throw Exception(e);
    }
    return Future.value(true);
  });
}

Future<String> api() async {
  Response response = await Dio().get("http://pocotua.com/wp-json/wp/v2/posts");
  //Response response = await Dio().get("http://lionstakers.com/api/test.php");

  List list = response.data;
  //List list = jsonDecode(response.data);
  String lastItem = jsonEncode(list.last);
  return lastItem;
}*/