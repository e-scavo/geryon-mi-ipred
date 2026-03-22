import 'dart:developer' as developer;

import 'package:decimal/decimal.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:intl/intl.dart';

// Response class to encapsulate the response structure
class Response {
  int errorCode;
  String errorDsc;
  int errorCodeRaw;
  String errorDscRaw;
  CommonNumbersModel data;

  Response({
    required this.errorCode,
    required this.errorDsc,
    required this.errorCodeRaw,
    required this.errorDscRaw,
    required this.data,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'Error_Code': errorCode,
      'Error_Dsc': errorDsc,
      'Error_Code_Raw': errorCodeRaw,
      'Error_Dsc_Raw': errorDscRaw,
      'Data': data,
    };
  }
}

// Marshaller class to encapsulate formatting details
class Marshaller {
  String format;

  Marshaller({this.format = ''});
}

const int defaultPrecision = 100;

// CommonNumbersModel class to encapsulate number manipulation
class CommonNumbersModel {
  static const String className = "CommonNumbersModel";
  String fieldName;
  Decimal number;
  int precision;
  bool isDefault;
  Marshaller xmlMarshaller;
  Marshaller jsonMarshaller;
  Marshaller mapStructureMarshaller;
  String type = "number";

  CommonNumbersModel({
    required this.number,
    this.precision = defaultPrecision,
    this.fieldName = "",
    this.isDefault = false,
    Marshaller? xmlMarshaller,
    Marshaller? jsonMarshaller,
    Marshaller? mapStructureMarshaller,
  })  : xmlMarshaller = xmlMarshaller ?? Marshaller(),
        jsonMarshaller = jsonMarshaller ?? Marshaller(),
        mapStructureMarshaller = mapStructureMarshaller ?? Marshaller();

// Adds n to this number and returns a new CommonNumbersModel instance
  CommonNumbersModel add(CommonNumbersModel n) {
    Decimal result = number + n.number;
    return parse(result).data;
  }

  // Converts the number to a string with the default precision
  String asString() {
    return number.toStringAsFixed(precision);
  }

  // Converts the number to a string with specified precision
  String asStringWithPrec(int prec) {
    return number.toStringAsFixed(prec);
  }

  // Converts the number to a string with specified precision
  // in Spanish
  String asStringWithPrecSpanish(
    int prec, {
    String monetarySign = '\$',
  }) {
    // Formato español (España)
    var formatSpanish = NumberFormat.currency(
      locale: 'es_ES',
      decimalDigits: prec,
      symbol: '',
    );
    //print(formatSpanish.format(number)); // Salida: 1.234.567,89 €
    var fNumber = formatSpanish.format(number.toDouble());
    return '$monetarySign $fNumber';
  }

// Checks if this number is ZERO
  bool isZero() {
    return number == Decimal.fromInt(0);
  }

  // Checks if this number is equal to another
  bool equals(CommonNumbersModel n) {
    return number == n.number;
  }

  // Checks if this number is greater than or equal to another
  bool greaterOrEqualThan(CommonNumbersModel n) {
    return number >= n.number;
  }

  // Checks if this number is greater than another
  bool greaterThan(CommonNumbersModel n) {
    return number > n.number;
  }

  // Checks if this number is less than or equal to another
  bool lessOrEqualThan(CommonNumbersModel n) {
    return number <= n.number;
  }

  // Checks if this number is less than another
  bool lessThan(CommonNumbersModel n) {
    return number < n.number;
  }

  // Multiplies this number by another and returns a new CommonNumbersModel instance
  CommonNumbersModel mul(CommonNumbersModel n) {
    Decimal result = number * n.number;
    return parse(result).data;
  }

  // Divides this number by another and returns a new CommonNumbersModel instance
  CommonNumbersModel quo(CommonNumbersModel n) {
    Decimal result = (number / n.number) as Decimal;
    return parse(result).data;
  }

  // Subtracts another number from this one and returns a new CommonNumbersModel instance
  CommonNumbersModel sub(CommonNumbersModel n) {
    Decimal result = number - n.number;
    return parse(result).data;
  }

  // Returns the precision of the number
  int getPrecision() {
    return precision;
  }

  @override
  String toString() {
    return asString();
  }

  String toJson() {
    return toString();
  }

  // Parses a decimal value into a CommonNumbersModel instance and Response
  static Response parse(
    Decimal n, {
    String fieldName = "",
  }) {
    String functionName = 'parse';
    try {
      CommonNumbersModel number = CommonNumbersModel(
        number: n,
        precision: defaultPrecision,
        fieldName: fieldName,
        isDefault: false,
      );
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: number,
      );
    } catch (e) {
      developer.log('$className - $functionName - [CATCHED] $e');
      throw ErrorHandler(
        errorCode: 9,
        errorDsc: e.toString(),
        className: className,
        functionName: functionName,
        propertyName: fieldName,
        propertyValue: n.toString(),
        stacktrace: StackTrace.current,
      );
    }
  }

  // Parses a CommonNumbersModel into a new instance directly.
  static CommonNumbersModel fromMe(
    CommonNumbersModel n, {
    String fieldName = '',
  }) {
    return parse(n.number,
            fieldName: fieldName.isEmpty ? n.fieldName : fieldName)
        .data;
  }

  // Creates a new CommonNumbersModel instance with default values
  static CommonNumbersModel newNumbers() {
    return parse(Decimal.fromInt(0)).data;
  }

  // Creates a new CommonNumbersModel instance with ZERO value
  static CommonNumbersModel zero() {
    return parse(
      Decimal.fromInt(0),
      fieldName: 'zero',
    ).data;
  }

  static Response tryParse(
    dynamic number, {
    String fieldName = '',
  }) {
    const String functionName = 'tryParse';
    developer.log(
        "$className - $functionName - [fieldName]:$fieldName [number]:$number [type]:${number.runtimeType}");
    switch (number.runtimeType) {
      case const (CommonNumbersModel):
        return parse(
          (number as CommonNumbersModel).number,
          fieldName: fieldName,
        );
      case const (int):
        return parse(
          Decimal.fromInt(number),
          fieldName: fieldName,
        );
      default:
        try {
          return parseFromMap(
            number,
            fieldName: fieldName,
          );
        } catch (e) {
          try {
            number ??= "0";
            return parseString(
              number,
              fieldName: fieldName,
            );
          } catch (e, stacktrace) {
            if (e is ErrorHandler) {
              e.stacktrace ??= stacktrace;
            }
            rethrow;
          }
        }
    }
  }

  static Response parseFromMap(
    Map<String, dynamic> map, {
    String fieldName = "",
  }) {
    const String functionName = 'parseFromMap';
    developer.log(
        "$className - $functionName - [fieldName]:$fieldName [map]:$map [type]:${map.runtimeType}");
    try {
      Decimal n = Decimal.parse(map["Number"]);
      return parse(n);
    } catch (e) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: e.toString(),
        data: CommonNumbersModel(
          number: Decimal.fromInt(0),
          fieldName: fieldName,
        ),
      );
    }
  }

  // Parses a string to create a CommonNumbersModel instance
  static Response parseString(
    String value, {
    String fieldName = "",
  }) {
    try {
      if (value.toLowerCase() == "null") {
        value = '0';
      }
      Decimal n = Decimal.parse(value);
      return parse(n);
    } catch (e) {
      return Response(
        errorCode: 10,
        errorDsc: 'The number $value is not valid',
        errorCodeRaw: 0,
        errorDscRaw: e.toString(),
        data: CommonNumbersModel(
          number: Decimal.fromInt(0),
          fieldName: fieldName,
        ),
      );
    }
  }

  void fromDouble(
    double value, {
    fieldName = "",
    int precision = 100,
  }) {
    number = Decimal.parse(value.toStringAsFixed(precision));
  }
}
