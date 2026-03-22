import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/app_version_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ServiceProviderModel {
  static final String className = 'ServiceProviderModel';
  static final String _logClassName = '.::$className::.';
  final bool isNew;
  final AppVersionModel appVersion;
  final String channelName;
  final String event;
  final String messageID;
  final int apiVersion;
  final String severity;
  final String status;
  final String module;
  final String? clientIP;
  final String? tokenID;
  final dynamic data;

  /// Default constructor
  ///
  const ServiceProviderModel._internal({
    required this.isNew,
    required this.appVersion,
    required this.channelName,
    required this.event,
    required this.messageID,
    required this.apiVersion,
    required this.severity,
    required this.status,
    required this.module,
    required this.data,
    required this.clientIP,
    required this.tokenID,
  });

  /// Convert from `Map` to [this].
  factory ServiceProviderModel.fromJSON(Map<String, dynamic> map) {
    const String functionName = 'fromJson';
    const String logFunctionName = '.::$functionName::.';
    developer.log('$_logClassName - $logFunctionName [map]:$map');
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'New',
      'ChannelName',
      'Event',
      'MessageID',
      'APIVersion',
      'Severity',
      'Status',
      'Module',
      'Data',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage =
          'The following properties {${errorPropSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
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
      /// Nullable variables
      ///
      String? clientIP;
      String? tokenID;

      ///
      if (bool.tryParse(map['New'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'New',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      bool isNew = map['New'];
      if (isNew) {
        /// Validate some properties that are required if we are New
        /// It means we are initiating a new connection to the backend (o re-establish a broken one)
        ///
        propSanity = [
          'ClientIP',
          'TokenID',
        ];
        errorPropSanity = [];
        for (String prop in propSanity) {
          if (!map.containsKey(prop)) {
            errorPropSanity.add(prop);
          }
        }
        if (errorPropSanity.isNotEmpty) {
          var eMessage =
              'IsNEW => The following properties {${errorPropSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
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
        if (map['ClientIP'] is! String ||
            (map['ClientIP'] is String &&
                !isNew &&
                (map['ClientIP'] as String).isEmpty)) {
          throw ErrorHandler(
            errorCode: 200101,
            errorDsc: 'Can\'t be empty.$supportMessage',
            className: className,
            functionName: functionName,
            propertyName: 'ClientIP',
            propertyValue: null,
            stacktrace: StackTrace.current,
          );
        }
        clientIP = map['ClientIP'];
        if (map['TokenID'] is! String ||
            (map['TokenID'] is String &&
                !isNew &&
                (map['TokenID'] as String).isEmpty)) {
          throw ErrorHandler(
            errorCode: 200101,
            errorDsc: 'Can\'t be empty.$supportMessage',
            className: className,
            functionName: functionName,
            propertyName: 'TokenID',
            propertyValue: null,
            stacktrace: StackTrace.current,
          );
        }
        tokenID = map['TokenID'];
      }
      if (map['ChannelName'] is! String ||
          (map['ChannelName'] is String &&
              !isNew &&
              (map['ChannelName'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'ChannelName',
          propertyValue: map['ChannelName'].toString(),
          stacktrace: StackTrace.current,
        );
      }
      String channelName = map['ChannelName'];
      if (map['Event'] is! String ||
          (map['Event'] is String && (map['Event'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'Event',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String event = map['Event'];
      if (map['MessageID'] is! String ||
          (map['MessageID'] is String &&
              !isNew &&
              (map['MessageID'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'MessageID',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String messageID = map['MessageID'];
      int apiVersion;
      if (int.tryParse(map['APIVersion'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Cant\'t be a non-numeric. $supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'APIVersion',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      apiVersion = int.parse(map['APIVersion'].toString());
      if (map['Severity'] is! String ||
          (map['Severity'] is String && (map['Severity'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'Severity',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String severity = map['Severity'];
      if (map['Status'] is! String ||
          (map['Status'] is String && (map['Status'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'Status',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String status = map['Status'];
      if (map['Module'] is! String ||
          (map['Module'] is String && (map['Module'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'Module',
          propertyValue: map['Status'].toString(),
          stacktrace: StackTrace.current,
        );
      }
      String module = map['Module'];

      /// `Data` can't be null and must be a Map (when it is an empty object) or Map<String, dynamic>.
      ///
      if (map['Data'] is! Map<String, dynamic> &&
          map['Data'] is! Map &&
          map['Data'] is! List<dynamic>) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc:
              'Can\'t be ${map['Data'].runtimeType}.\r\nIt must be:\r\n- Map\r\n- Map<String,dynamic>\r\n- List<dynamic>$supportMessage',
          className: className,
          functionName: functionName,
          propertyName: 'Data',
          propertyValue: map['Data'].toString(),
          stacktrace: StackTrace.current,
        );
      }
      var data = map['Data'];

      return ServiceProviderModel._internal(
        channelName: channelName,
        event: event,
        messageID: messageID,
        apiVersion: apiVersion,
        isNew: isNew,
        appVersion: gAppVersion,
        severity: severity,
        status: status,
        module: module,
        clientIP: clientIP,
        tokenID: tokenID,
        data: data,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 9999999,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          propertyName: 'Desconocido',
          propertyValue: 'Desconocido',
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// Convert from [this] to `Map<String,synamic` JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'ChannelName': channelName,
      'Event': event,
      'MessageID': messageID,
      "APIVersion": apiVersion,
      'New': isNew,
      'AppVersion': appVersion,
      'Severity': severity,
      'Status': status,
      'Module': module,
      'ClientIP': clientIP,
      'TokenID': tokenID,
      'Data': data,
    };
  }

  /// Map this object to json
  ///
  Map<String, dynamic> toMap() {
    return {
      'channelName': channelName,
      'event': event,
      'messageID': messageID,
      'apiVersion': apiVersion,
      'isNew': isNew,
      'appVersion': appVersion,
      'severity': severity,
      'status': status,
      'module': module,
      'clientIP': clientIP,
      'tokenID': tokenID,
      'data': data,
    };
  }

  /// Convert from `Map` to [this].
  factory ServiceProviderModel.fromMap(Map<String, dynamic> map) {
    var channelName = map['channelName'];
    var event = map['event'];
    var messageID = map['messageID'];
    var apiVersion = map['apiVersion'];
    var isNew = map['new'];
    var severity = map['severity'];
    var status = map['status'];
    var module = map['module'];
    var data = map['data'];
    var clientIP = map['clientIP'];
    var tokenID = map['tokenID'];
    var appVersion = AppVersionModel.fromMap(map['AppVersion']);

    return ServiceProviderModel._internal(
      channelName: channelName,
      event: event,
      messageID: messageID,
      apiVersion: apiVersion,
      isNew: isNew,
      appVersion: appVersion,
      severity: severity,
      status: status,
      module: module,
      clientIP: clientIP,
      tokenID: tokenID,
      data: data,
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! ServiceProviderModel) return false;

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
