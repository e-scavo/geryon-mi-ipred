import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonDataModelWholeDataDataLocalParamsMessage<T extends CommonModel> {
  static final String className =
      "CommonDataModelWholeDataDataLocalParamsMessage";
  static final String logClassName = '.::$className::.';
  final String actionRequest;
  final String subActionRequest;
  final String table;

  Map<String, dynamic> toJson() {
    return {
      'ActionRequest': actionRequest,
      'SubActionRequest': subActionRequest,
      'Table': table,
      'ClassName': className,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  const CommonDataModelWholeDataDataLocalParamsMessage._internal({
    required this.actionRequest,
    required this.subActionRequest,
    required this.table,
  });

  /// Convert from `Map` to [this].
  factory CommonDataModelWholeDataDataLocalParamsMessage.fromJson(
    Map<String, dynamic> map,
    int errorcode,
  ) {
    const String functionName = "fromJson";
    const String logFunctionName = '.::$functionName::.';
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    try {
      String actionRequest = map['ActionRequest'] ?? "";
      String subActionRequest = map['SubActionRequest'] ?? "";
      String table = map['Table'] ?? "";

      return CommonDataModelWholeDataDataLocalParamsMessage._internal(
        actionRequest: actionRequest,
        subActionRequest: subActionRequest,
        table: table,
      );
    } catch (e, stacktrace) {
      developer
          .log('$logClassName - $logFunctionName - [CATCHED] $e - $stacktrace');
      if (e is ErrorHandler) {
        e.className = className;
        e.functionName = functionName;
        e.stacktrace = e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 500001,
          errorDsc: '${e.toString()}.\r\n$supportMessage',
          propertyName: 'unknown',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// From Default
  factory CommonDataModelWholeDataDataLocalParamsMessage.fromDefault() {
    return const CommonDataModelWholeDataDataLocalParamsMessage._internal(
      actionRequest: "_default_",
      subActionRequest: "_default_",
      table: "_default_",
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonDataModelWholeDataDataLocalParamsMessage) return false;

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
