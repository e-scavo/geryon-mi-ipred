import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/ServiceProvider/errors_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ServiceProviderWholeMessageModel {
  static final String className = 'ServiceProviderWholeMessageModel';
  static final String logClassName = '.::$className::.';
  final int errorCode;
  final String errorDsc;
  final ServiceProviderModel data;
  final List<ServiceProviderErrorModel> errors;

  const ServiceProviderWholeMessageModel._internal({
    required this.errorCode,
    required this.errorDsc,
    required this.data,
    required this.errors,
  });

  factory ServiceProviderWholeMessageModel.fromJson(Map<String, dynamic> map) {
    const String functionName = 'fromJson';
    const String logFunctionName = '.::$functionName::.';

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
          'The following properties {${propSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
      throw ErrorHandler(
        errorCode: 200001,
        errorDsc: eMessage,
        className: className,
        functionName: functionName,
        propertyName: errorPropSanity.toString(),
        propertyValue: null,
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
          className: className,
          functionName: functionName,
          propertyName: 'error_code',
          propertyValue: null,
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
          className: className,
          functionName: functionName,
          propertyName: 'data',
          propertyValue: map['data'].toString(),
          stacktrace: StackTrace.current,
        );
      }
      ServiceProviderModel data;
      try {
        developer.log(
          '[MAP]:$map',
          name: '$logClassName - $logFunctionName',
        );

        data = ServiceProviderModel.fromJSON(map['data']);
      } catch (e, stacktrace) {
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'Data => ${e.errorDsc}',
            className: className,
            functionName: functionName,
            propertyName: 'data => ${e.propertyName}',
            propertyValue: 'data => ${e.propertyValue}',
            stacktrace: e.stacktrace ??= stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 528000,
            errorDsc: e.toString(),
            className: className,
            functionName: functionName,
            propertyName: 'data => "Desconocido"',
            propertyValue: 'data=> "Desconocido"',
            stacktrace: stacktrace,
          );
        }
      }

      /// `errors` is optional, but if provided, must be a List<ServiceProviderErrorModel>

      List<ServiceProviderErrorModel> errors = [];
      if (map.containsKey('errors') && map['errors'] is List) {
        for (var error in map['errors']) {
          if (error is Map<String, dynamic>) {
            try {
              errors.add(ServiceProviderErrorModel.fromJson(error));
            } catch (e, stacktrace) {
              if (e is ErrorHandler) {
                throw ErrorHandler(
                  errorCode: e.errorCode,
                  errorDsc: 'Errors => ${e.errorDsc}',
                  className: className,
                  functionName: functionName,
                  propertyName: 'errors => ${e.propertyName}',
                  propertyValue: 'errors => ${e.propertyValue}',
                  stacktrace: e.stacktrace ??= stacktrace,
                );
              } else {
                throw ErrorHandler(
                  errorCode: 528001,
                  errorDsc: e.toString(),
                  className: className,
                  functionName: functionName,
                  propertyName: 'errors => "Desconocido"',
                  propertyValue: 'errors => "Desconocido"',
                  stacktrace: stacktrace,
                );
              }
            }
          }
        }
      }

      return ServiceProviderWholeMessageModel._internal(
        errorCode: errorCode,
        errorDsc: errorDsc,
        data: data,
        errors: errors,
      );
    } catch (e) {
      developer.log('$logClassName - $logFunctionName [CATCHED] - $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'errorCode': errorCode,
      'errorDsc': errorDsc,
      'data': data,
      'errors': errors,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'Error_Code': errorCode,
      'Error_Dsc': errorDsc,
      'Data': data,
      'Errors': errors,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! ServiceProviderWholeMessageModel) return false;

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
