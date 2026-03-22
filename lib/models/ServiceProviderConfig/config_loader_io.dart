// File: lib/models/ServiceProviderConfig/config_loader_io.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_pkg;
import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/ServiceProviderConfig/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ConfigLoaderPlatform {
  static Future<ServiceProviderConfigModel> loadConfig(
      String defaultWssUri) async {
    developer.log(
      '=> Cargando configuración...',
      name: 'ConfigLoaderPlatformIO',
    );
    final def = ServiceProviderConfigModel.parseWssUri(defaultWssUri);
    developer.log(
      '=> Parámetros de cofniguración $def',
      name: 'ConfigLoaderPlatformWeb',
    );
    await saveConfig(def);
    return def;
    // final dir = await getApplicationDocumentsDirectory();
    // developer.log(
    //   '=> Directorio de documentos de la aplicación: ${dir.path}',
    //   name: 'ConfigLoaderPlatformIO',
    // );
    // final file =
    //     File(path_pkg.join(dir.path, 'config/service_provider_config.json'));
    // developer.log(
    //   '=> File: ${file.path}',
    //   name: 'ConfigLoaderPlatformIO',
    // );
    // if (!await file.exists()) {
    //   developer.log(
    //     '=> File ${file.path} DOES NOT EXIST',
    //     name: 'ConfigLoaderPlatformIO',
    //   );
    //   final def = ServiceProviderConfigModel.parseWssUri(defaultWssUri);
    //   await saveConfig(def);
    //   return def;
    // }
    // developer.log(
    //   '=> File ${file.path} EXISTS',
    //   name: 'ConfigLoaderPlatformIO',
    // );

    // final json = jsonDecode(await file.readAsString());
    // developer.log(
    //   '=> File JSON Decode $json',
    //   name: 'ConfigLoaderPlatformIO',
    // );
    // var fJson = ServiceProviderConfigModel.fromJson(json);
    // developer.log(
    //   '=> File FROM JSON Object $fJson',
    //   name: 'ConfigLoaderPlatformIO',
    // );

    // return fJson;
  }

  static Future<ErrorHandler> saveConfig(
      ServiceProviderConfigModel config) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final subdir = Directory(path_pkg.join(dir.path, 'config'));
      if (!await subdir.exists()) await subdir.create(recursive: true);
      final file =
          File(path_pkg.join(subdir.path, 'service_provider_config.json'));
      await file.writeAsString(jsonEncode(config.toJson()));

      return ErrorHandler(errorCode: 0, errorDsc: 'Config saved to file');
    } catch (e, st) {
      throw ErrorHandler(
        errorCode: 10002,
        errorDsc: 'Failed to save config to file: $e',
        stacktrace: st,
      );
    }
  }
}
