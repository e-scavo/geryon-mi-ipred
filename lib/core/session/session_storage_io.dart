import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';

class SessionStorage {
  static const _key = 'user_dni';

  static Future<void> saveDni(String dni) async {
    developer.log(
      '${LogIcons.save} [IO] saveDni: $dni',
      name: 'SessionStorage',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, dni);
  }

  static Future<String?> getSavedDni() async {
    developer.log(
      '${LogIcons.download} [IO] getSavedDni',
      name: 'SessionStorage',
    );

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clear() async {
    developer.log(
      '${LogIcons.cross} [IO] clear',
      name: 'SessionStorage',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> remove(String key) async {
    developer.log(
      '${LogIcons.cross} [IO] remove($key)',
      name: 'SessionStorage',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
