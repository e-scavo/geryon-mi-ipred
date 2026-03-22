// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:web/web.dart' as web;

// class Utils {
//   /// Generates a random string of the specified length.
//   /// The string will be base64 URL encoded.
//   static String generateRandomString(int length) {
//     var random = Random.secure();
//     var values = List<int>.generate(length, (i) => random.nextInt(255));
//     return base64UrlEncode(values);
//   }

//   /// Returns a string indicating the platform the app is running on.
//   /// Possible return values are: "Android", "iOS", "macOS", "Windows", "Linux", "Fuchsia", or "Web".
//   static String appIsRunninOnPlatform() {
//     if (kIsWeb) {
//       return "Web";
//     } else {
//       if (Platform.isAndroid) {
//         return "Android";
//       } else if (Platform.isIOS) {
//         return "iOS";
//       } else if (Platform.isMacOS) {
//         return "macOS";
//       } else if (Platform.isWindows) {
//         return "Windows";
//       } else if (Platform.isLinux) {
//         return "Linux";
//       } else if (Platform.isFuchsia) {
//         return "Fuchsia";
//       } else {
//         return 'Unknown';
//       }
//     }
//   }

//   /// Detecta si está en modo desarrollo (localhost) y no en producción
//   static bool get isLocalhostWeb {
//     return !kReleaseMode && (web.window.location.hostname == 'localhost');
//   }

//   /// Detecta si está corriendo en producción
//   static bool get isProductionWeb {
//     // En modo release, o si no es localhost
//     // En modo debug, si es localhost, no es producción
//     return kReleaseMode || !(web.window.location.hostname == 'localhost');
//   }
// }
