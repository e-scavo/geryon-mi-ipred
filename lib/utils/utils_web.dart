// lib/utils/utils_web.dart

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class UtilsPlatform {
  static String appIsRunninOnPlatform() {
    return "Web";
  }

  static bool get isLocalhostWeb {
    return !kReleaseMode && (web.window.location.hostname == 'localhost');
  }

  static bool get isProductionWeb {
    return kReleaseMode || !(web.window.location.hostname == 'localhost');
  }
}
