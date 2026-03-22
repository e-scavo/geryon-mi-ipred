import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonMessages/common_whole_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonDataModelWholeMessage<T extends CommonModel<T>> {
  static final String className = "CommonDataModelWholeMessage";
  static final String logClassName = '.::$className::.';
  final int errorCode;
  final String errorDsc;
  final List<CommonWholeMessageModel> errors;
  final CommonDataModelWholeDataMessage data;

  Map<String, dynamic> toJson() {
    return {
      'Error_Code': errorCode,
      'Error_Dsc': errorDsc,
      'Errors': errors,
      'Data': data,
      'ClassName': className,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  const CommonDataModelWholeMessage._internal({
    required this.errorCode,
    required this.errorDsc,
    required this.errors,
    required this.data,
  });

  factory CommonDataModelWholeMessage.fromJson({
    required Map<String, dynamic> map,
    required T Function({
      required Map<String, dynamic> map,
      int errorCode,
    }) fromJsonFunction,
  }) {
    const String functionName = "CommonDataModelWholeMessage";

    /// We must validate the minimum needed properties to create a new instance of this.
    /// Otherwise, I MUST throw an exception PropertyException
    ///
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'error_code',
      'error_dsc',
      'data',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage =
          '$className\r\nThe following properties {${propSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
      throw ErrorHandler(
        errorCode: 200001,
        errorDsc: eMessage,
        propertyName: errorPropSanity.toString(),
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    try {
      /// `error_code` can't be null and must be a number
      ///
      if (map['error_code'] == null ||
          int.tryParse(map['error_code'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          propertyName: 'error_code',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      int errorCode = map['error_code'];

      /// `error_dsc`
      ///
      String errorDsc = "";
      if (map['error_dsc'] == null || map['error_dsc'].runtimeType != String) {
        if (errorCode != 0) {
          errorDsc = "No se informó descripción del error encontrado";
        }
      } else {
        errorDsc = map['error_dsc'];
      }

      /// `data` can't be null and must be Map<String, dynamic>.
      ///
      if (map['data'] == null || map['data'] is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc:
              'Can\'t be null AND must be a valid Map<String, dynamic>. It is ${map['data'].runtimeType}.$supportMessage',
          propertyName: 'data',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      Map<String, dynamic> data1 = map['data'];

      CommonDataModelWholeDataMessage data;
      try {
        data = CommonDataModelWholeDataMessage<T>.fromJson(
          map: data1,
          fromJsonFunction: fromJsonFunction,
          errorCode: errorCode,
        );
      } catch (e, stacktrace) {
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'Data => ${e.errorDsc}',
            propertyName: 'data => ${e.propertyName}',
            propertyValue: e.propertyValue,
            className: className,
            functionName: functionName,
            stacktrace: e.stacktrace ??= stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 500001,
            errorDsc: 'Data => ${e.toString()}',
            propertyName: 'data => unknown',
            propertyValue: null,
            className: className,
            functionName: functionName,
            stacktrace: stacktrace,
          );
        }
      }

      List<CommonWholeMessageModel> errors = [];
      try {
        if (map['errors'] == null || map['errors'] is! List<dynamic>) {
          errors = [];
        } else {
          errors = (map['errors'] as List<dynamic>)
              .map((e) => CommonWholeMessageModel.fromJson(e))
              .toList();
        }
      } catch (e, stacktrace) {
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'Errors => ${e.errorDsc}',
            propertyName: 'errors => ${e.propertyName}',
            propertyValue: e.propertyValue,
            className: className,
            functionName: functionName,
            stacktrace: e.stacktrace ??= stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 500002,
            errorDsc: 'Data => ${e.toString()}',
            propertyName: 'data => unknown',
            propertyValue: null,
            className: className,
            functionName: functionName,
            stacktrace: stacktrace,
          );
        }
      }

      return CommonDataModelWholeMessage<T>._internal(
        errorCode: errorCode,
        errorDsc: errorDsc,
        errors: errors,
        data: data,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 500001,
          errorDsc: 'Unknown => ${e.toString()}',
          propertyName: 'unknown',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
        );
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonDataModelWholeMessage) return false;

    Map<String, dynamic> thisMap = toJson();
    Map<String, dynamic> otherMap = other.toJson();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return toJson().values.fold(0,
        (previousValue, element) => previousValue.hashCode + element.hashCode);
  }
}
