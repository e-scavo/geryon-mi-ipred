import 'package:flutter/foundation.dart';

import 'utils_common.dart';
import 'utils_web.dart' if (dart.library.io) 'utils_io.dart';

class Utils extends UtilsBase {
  static String generateRandomString(int length) {
    return UtilsBase.generateRandomString(length);
  }

  static String appIsRunninOnPlatform() {
    return UtilsPlatform.appIsRunninOnPlatform();
  }

  static String get isPlatform => UtilsPlatform.appIsRunninOnPlatform();
  static bool get isLocalhostWeb => UtilsPlatform.isLocalhostWeb;
  static bool get isProductionWeb => UtilsPlatform.isProductionWeb;

  static bool get isDebugMode {
    return kDebugMode;
  }
}
