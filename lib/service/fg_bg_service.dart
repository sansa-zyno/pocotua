/*import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:news_app/service/local_storage.dart';

class FGBGService {
  StreamSubscription<FGBGType>? subscriptionFGBGType;

  void fbListener() {
    //
    LocalStorage.setBool("appInBackground", false);
    //
    subscriptionFGBGType = FGBGEvents.stream.listen((event) {
      final appInBackground = (event == FGBGType.background);
      LocalStorage.setBool("appInBackground", appInBackground);
    });
  }

  Future<bool> appIsInBackground() async {
    return await LocalStorage.getBool("appInBackground") ?? false;
  }

  void dispose() {
    subscriptionFGBGType?.cancel();
  }
}*/
