// lib/utils/utils_common.dart

import 'dart:convert';
import 'dart:math';

class UtilsBase {
  /// Generates a random string of the specified length.
  static String generateRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
