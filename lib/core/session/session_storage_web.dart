import 'dart:developer' as developer;

import 'package:web/web.dart' as web;

import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';

class SessionStorage {
  static const _key = 'user_dni';

  static Future<void> saveDni(String dni) async {
    developer.log(
      '${LogIcons.save} [Web] saveDni: $dni',
      name: 'SessionStorage',
    );

    web.window.localStorage.setItem(_key, dni);
  }

  static Future<String?> getSavedDni() async {
    developer.log(
      '${LogIcons.download} [Web] getSavedDni',
      name: 'SessionStorage',
    );

    return web.window.localStorage.getItem(_key);
  }

  static Future<void> removeSavedDni() async {
    developer.log(
      '${LogIcons.cross} [Web] removeSavedDni',
      name: 'SessionStorage',
    );

    web.window.localStorage.removeItem(_key);
  }

  static Future<void> clear() async {
    developer.log(
      '${LogIcons.cross} [Web] clear',
      name: 'SessionStorage',
    );

    web.window.localStorage.clear();
  }

  static Future<void> remove(String key) async {
    developer.log(
      '${LogIcons.cross} [Web] remove($key)',
      name: 'SessionStorage',
    );

    web.window.localStorage.removeItem(key);
  }
}
