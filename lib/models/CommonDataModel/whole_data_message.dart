import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonDataModelWholeDataMessage<T extends CommonModel<T>> {
  final String actionRequest;
  final String channelName;
  final CommonDataModelWholeDataDataMessage<T> data;
  final String event;
  final String messageID;
  final int apiVersion;
  final String module;
  final bool isNew;
  final String severity;
  final String status;

  const CommonDataModelWholeDataMessage._internal({
    required this.actionRequest,
    required this.channelName,
    required this.data,
    required this.event,
    required this.messageID,
    required this.apiVersion,
    required this.module,
    required this.isNew,
    required this.severity,
    required this.status,
  });

  factory CommonDataModelWholeDataMessage.fromJson({
    required Map<String, dynamic> map,
    required T Function({
      required Map<String, dynamic> map,
      int errorCode,
    }) fromJsonFunction,
    required int errorCode,
  }) {
    const String className = "CommonDataModelWholeDataMessage";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'ActionRequest',
      'New',
      'ChannelName',
      'Data',
      'Event',
      'MessageID',
      'APIVersion',
      'Severity',
      'Status',
      'Module',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage =
          'The following properties22 {${errorPropSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
      throw ErrorHandler(
        errorCode: 200001,
        errorDsc: eMessage,
        className: className,
      );
    }
    try {
      if (map['ActionRequest'] is! String ||
          (map['ActionRequest'] is String &&
              (map['ActionRequest'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ActionRequest',
          className: className,
        );
      }
      String actionRequest = map['ActionRequest'];

      if (bool.tryParse(map['New'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'New',
          className: className,
        );
      }
      bool isNew = map['New'];
      if (isNew) {
        // No debería de estar nunca aquí.
        // Si estoy aquí en esta parte del código es porque hay un error (una excepción) no tenida en cuenta
      }
      if (map['ChannelName'] is! String ||
          (map['ChannelName'] is String &&
              !isNew &&
              (map['ChannelName'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ChannelName',
          className: className,
        );
      }
      String channelName = map['ChannelName'];

      if (map['Event'] is! String ||
          (map['Event'] is String && (map['Event'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Event',
          className: className,
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
          propertyName: 'MessageID',
          className: className,
        );
      }
      String messageID = map['MessageID'];

      int apiVersion;
      if (int.tryParse(map['APIVersion'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'APIVersion',
          className: className,
        );
      }
      apiVersion = int.parse(map['APIVersion'].toString());

      if (map['Severity'] is! String ||
          (map['Severity'] is String && (map['Severity'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Severity',
          className: className,
        );
      }
      String severity = map['Severity'];

      if (map['Status'] is! String ||
          (map['Status'] is String && (map['Status'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Status',
          className: className,
        );
      }
      String status = map['Status'];

      if (map['Module'] is! String ||
          (map['Module'] is String && (map['Module'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Module',
          className: className,
        );
      }
      String module = map['Module'];

      /// `Data` can't be null and must be Map<String, dynamic>.
      ///
      if (map['Data'] == null || map['Data'] is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc:
              'Can\'t be null AND must be a valid Map<String, dynamic>. It is ${map['Data'].runtimeType}.$supportMessage',
          propertyName: 'Data',
          className: className,
        );
      }
      Map<String, dynamic> data1 = map['Data'];
      CommonDataModelWholeDataDataMessage<T> data;
      try {
        if (status == 'queued') {
          data = CommonDataModelWholeDataDataMessage<T>.fromDefault();
        } else {
          if (errorCode == 0) {
            data = CommonDataModelWholeDataDataMessage<T>.fromJson(
              map: data1,
              fromJsonFunction: fromJsonFunction,
              errorCode: errorCode,
            );
          } else {
            data = CommonDataModelWholeDataDataMessage<T>.fromDefault();
          }
        }
      } catch (e, stacktrace) {
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'Data333 => ${e.errorDsc}',
            propertyName: 'data => ${e.propertyName}',
            className: className,
            stacktrace: stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 500000,
            errorDsc: 'Data => Unknown => ${e.toString()}',
            propertyName: 'data => unknown',
            className: className,
            stacktrace: stacktrace,
          );
        }
      }

      return CommonDataModelWholeDataMessage._internal(
        actionRequest: actionRequest,
        channelName: channelName,
        data: data,
        event: event,
        messageID: messageID,
        apiVersion: apiVersion,
        module: module,
        isNew: isNew,
        severity: severity,
        status: status,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        throw ErrorHandler(
          errorCode: e.errorCode,
          errorDsc: e.errorDsc,
          propertyName: e.propertyName,
          className: e.className,
          stacktrace: e.stacktrace ?? stacktrace,
        );
      } else {
        throw ErrorHandler(
          errorCode: 500006,
          errorDsc: '${e.toString()}.\r\n$supportMessage',
          propertyName: 'unknown',
          className: className,
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// Convert from [this] to `Map<String,synamic` JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'ActionRequest': actionRequest,
      'ChannelName': channelName,
      'Data': data,
      'Event': event,
      'MessageID': messageID,
      'APIVersion': apiVersion,
      'Module': module,
      'IsNew': isNew,
      'Severity': severity,
      'Status': status,
    };
  }

  /// Map this object to json
  ///
  Map<String, dynamic> toMap() {
    return {
      'actionRequest': actionRequest,
      'channelName': channelName,
      'data': data,
      'event': event,
      'messageID': messageID,
      'apiVersion': apiVersion,
      'module': module,
      'isNew': isNew,
      'severity': severity,
      'status': status,
    };
  }

  String toJsonString() {
    return toJson().toString();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonDataModelWholeDataMessage) return false;

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
