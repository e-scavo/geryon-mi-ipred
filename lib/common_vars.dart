import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProviderConfig/model.dart';
import 'package:geryon_web_app_ws_v2/utils/utils.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool debug = false; // Set to false in production
String weAreInMode = Utils.isProductionWeb ? 'PRODUCTION' : 'DEVELOPMENT';
const Duration defaultRequestTimeOut = Duration(seconds: 600);

final notifierServiceProvider = ChangeNotifierProvider<ServiceProvider>((ref) {
  final configAsync = ref.watch(serviceProviderConfigProvider);

  return configAsync.when(
    data: (config) {
      developer.log(
        '=> ConfigAsync.When => Data => $config',
        name: '.::ServiceProviderNotifier::.',
      );
      return ServiceProvider(
        debug: config.debug,
        wssURI:
            '${config.tipo}://${config.address}:${config.port}${config.path}',
      );
    },
    loading: () {
      developer.log(
        '⚠️ ServiceProviderConfigModel not ready, delaying init...',
        name: '.::ServiceProviderNotifier::.',
      );
      return ServiceProvider(
        debug: false,
        wssURI:
            'wss://0.0.0.0:0/ws', // dummy config: ignorable porque isReady será false
      );
    },
    error: (err, _) {
      developer.log(
        '❌ Error al cargar configuración: $err',
        name: '.::ServiceProviderNotifier::.',
      );
      return ServiceProvider(
        debug: false,
        wssURI: 'wss://0.0.0.0:0/ws',
      );
    },
  );
});

// final notifierServiceProvider2 = ChangeNotifierProvider<ServiceProvider>((ref) {
//   String className = 'ServiceProviderNotifier';
//   String logClassName = '.::$className::.';
//   developer.log(
//     '✅ Inicializando ServiceProvider desde ChangeNotifierProvider',
//     name: logClassName,
//   );

//   final config = ref.watch(serviceProviderConfigProvider).maybeWhen(
//     data: (config) {
//       developer.log(
//         '✅ ServiceProviderConfigModel loaded: ${config.toString()}',
//         name: logClassName,
//       );
//       return config;
//     },
//     orElse: () {
//       developer.log(
//         '⚠️ ServiceProviderConfigModel not loaded, using zero configuration',
//         name: logClassName,
//       );
//       return ServiceProviderConfigModel.zeroConf();
//     },
//   );
//   developer.log(
//     '✅ ServiceProviderConfigModel: ${config.toString()}',
//     name: logClassName,
//   );
//   return ServiceProvider(
//     debug: config.debug,
//     wssURI: '${config.tipo}://${config.address}:${config.port}${config.path}',
//   );
// });

final serviceProviderConfigProvider =
    FutureProvider<ServiceProviderConfigModel>((ref) async {
  String className = 'ServiceProviderConfigProvider';
  String logClassName = '.::$className::.';
  // Load the configuration from the model
  // This will be executed when the provider is first accessed
  // and will return a Future that resolves to the configuration
  // You can also use ref.read() to access other providers if needed
  // For example, if you have a provider for the WSS URI:
  // final wssUri = ref.read(wssUriProvider);

  developer.log(
    '✅ Loading .::$weAreInMode::. configuration from FutureProvider',
    name: logClassName,
  );
  String wssUri = 'wss://rpc.nfibra.com:19779/ws';
  if (Utils.isProductionWeb) {
    wssUri = 'wss://rpc.nfibra.com:9779/ws';
  }
  if (Utils.isDebugMode) {
    developer.log(
      '🔄 Debug mode is enabled',
      name: logClassName,
    );
    wssUri = 'wss://rpc.nfibra.com:19779/ws';
  }
  var rConfig = await ServiceProviderConfigModel.loadConfig(wssUri);
  developer.log(
    '✅ Loaded .::$weAreInMode::. configuration from FutureProvider as $rConfig',
    name: logClassName,
  );
  return rConfig;
});

// final ColorScheme ipredScheme = const ColorScheme(
//   brightness: Brightness.light,
//   primary: Color(0xFF0C4DA1),
//   onPrimary: Colors.white,
//   secondary: Color(0xFFE53935),
//   onSecondary: Colors.white,
//   error: Color(0xFFE53935),
//   onError: Colors.white,
//   surface: Color(0xFFF7F8FA),
//   onSurface: Color(0xFF1A1A1A),
// );

final ColorScheme ipredScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFE53935),
  onPrimary: Colors.white,
  secondary: Color(0xFF0C4DA1),
  onSecondary: Colors.white,
  error: Color(0xFFE53935),
  onError: Colors.white,
  surface: Color(0xFFF7F8FA),
  onSurface: Color(0xFF1A1A1A),
);

final ThemeData ipredTheme = ThemeData(
  colorScheme: ipredScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: ipredScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: ipredScheme.primary,
    foregroundColor: ipredScheme.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ipredScheme.primary,
      foregroundColor: ipredScheme.onPrimary,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ipredScheme.secondary,
      side: BorderSide(color: ipredScheme.secondary),
    ),
  ),
);
