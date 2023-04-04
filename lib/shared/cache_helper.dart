import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static SharedPreferences? sharedPreferencesFirstRun;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferencesFirstRun = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static dynamic getDataFirstRun({required String key}) {
    return sharedPreferencesFirstRun!.getString(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    }
    if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    }
    if (value is List<String>) {
      return await sharedPreferences!.setStringList(key, value);
    }
    return await sharedPreferences!.setInt(key, value);
  }

  static Future<bool> saveDataFirstRun(
      {required String key, required String value}) async {
      return await sharedPreferencesFirstRun!.setString(key, '$value');
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  static late SharedPreferences _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> initt() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }


  static Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static String? getString(String key) => _prefs.getString(key);

}
