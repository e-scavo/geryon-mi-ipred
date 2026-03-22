// File: lib/models/ServiceProviderConfig/config_loader_web.dart
import 'dart:convert';
import 'package:web/web.dart' as web;
import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/ServiceProviderConfig/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ConfigLoaderPlatform {
  static Future<ServiceProviderConfigModel> loadConfig(
      String defaultWssUri) async {
    developer.log(
      '=> Cargando configuración...',
      name: 'ConfigLoaderPlatformWeb',
    );
    final def = ServiceProviderConfigModel.parseWssUri(defaultWssUri);
    developer.log(
      '=> Parámetros de cofniguración $def',
      name: 'ConfigLoaderPlatformWeb',
    );
    await saveConfig(def);
    return def;

    // final raw = web.window.localStorage.getItem('geryon_conf');
    // if (raw == null) {
    //   final def = ServiceProviderConfigModel.parseWssUri(defaultWssUri);
    //   await saveConfig(def);
    //   return def;
    // }
    // final json = jsonDecode(raw);
    // return ServiceProviderConfigModel.fromJson(json);
  }

  static Future<ErrorHandler> saveConfig(
      ServiceProviderConfigModel config) async {
    try {
      web.window.localStorage
          .setItem('geryon_conf', jsonEncode(config.toJson()));
      return ErrorHandler(
          errorCode: 0, errorDsc: 'Config saved to localStorage');
    } catch (e, st) {
      throw ErrorHandler(
        errorCode: 10001,
        errorDsc: 'Failed to save config to localStorage: $e',
        stacktrace: st,
      );
    }
  }
}
