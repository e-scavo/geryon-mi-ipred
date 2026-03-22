import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

typedef CommonRPCMessageResponseCallBack = Future<ErrorHandler> Function({
  required bool pFromCallback,
  required String pMessageID,
  required dynamic pParams,
});

abstract class CallbackCapable {
  CommonRPCMessageResponseCallBack? get callbackFunction;
  String get status;
  set status(String status);
}

class CommonRPCMessageResponse implements CallbackCapable {
  final String messageID;
  String statusProxy;
  int recordOldHash;
  dynamic recordNew;
  Map<String, dynamic> pParamsRequest;
  CommonRPCMessageResponseCallBack? callbackProxyFunction;
  List<String> statusHistory = [];
  DateTime timeCreated = DateTime.now();
  DateTime? timeSent;
  DateTime? timeQueued;
  DateTime? timeReplied;
  DateTime? timeProcessing;
  DateTime? timeOK;
  Duration timeElapsed = const Duration(seconds: 0);
  Duration timeOut = const Duration(seconds: 0);
  bool showWorkInProgress;
  bool isWorkInProgress;
  ErrorHandler finalResponse;
  int counter = 0;

  /// Control block
  ///
  bool replyWithError;
  ErrorHandler? localError;

  @override
  String get status => statusProxy;

  @override
  set status(String status) {
    statusProxy = status;
    statusHistory.add(status);
    switch (status) {
      case "init":
        timeCreated = DateTime.now();
        break;
      case "sent":
        timeSent = DateTime.now();
        break;
      case "queued":
        timeQueued = DateTime.now();
        break;
      case "processing":
        timeProcessing = DateTime.now();
        break;
      case "ok":
        timeOK = DateTime.now();
        break;
      default:
    }
  }

  @override
  CommonRPCMessageResponseCallBack? get callbackFunction =>
      callbackProxyFunction;

  CommonRPCMessageResponse._internal({
    required this.messageID,
    required this.statusProxy,
    required this.pParamsRequest,
    required this.recordOldHash,
    required this.recordNew,
    required this.replyWithError,
    required this.localError,
    required this.finalResponse,
    required this.callbackProxyFunction,
    required this.showWorkInProgress,
    required this.isWorkInProgress,
    required this.timeOut,
  }) {
    statusHistory.add(statusProxy);
  }

  factory CommonRPCMessageResponse.fromRPCCall({
    required String messageID,
    required String status,
    required Map<String, dynamic> pParamsRequest,
    bool pShowWorkInPgress = false,
    Duration? pTimeOut,
    CommonRPCMessageResponseCallBack? callbackFunction,
  }) {
    dynamic recordNew;
    int recordOldHash = recordNew.hashCode;
    bool replyWithError = false;
    ErrorHandler? localError;
    ErrorHandler finalResponse = ErrorHandler(errorCode: -1, errorDsc: "");
    Duration timeout = const Duration(seconds: 20);
    if (pTimeOut != null) {
      timeout = pTimeOut;
    }
    return CommonRPCMessageResponse._internal(
      messageID: messageID,
      statusProxy: status,
      pParamsRequest: pParamsRequest,
      recordOldHash: recordOldHash,
      recordNew: recordNew,
      replyWithError: replyWithError,
      localError: localError,
      finalResponse: finalResponse,
      showWorkInProgress: pShowWorkInPgress,
      isWorkInProgress: false,
      timeOut: timeout,
      callbackProxyFunction: callbackFunction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'statusProxy': status,
      'statusHistory': statusHistory,
      'pParamsRequest': pParamsRequest,
      'recordOldHash': recordOldHash,
      'recordNew': recordNew,
      'replyWithError': replyWithError,
      'localError': localError,
      'finalResponse': finalResponse,
      'timeCreated': timeCreated,
      'timeSent': timeSent,
      'timeQueued': timeQueued,
      'timeReplied': timeReplied,
      'timeProcessing': timeProcessing,
      'timeOK': timeOK,
      'timeElapsed': timeElapsed,
      'timeOut': timeOut,
      'showWorkInProgress': showWorkInProgress,
      'isWorkInProgress': isWorkInProgress,
      'callbackProxyFunction': callbackProxyFunction,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'MessageID': messageID,
      'StatusProxy': status,
      'StatusHistory': statusHistory,
      'PParamsRequest': pParamsRequest,
      'RecordOldHash': recordOldHash,
      'RecordNew': recordNew,
      'ReplyWithError': replyWithError,
      'LocalError': localError,
      'DinalResponse': finalResponse,
      'TimeCreated': timeCreated,
      'TimeSent': timeSent,
      'TimeQueued': timeQueued,
      'TimeReplied': timeReplied,
      'TimeProcessing': timeProcessing,
      'TimeOK': timeOK,
      'TimeElapsed': timeElapsed,
      'TimeOut': timeOut,
      'ShowWorkInProgress': showWorkInProgress,
      'IsWorkInProgress': isWorkInProgress,
      'XallbackProxyFunction': callbackProxyFunction,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonRPCMessageResponse) return false;

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
