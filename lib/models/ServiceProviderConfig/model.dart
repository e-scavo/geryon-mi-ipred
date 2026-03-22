import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProviderConfig/config_loader.dart';

class ServiceProviderConfigModel {
  static final String className = 'ServiceProviderConfigModel';
  static final String logClassName = '.::$className::.';

  String tipo;
  String address;
  int port;
  String path;
  bool debug;

  ServiceProviderConfigModel({
    required this.tipo,
    required this.address,
    required this.port,
    required this.path,
    required this.debug,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'address': address,
        'port': port,
        'path': path,
        'debug': debug,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  String uri() {
    return '$tipo://$address:$port/$path';
  }

  factory ServiceProviderConfigModel.fromJson(Map<String, dynamic> json) =>
      ServiceProviderConfigModel(
        tipo: json['tipo'],
        address: json['address'],
        port: json['port'],
        path: json['path'],
        debug: json['debug'],
      );

  factory ServiceProviderConfigModel.zeroConf() {
    developer.log(
      '🔄 Creating zero configuration for ServiceProviderConfigModel',
      name: logClassName,
    );
    return ServiceProviderConfigModel(
      tipo: 'wss',
      address: '0.0.0.0',
      port: 0,
      path: 'ws',
      debug: false,
    );
  }

  static Future<ServiceProviderConfigModel> loadConfig(
      String defaultWssUri) async {
    developer.log(
      '🔄 Loading .::$weAreInMode::. ServiceProviderConfigModel from default URI: $defaultWssUri',
      name: logClassName,
    );
    var lConfig = await ConfigLoader.loadConfig(defaultWssUri);
    developer.log(
      '🔄 Loaded .::$weAreInMode::. ServiceProviderConfigModel from URI: $lConfig',
      name: logClassName,
    );
    return lConfig;
  }

  static ServiceProviderConfigModel parseWssUri(String wssUri) {
    developer.log(
      '🔄 Parsing WSS URI: $wssUri',
      name: logClassName,
    );
    final uri = Uri.parse(wssUri);
    return ServiceProviderConfigModel(
      tipo: uri.scheme, // 'wss'
      address: uri.host, // 'rpc.nfibra.com'
      port: uri.port, // 9779
      path: uri.path.isNotEmpty ? uri.path : 'ws22',
      debug: true, // true
    );
  }
}
