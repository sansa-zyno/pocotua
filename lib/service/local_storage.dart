import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static setString(key, data) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(key, data);
  }

  static getString(key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getString(key);
  }

  static setBool(key, data) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool(key, data);
  }

  static getBool(key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getBool(key);
  }
}
