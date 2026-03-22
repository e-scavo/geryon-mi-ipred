import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonBooleanModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonClaseCpbteVT/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';

typedef CommonFieldNamesValuesFunction = String Function(dynamic vField);
typedef CommonCopyToClipboard<T> = Future<void> Function(
    BuildContext context, T vField);

class CommonFieldNamesValues<T> {
  static const className = "CommonFieldNamesValues";
  late final String _key;
  late final String _value;
  late final CommonFieldNamesValuesFunction _returnedValue;
  late TextAlign? _textAlign;
  late TextAlign? _contentTextAlign;
  late Alignment? _contentAlignment;
  late double _width;
  late CommonCopyToClipboard<T>? _copyToClipboard;

  CommonFieldNamesValues({
    required String key,
    required String value,
    required CommonFieldNamesValuesFunction? func,
    TextAlign? textAlign,
    TextAlign? contentTextAlign,
    Alignment? contentAlignment,
    double? width,
    CommonCopyToClipboard<T>? copyToClipboard,
  }) {
    _key = key;
    _value = value;
    _returnedValue = func ?? _defaultFunction;
    _textAlign = textAlign;
    _contentTextAlign = contentTextAlign;
    developer.log(
        '$className - Constructor() - Setting contentAlignment to $contentAlignment');
    _contentAlignment = contentAlignment;
    _width = width ?? 0.0;
    _copyToClipboard = copyToClipboard;
  }

  String get key => _key;
  String get value => _value;
  TextAlign? get textAlign => _textAlign;
  TextAlign? get contentTextAlign => _contentTextAlign;
  Alignment get contentAlignment =>
      _contentAlignment == null ? Alignment.center : _contentAlignment!;
  double get width => _width;
  CommonCopyToClipboard<T>? get copyToClipboard => _copyToClipboard;

  String getFormattedFieldData(dynamic fieldValue) {
    return _returnedValue(fieldValue);
  }

  Map<String, dynamic> toMap() {
    return {
      "key": _key,
      "value": _value,
      "function": _returnedValue,
      "textAlign": _textAlign,
      "contentTextAlign": _contentTextAlign,
      "contentAlignment": _contentAlignment,
      "width": _width,
    };
  }

  /// Default function to return value field formmated according to its type
  ///
  String _defaultFunction(dynamic fieldValue) {
    const functionName = "_defaultFunction";
    developer.log(
        '{"ClassName": "$className", "FunctionName": "$functionName", "Type":"${fieldValue.runtimeType}}" "Value":$fieldValue}');

    switch (fieldValue.runtimeType) {
      case const (int):
        return fieldValue.toString().padLeft(5, '0');
      case const (CommonDateModel):
        return (fieldValue as CommonDateModel).toES();
      case const (CommonDateTimeModel):
        developer.log(
            '$className - $functionName - fieldValue: ${fieldValue.runtimeType}');
        return (fieldValue as CommonDateTimeModel).toES();
      case const (CommonNumbersModel):
        //return fieldValue.asStringWithPrec(2);
        switch ((fieldValue as CommonNumbersModel).type) {
          case "percentage":
            return '${fieldValue.asStringWithPrec(2).trim()}%';
          case "percentageSpanish":
            return '${fieldValue.asStringWithPrecSpanish(2, monetarySign: '').trim()}%';
          case "number":
            return fieldValue
                .asStringWithPrecSpanish(2, monetarySign: '')
                .trim();
          default:
            return fieldValue.asStringWithPrecSpanish(2);
        }

      case const (double):
        return fieldValue.toStringAsFixed(2);
      case const (String):
        return fieldValue.toString();
      case const (CommonClasesCpbteVT):
        return CommonClasesCpbteVT.getId(fieldValue);
      case const (CommonBooleanModel):
        return (fieldValue as CommonBooleanModel).asStringSINO();
      default:
        developer.log(
            '{"ClassName": "$className", "FunctionName": "$functionName", "Type":"${fieldValue.runtimeType}}"');
        return fieldValue.toString();
    }
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonFieldNamesValues) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return toMap().values.fold(0,
        (previousValue, element) => previousValue.hashCode + element.hashCode);
  }
}
