import 'dart:convert';
import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class JsonDateModel {
  static const String className = "JsonDateModel";
  final int unixTimestamp;
  final String dateTime;

  JsonDateModel._internal({
    required this.unixTimestamp,
    required this.dateTime,
  });

  static bool _isDateTimeDefaultString(String datetime) {
    List<String> defaultValues = [
      "",
      "0001-01-01",
      "0000-00-00",
      "0000-00-00 00:00:00",
      "0000/00/00",
      "0000/00/00 00:00:00",
      "00-00-0000",
      "00-00-0000 00:00:00",
      "00/00/0000",
      "00/00/0000 00:00:00",
      "1800-12-28",
      "1800-12-28 00:00:00",
    ];
    var rValue = defaultValues.firstWhere(
      (element) => element == datetime,
      orElse: () => "",
    );
    developer.log(
        '_isDateTimeDefaultStringJSON: $datetime - rValue=$rValue bool:${rValue != ""}');

    return rValue != "";
  }

  /// Factory for creating from JSON or string-based data
  factory JsonDateModel.fromJson(
    dynamic data, {
    String fieldName = "",
  }) {
    const String functionName = 'fromJson';
    const String defaultUnixTimestamp = '-5364662400';
    const String defaultDateTime = '1800-12-28 00:00:00';
    developer.log(
        '$className - $functionName - [fieldName]:$fieldName - [date]:$data');
    developer.log('${data.runtimeType}');

    try {
      Map<String, dynamic> map;

      // Si es una cadena, convertir a mapa
      if (data is String) {
        // Limpieza y normalización del JSON
        String cleanedJsonString = data.replaceAllMapped(
            RegExp(r'(\w+)\s*:'), (match) => '"${match[1]}":');
        cleanedJsonString = cleanedJsonString.replaceAllMapped(
            RegExp(r'(\d{4}-\d{2}-\d{2})'), (match) => '"${match[0]}"');
        cleanedJsonString =
            cleanedJsonString.replaceAll(RegExp(r':\s*}'), ': ""}');
        map = jsonDecode(cleanedJsonString);
      } else if (data is Map<String, dynamic>) {
        map = data;
      } else {
        throw ErrorHandler(
          errorCode: 40003,
          errorDsc: "Formato no soportado para JSON",
          propertyName: fieldName,
          propertyValue: data.toString(),
          functionName: functionName,
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      String rUnix = map["UnixTimestamp"].toString().trim();
      developer.log('$rUnix - ${rUnix.runtimeType} ${rUnix.length}');

      /// Es fecha por defecto?
      if (rUnix.isEmpty || _isDateTimeDefaultString(rUnix)) {
        return JsonDateModel._internal(
          unixTimestamp: int.parse(defaultUnixTimestamp),
          dateTime: defaultDateTime,
        );
      }

      // Validaciones de los campos
      if (int.tryParse(map["UnixTimestamp"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 40004,
          errorDsc: 'El campo "UnixTimestamp" es inválido o no está definido',
          propertyName: 'UnixTimestamp => FieldName:"$fieldName"',
          propertyValue: map["UnixTimestamp"].toString(),
          functionName: functionName,
          className: className,
          stacktrace: StackTrace.current,
        );
      }

      if (map["DateTime"] == null) {
        throw ErrorHandler(
          errorCode: 40005,
          errorDsc: 'El campo "DateTime" no está definido',
          propertyName: 'DateTime => FieldName:"$fieldName"',
          propertyValue: map["DateTime"].toString(),
          functionName: functionName,
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      return JsonDateModel._internal(
        unixTimestamp: int.parse(map["UnixTimestamp"].toString()),
        dateTime: map["DateTime"].toString(),
      );
    } catch (e, stacktrace) {
      throw ErrorHandler(
        errorCode: 9876,
        errorDsc: e.toString(),
        propertyName: fieldName,
        propertyValue: data.toString(),
        functionName: functionName,
        className: className,
        stacktrace: stacktrace,
      );
    }
  }

  @override
  String toString() {
    return jsonEncode({
      "UnixTimestamp": unixTimestamp,
      "DateTime": dateTime,
    });
  }
}
