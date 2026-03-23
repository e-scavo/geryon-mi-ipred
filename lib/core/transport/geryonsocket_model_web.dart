import 'dart:convert';
import 'dart:js_interop';

import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';
import 'package:web/web.dart' as web;

import 'dart:developer' as developer;
//import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class WebSocketClientPlatform extends ChangeNotifier {
  static const String className = 'WebSocketClientPlatform';
  static const String logClassName = '.::$className::.';

  final String wssURI;
  final bool debug;
  //late WebSocketChannel channel;
  late Stream stream;
  web.WebSocket? _socket;
  late Function listenCallbackOnData;
  late dynamic listenCallbackOnError;
  late dynamic listenCallbackOnDone;
  WebSocketClientPlatform({
    required this.wssURI,
    required this.listenCallbackOnData,
    required this.listenCallbackOnError,
    required this.listenCallbackOnDone,
    this.debug = false,
  });

  Future<ErrorHandler> sendMessageV2({
    required String jsonMessage,
    required String messageID,
    int apiVersion = 1,
  }) async {
    final String functionName = 'sendMessageV2';
    final String logFunctionName = '.::$functionName::.';
    if (_socket == null || _socket!.readyState != web.WebSocket.OPEN) {
      ErrorHandler rError = ErrorHandler(
        errorCode: -1,
        errorDsc: 'Websocket is closed',
        className: className,
        functionName: functionName,
        messageID: messageID,
        propertyName: "CloseCode",
        propertyValue: _socket?.readyState.toString() ?? 'null',
        stacktrace: StackTrace.current,
      );
      developer.log('$className - $logFunctionName - $rError');
      return rError;
    }
    try {
      _socket!.send(jsonMessage.toJS);
      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'Message sent',
        data: messageID,
        className: className,
        functionName: functionName,
        messageID: messageID,
      );
    } catch (e, stacktrace) {
      return ErrorHandler(
        errorCode: 40,
        errorDsc: e.toString(),
        className: className,
        functionName: functionName,
        stacktrace: stacktrace,
        messageID: messageID,
      );
    }
  }

  Future<ErrorHandler> listen() async {
    const String functionName = 'listen';
    String logFunctionName = '.::$functionName::.';
    try {
      developer.log(
        '🔄 Listening on WebSocket URI: $wssURI',
        name: '$logClassName - $logFunctionName',
      );
      if (_socket == null) {
        return ErrorHandler(
          errorCode: 1,
          errorDsc: 'WebSocket not initialized',
          className: className,
          functionName: functionName,
          propertyName: 'Initialization',
          propertyValue: 'WebSocket not initialized',
        );
      }
      _socket!.onMessage.listen(
        (event) async {
          developer.log(
            '📥 Message received: ${event.data}',
            name: '$logClassName - $logFunctionName',
          );
          Map<String, dynamic> data = {};
          try {
            var myEvents = LineSplitter.split(event.data.toString());
            for (var myEvent in myEvents) {
              if (myEvent.isNotEmpty) {
                var jsonData = jsonDecode(myEvent);
                if (jsonData is Map<String, dynamic>) {
                  developer.log(
                    '📥 Received Map data: $jsonData',
                    name: '$logClassName - $logFunctionName',
                  );
                  data.addAll(jsonData);
                  await listenCallbackOnData(data);
                } else {
                  developer.log(
                    '📥 Received non-Map data: $myEvent',
                    name: '$logClassName - $logFunctionName',
                  );
                }
              } else {
                developer.log(
                  '📥 Received empty event',
                  name: '$logClassName - $logFunctionName',
                );
              }
            }
          } catch (e, stacktrace) {
            if (debug) {
              developer.log(
                '$logClassName - $logFunctionName - Exception: ${e.runtimeType}',
                error: e,
                stackTrace: stacktrace,
              );
            }
            Map<dynamic, dynamic> j = {};
            j['error_code'] = 1;
            j['error_dsc'] = e.toString;
            j['data'] = data;
            j['stacktrace'] = stacktrace;
            Map<String, dynamic> jMap = Map<String, dynamic>.from(j);
            await listenCallbackOnData(jMap);
          }
        },
        onError: (error) {
          developer.log(
            '❌ WebSocket error: ${error.toString()}',
            name: '$logClassName - $logFunctionName',
          );
          Map rError = {};
          rError['key'] = error;
          listenCallbackOnError(rError);
        },
        onDone: () {
          developer.log(
            '🔚 WebSocket closed',
            name: '$logClassName - $logFunctionName',
          );
          listenCallbackOnDone();
        },
      );
      // _socket!.onError.listen((event) {
      //   developer.log(
      //     '❌ WebSocket error: ${event.toString()}',
      //     name: '$logClassName - $logFunctionName',
      //   );
      //   listenCallbackOnError(event);
      // });
      // _socket!.onClose.listen((event) {
      //   developer.log(
      //     '🔚 WebSocket closed: ${event.code} - ${event.reason}',
      //     name: '$logClassName - $logFunctionName',
      //   );
      //   listenCallbackOnDone();
      // });
      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'Listening on WebSocket URI successful',
        className: className,
        functionName: functionName,
        propertyName: 'Listening',
        propertyValue: 'Success',
      );
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          '$logClassName - $logFunctionName - Exception: ${e.runtimeType}',
          error: e,
          stackTrace: stacktrace,
        );
      }
      return errorHandler(e, stacktrace: stacktrace);
    }
  }

  Future<ErrorHandler> init() async {
    const String functionName = 'init';
    String logFunctionName = '.::$functionName::.';
    try {
      developer.log(
        '🔄 Initializing WebSocket URI: $wssURI',
        name: '$logClassName - $logFunctionName',
      );
      var realURI = Uri.parse(wssURI);
      if (realURI.port == 0 || realURI.host == "0.0.0.0") {
        developer.log(
          '❌ Invalid URI: $wssURI',
          name: '$logClassName - $logFunctionName',
        );
        return ErrorHandler(
          errorCode: 1,
          errorDsc: 'Invalid URI',
          className: className,
          functionName: functionName,
          propertyName: 'URI',
          propertyValue: wssURI,
        );
      }
      if (_socket != null && _socket!.readyState == web.WebSocket.OPEN) {
        developer.log(
          '🔄 WebSocket already connected: $wssURI',
          name: '$logClassName - $logFunctionName',
        );
        return ErrorHandler(
          errorCode: 0,
          errorDsc: 'WebSocket already connected',
          className: className,
          functionName: functionName,
          propertyName: 'Connection',
          propertyValue: 'Already connected',
        );
      }
      _socket = web.WebSocket(wssURI);
      _socket!.onOpen.listen((event) {
        developer.log(
          '✅ WebSocket connected: $wssURI',
          name: '$logClassName - $logFunctionName',
        );
      });
      // _socket!.onMessage.listen((event) {
      //   developer.log(
      //     '📥 Message received: ${event.data}',
      //     name: '$logClassName - $logFunctionName',
      //   );
      //   listenCallbackOnData(event.data);
      // });
      _socket!.onError.listen((event) {
        developer.log(
          '❌ WebSocket error: ${event.toString()} Tipo:${event.runtimeType}',
          name: '$logClassName - $logFunctionName',
        );
        listenCallbackOnError(event);
      });
      _socket!.onClose.listen((event) {
        developer.log(
          '🔚 WebSocket closed: ${event.code} - ${event.reason}',
          name: '$logClassName - $logFunctionName',
        );
        listenCallbackOnDone();
      });
      developer.log(
        '🔄 Waiting for WebSocket to be ready',
        name: '$logClassName - $logFunctionName',
      );
      await listen();
      developer.log(
        '✅ WebSocket is ready',
        name: '$logClassName - $logFunctionName',
      );
      developer.log(
        '${LogIcons.check} WebSocket initialized successfully: $wssURI',
        name: '$logClassName - $logFunctionName',
      );
      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'WebSocket initialized successfully',
        className: className,
        functionName: functionName,
        propertyName: 'Initialization',
        propertyValue: 'Success',
      );
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'Exception: ${e.runtimeType}',
          name: '$logClassName - $logFunctionName',
          error: e,
          stackTrace: stacktrace,
        );
      }
      return errorHandler(e, stacktrace: stacktrace);
    }
  }

  ErrorHandler errorHandler(
    dynamic e, {
    dynamic data,
    StackTrace? stacktrace,
  }) {
    const String functionName = 'errorHandler';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
          '$logClassName - $logFunctionName - Exception: ${e.runtimeType}');
    }
    switch (e.runtimeType) {
      // case const (WebSocketChannelException):
      //   var eException = e as WebSocketChannelException;
      //   return ErrorHandler(
      //     errorCode: 1,
      //     errorDsc: eException.message,
      //     className: className,
      //     functionName: functionName,
      //     propertyName: 'Exception',
      //     propertyValue: {
      //       'Message': e.message,
      //       'Inner': e.inner,
      //     }.toString(),
      //     stacktrace: stacktrace,
      //   );
      // case const (io.SocketException):
      //   var eException = e as io.SocketException;
      //   return ErrorHandler(
      //     errorCode: 1,
      //     errorDsc: eException.message,
      //     className: className,
      //     functionName: functionName,
      //     propertyName: 'Exception',
      //     propertyValue: {
      //       'Address': e.address,
      //       'Port': e.port,
      //       'OSError': e.osError,
      //       'Message': e.message,
      //     }.toString(),
      //     stacktrace: stacktrace,
      //   );
      default:
        return ErrorHandler(
          errorCode: 1,
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
