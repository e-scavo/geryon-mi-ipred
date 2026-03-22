import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/date_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonDateModel {
  static const String className = "CommonDateModel";
  DateTime date;
  bool readOnly = false;
  bool enabled = true;
  bool isVisible = true;
  bool excludeFocus = false;
  bool absorbPointer = false;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool readOnlyOnIcon = false;
  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;
  bool flag5 = false;
  String type;
  String fieldName = "";

  CommonDateModel._internal({
    required this.date,
    this.type = "date",
    this.fieldName = "",
  }) {
    controller.text = toES();
  }
  set formatType(String pType) {
    type = pType;
    controller.text = toES();
  }

  update(CommonDateModel pDate) {
    date = pDate.date;
    controller.text = toES();
  }

  String getTime() {
    var hora = date.hour.toString().padLeft(2, '0');
    var minuto = date.minute.toString().padLeft(2, '0');
    var segundo = date.second.toString().padLeft(2, '0');
    return '$hora:$minuto:$segundo';
  }

  /// Constructor: returns an object from Now() -no paramters required-
  ///
  factory CommonDateModel.fromNow({
    String type = 'date',
    String fieldName = "",
  }) {
    /// Get the current date and time
    DateTime now = DateTime.now();

    return CommonDateModel._internal(
      date: now,
      type: type,
      fieldName: fieldName,
    );
  }

  /// Constructor: returns an object from Default() -no paramters required-
  ///
  factory CommonDateModel.fromDefault({
    String fieldName = "",
  }) {
    /// Get the default system compatible date and time
    /// based on the Clarion's default first date
    var rNow = CommonDateModel._clarionToDateTime(
      0,
      fieldName: fieldName,
    );
    return rNow;
  }

  /// Constructor: returns an object directly from DateTime parameter
  ///
  factory CommonDateModel.fromDateTime(
    DateTime pDate, {
    String pType = "date",
    String pFieldName = "",
  }) {
    return CommonDateModel._internal(
      date: pDate,
      type: pType,
      fieldName: pFieldName,
    );
  }

  /// Constructor: returns on object directly from Clarion (as integer) parameter
  ///
  factory CommonDateModel._clarionToDateTime(
    int clarionDate, {
    String fieldName = "",
  }) {
    /// Definir el día base de Clarion: 28 de diciembre de 1800
    DateTime clarionEpoch = DateTime(1800, 12, 28);

    /// Sumar el número de días de la fecha de Clarion a la fecha base
    var cDate = clarionEpoch.add(Duration(days: clarionDate));

    return CommonDateModel._internal(
      date: cDate,
      fieldName: fieldName,
    );
  }

  /// Constructor: returns an object from Now() parameter
  ///
  factory CommonDateModel.parse(
    dynamic pDate, {
    String fieldName = "",
    StackTrace? pStackTrace,
  }) {
    const String functionName = "parse";
    developer.log(
        '$className - $functionName - [$fieldName]-${pDate.toString()}/${pDate.runtimeType}');
    if (pDate == null) {
      var rError = ErrorHandler(
        errorCode: 50000,
        errorDsc: '''1La fecha es inválida. 
              No se ha especificado
              ''',
        propertyName: fieldName != "" ? fieldName : "<No espcificado>",
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: pStackTrace ??= StackTrace.current,
      );
      developer.log('$className - $functionName - [rError]:$rError');
      throw rError;
    }
    try {
      /// Si es CommonDateModel ()
      if (pDate is CommonDateModel) {
        //rDate = pDate as CommonDateModel;
        return CommonDateModel._internal(
          date: pDate.date,
          fieldName: fieldName,
        );
      }

      /// Si es un entero (formato Clarion)
      if (pDate is int || int.tryParse(pDate.toString()) != null) {
        int clarionDate = int.parse(pDate.toString());
        return CommonDateModel._clarionToDateTime(
          clarionDate,
          fieldName: fieldName,
        );
      }

      /// Si es un mapa JSON
      if (pDate is Map<String, dynamic>) {
        var jDate = JsonDateModel.fromJson(pDate, fieldName: fieldName);

        DateTime? parsedDate = DateTime.tryParse(jDate.dateTime);
        if (parsedDate != null) {
          return CommonDateModel._internal(
            date: parsedDate,
            fieldName: fieldName,
          );
        }

        DateTime date = DateTime.fromMillisecondsSinceEpoch(
          jDate.unixTimestamp * 1000,
          isUtc: true,
        );
        return CommonDateModel._internal(
          date: date,
          fieldName: fieldName,
        );
      }

      /// Si es una cadena, validar formato y procesar
      if (pDate is String) {
        final dateStr = pDate.trim();

        /// Es fecha por defecto?
        if (_isDateTimeDefaultString(pDate)) {
          return CommonDateModel._clarionToDateTime(
            0,
            fieldName: fieldName,
          );
        }

        /// Detectar formato YYYY-MM-DD
        final isoRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (isoRegex.hasMatch(dateStr)) {
          final parsedDate = DateTime.tryParse(dateStr);
          if (parsedDate != null) {
            return CommonDateModel._internal(
              date: parsedDate,
              fieldName: fieldName,
            );
          }
        }

        /// Detectar y convertir formato DD-MM-YYYY a YYYY-MM-DD
        final europeanRegex = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
        final match = europeanRegex.firstMatch(dateStr);
        if (match != null) {
          final day = match.group(1);
          final month = match.group(2);
          final year = match.group(3);
          final convertedDate = '$year-$month-$day';
          final parsedDate = DateTime.tryParse(convertedDate);
          if (parsedDate != null) {
            return CommonDateModel._internal(
              date: parsedDate,
              fieldName: fieldName,
            );
          }
        }

        /// Detectar y convertir formato DD/MM/YYYY a YYYY-MM-DD
        final slashRegex = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$');
        final slashMatch = slashRegex.firstMatch(dateStr);
        if (slashMatch != null) {
          final day = slashMatch.group(1);
          final month = slashMatch.group(2);
          final year = slashMatch.group(3);
          final convertedDate = '$year-$month-$day';
          final parsedDate = DateTime.tryParse(convertedDate);
          if (parsedDate != null) {
            return CommonDateModel._internal(
              date: parsedDate,
              fieldName: fieldName,
            );
          }
        }
      }

      throw ErrorHandler(
        errorCode: 40001,
        errorDsc: "Formato de fecha no reconocido",
        propertyName: fieldName,
        propertyValue: pDate.toString(),
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    } catch (e, stacktrace) {
      developer.log('$className - $functionName - [CATCH] - $e');
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 9877,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          propertyName: fieldName,
          propertyValue: pDate.toString(),
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// Constructor: return an object from String parameter
  ///
  factory CommonDateModel.fromString(
    String pDate, {
    String fieldName = "",
  }) {
    const String functionName = 'fromString';
    const String className = "CommonDateModel";
    developer.log(
      'browseError: Migracion $className - $functionName - $fieldName - $pDate',
      name: className,
    );
    switch (pDate) {
      case "0000-00-00":
        pDate = "1800-12-28";
        break;
      default:
    }
    var mDate = DateTime.tryParse(pDate);
    developer.log(
      'Migracion $className - $functionName - $fieldName - $pDate - $mDate',
      name: className,
    );

    if (mDate == null) {
      /// Work-around
      /// If null, then return Clarion original (0)
      ///
      return CommonDateModel._clarionToDateTime(
        0,
        fieldName: fieldName,
      );
      // throw ErrorHandler(
      //   errorCode: 1,
      //   errorDsc: 'Error en el formato de la fecha [$pDate]',
      //   propertyName: 'date => FieldName:"$fieldName"',
      //   propertyValue: pDate.toString(),
      //   functionName: functionName,
      //   className: className,
      //   stacktrace: StackTrace.current,
      // );
    }
    return CommonDateModel._internal(
      date: mDate,
      fieldName: fieldName,
    );
  }

  /// toPeriodoES: returns date as String in Spanish/German format
  ///
  String _toPeriodoES() {
    if (isDefault) {
      return 'PERÍODO INVÁLIDO';
    }
    Map<int, String> sMeses = {
      0: "ERROR",
      1: "ENERO",
      2: "FEBRERO",
      3: "MARZO",
      4: "ABRIL",
      5: "MAYO",
      6: "JUNIO",
      7: "JULIO",
      8: "AGOSTO",
      9: "SEPTIEMBRE",
      10: "OCTUBRE",
      11: "NOVIEMBRE",
      12: "DICIEMBRE",
    };
    var aDate = date.toLocal().toString().split(' ')[0].split('-');
    if (type == 'periodo') {
      int mes = int.tryParse(aDate[1]) ?? 0;
      return '${sMeses[mes]} ${aDate[0]}';
    }
    return '${aDate[2]}/${aDate[1]}/${aDate[0]}';
  }

  /// toES: returns date as String in Spanish/German format
  ///
  String toES() {
    if (isDefault) {
      return '00/00/0000';
    }
    var aDate = date.toLocal().toString().split(' ')[0].split('-');
    if (type == 'periodo') {
      return _toPeriodoES();
    }
    return '${aDate[2]}/${aDate[1]}/${aDate[0]}';
  }

  /// toEN: returns date as String in English format
  ///
  String toEN() {
    if (isDefault) {
      return '0000-00-00';
    }
    var aDate = date.toLocal().toString().split(' ')[0].split('-');
    if (type == 'period') {
      return '${aDate[0]}-${aDate[1]}';
    }
    return '${aDate[0]}-${aDate[1]}-${aDate[2]}';
  }

  /// _toDateFormat: returns date as String in English format
  ///
  String _toDateFormat() {
    var aDate = date.toLocal().toString().split(' ')[0].split('-');
    return '${aDate[0]}-${aDate[1]}-${aDate[2]}';
  }

  /// firstDayOfTheMonth: returns the first day of the month of the stored date field
  ///
  DateTime firstDayOfTheMonth() {
    return DateTime(date.year, date.month, 1);
  }

  /// lastDayOfTheMonth: returns the first day of the month of the stored date field
  ///
  DateTime lastDayOfTheMonth() {
    DateTime firstDayOfNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return firstDayOfNextMonth.subtract(const Duration(days: 1));
  }

  Map<String, dynamic> toJsonObject() {
    return {
      'Date': date,
    };
  }

  String toJson() {
    return toEN();
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
    };
  }

  /// Controller to handle Date Picker for each widget date
  ///
  /// [firstDate] is the earliest allowable date.
  ///
  /// [lastDate] is the latest allowable date.
  ///
  /// [initDate] if [initialDate] is not null, it must either fall between these dates [firstDate] or [lastDate], or be equal to one of them.
  ///
  /// For each of these [DateTime] parameters, only their dates are considered.
  /// Their time fields are ignored.
  /// They must all be non-null.
  ///
  /// [currentDate] represents the current day (i.e. today). This date will be highlighted in the day grid. If null, the date of [DateTime.now] will be used.

  Future<String?> selectDate(
    BuildContext context, {
    lang = "es-AR",
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime today = initialDate ?? DateTime.now();
    developer.log(
        'pre: today $today init $initialDate first $firstDate last $lastDate',
        name: className);

    /// Validate firstDate
    ///
    if (firstDate == null) {
      firstDate = DateTime.now();
    } else if (_isDateTimeDefault(firstDate)) {
      firstDate = DateTime.now();
    }

    /// Validate lastDate
    ///
    if (lastDate == null) {
      lastDate = DateTime(2101);
    } else if (_isDateTimeDefault(lastDate)) {
      lastDate = firstDate;
    }

    /// Validate initialDate
    ///
    if (initialDate == null) {
      today = DateTime.now();
    } else if (_isDateTimeDefault(initialDate)) {
      today = DateTime.now();
    } else {
      if (initialDate.isBefore(firstDate)) {
        initialDate = firstDate;
      }
    }
    developer.log(
        'post: today $today init $initialDate first $firstDate last $lastDate',
        name: className);
    final DateTime? picked = await showDatePicker(
      context: context,
      //locale: Locale.
      //currentDate: ,
      initialDate: today,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      //_isDate = true;
      date = picked;

      var aDate = picked.toLocal().toString().split(' ')[0].split('-');
      controller.text = '${aDate[2]}/${aDate[1]}/${aDate[0]}';
      return '${aDate[0]}-${aDate[1]}-${aDate[2]}';
      //return CommonDateModel.fromString(picked.toLocal().toString());
    } else {
      //_isDate = true;
      return null;
    }
  }

  static bool _isDateTimeDefaultString(String datetime) {
    List<String> defaultValues = [
      "0001-01-01",
      "0001-01-01 00:00:00",
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
      '_isDateTimeDefaultString: $datetime - rValue=$rValue bool:${rValue != ""}',
      name: className,
    );

    return rValue != "";
  }

  bool _isDateTimeDefault(DateTime datetime) {
    List<String> defaultValues = [
      "0001-01-01",
      "0000-00-00",
      "1800-12-28",
    ];
    var aDate = datetime.toLocal().toString().split(' ')[0].split('-');
    var mDateTime = '${aDate[0]}-${aDate[1]}-${aDate[2]}';
    var rValue = defaultValues.firstWhere(
      (element) => element == mDateTime,
      orElse: () => "",
    );
    developer.log('_isDefault: $datetime - rValue=$rValue bool:${rValue != ""}',
        name: className);
    return rValue != "";
  }

  /// Returns true if date is default date
  ///
  bool get isDefault {
    String functionName = '$runtimeType';
    developer.log(
      "$functionName - $fieldName - Validando: $date",
      name: className,
    );
    List<String> defaultValues = [
      "0001-01-01",
      "0000-00-00",
      "1800-12-28",
    ];
    var rValue = defaultValues.firstWhere(
      (element) => element == _toDateFormat(),
      orElse: () => "",
    );
    bool isDefault = rValue != "";
    developer.log(
      "$functionName - $fieldName - Validando: $date => $isDefault",
      name: className,
    );
    return isDefault;
  }

  dispose() {
    try {
      developer.log('_disposeDateModel: try $type $date $controller',
          name: className);
      controller.dispose();
      focusNode.dispose();
    } catch (e, stacktrace) {
      developer.log('_disposeDateModel: catch $type $date $controller',
          name: className);
      throw ErrorHandler(
        errorCode: 910292,
        errorDsc: 'Error en dispose() $type - ${e.toString()}',
        stacktrace: stacktrace,
      );
    }
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonDateModel) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
      if (thisMap[key] != otherMap[key]) {
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
