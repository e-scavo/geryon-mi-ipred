// import 'package:web/web.dart' as web;

// //import 'dart:html' as html;
// import 'dart:developer' as developer;

// import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';

// class SessionStorage {
//   static const _key = 'user_dni';

//   static Future<void> saveDni(String dni) async {
//     developer.log(
//       '${LogIcons.save} SessionStorage: saveDni: $dni',
//       name: 'SessionStorage',
//     );
//     web.window.localStorage.setItem(_key, dni);
//   }

//   static Future<String?> getSavedDni() async {
//     developer.log(
//       '${LogIcons.download} SessionStorage: getSavedDni',
//       name: 'SessionStorage',
//     );
//     return web.window.localStorage.getItem(_key);
//   }

//   static Future<void> clear() async {
//     developer.log(
//       '${LogIcons.cross} SessionStorage: clear',
//       name: 'SessionStorage',
//     );
//     // Clear the session storage
//     web.window.localStorage.clear();
//   }

//   static Future<void> remove(String key) async {
//     developer.log(
//       '${LogIcons.cross} SessionStorage: removeDni',
//       name: 'SessionStorage',
//     );
//     // Remove the specific key
//     web.window.localStorage.removeItem(key);
//   }
// }
