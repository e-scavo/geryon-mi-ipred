import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';

class AppFormatters {
  static const String unavailableLabel = 'No disponible';

  static String visibleText(
    String value, {
    String fallback = unavailableLabel,
  }) {
    final String normalized = value.trim();
    return normalized.isEmpty ? fallback : normalized;
  }

  static String currency(
    CommonNumbersModel value, {
    int precision = 2,
    String symbol = r'$',
  }) {
    return value.asStringWithPrecSpanish(
      precision,
      monetarySign: symbol,
    );
  }

  static String date(
    CommonDateModel value, {
    String fallback = unavailableLabel,
  }) {
    if (value.isDefault) {
      return fallback;
    }
    return value.toES();
  }

  static String dueDateFromReference(
    DateTime reference, {
    int day = 10,
  }) {
    final String resolvedDay = day.toString().padLeft(2, '0');
    final String resolvedMonth = reference.month.toString().padLeft(2, '0');
    return '$resolvedDay/$resolvedMonth/${reference.year}';
  }
}
