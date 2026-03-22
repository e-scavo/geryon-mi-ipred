// lib/utils/utils_io.dart

import 'dart:io';

class UtilsPlatform {
  static String appIsRunninOnPlatform() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isMacOS) {
      return "macOS";
    } else if (Platform.isWindows) {
      return "Windows";
    } else if (Platform.isLinux) {
      return "Linux";
    } else if (Platform.isFuchsia) {
      return "Fuchsia";
    } else {
      return 'Unknown';
    }
  }

  static bool get isLocalhostWeb => false;
  static bool get isProductionWeb => true;
}
