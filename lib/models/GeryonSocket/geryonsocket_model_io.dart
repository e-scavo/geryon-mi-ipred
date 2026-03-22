import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class WebSocketClientPlatform extends ChangeNotifier {
  static const String className = 'WebSocketClientPlatformIO';
  static const String logClassName = '.::$className::.';

  final String wssURI;
  final bool debug;

  WebSocket? _socket;
  late Stream stream;

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

  Future<ErrorHandler> init() async {
    const String functionName = 'init';
    const String logFunctionName = '.::$functionName::.';
    try {
      developer.log(
        '🔄 Initializing WebSocket URI: $wssURI',
        name: '$logClassName - $logFunctionName',
      );
      var realURI = Uri.parse(wssURI);
      if (realURI.port == 0 || realURI.host == "0.0.0.0") {
        return ErrorHandler(
          errorCode: 1,
          errorDsc: 'Invalid URI',
          className: className,
          functionName: functionName,
          propertyName: 'URI',
          propertyValue: wssURI,
        );
      }

      _socket = await WebSocket.connect(wssURI);
      _socket!.done.then((_) {
        developer.log(
          '🔚 WebSocket closed',
          name: '$logClassName - $logFunctionName',
        );
        listenCallbackOnDone();
      });

      developer.log(
        '🔄 Waiting for WebSocket to be ready',
        name: '$logClassName - $logFunctionName',
      );
      var rListen = await listen();
      developer.log(
        '✅ WebSocket is ready ${rListen.toJson()}',
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
      return errorHandler(e, stacktrace: stacktrace);
    }
  }

  Future<ErrorHandler> listen() async {
    const String functionName = 'listen';
    const String logFunctionName = '.::$functionName::.';
    try {
      if (_socket == null) {
        return ErrorHandler(
          errorCode: 1,
          errorDsc: 'WebSocket not initialized',
          className: className,
          functionName: functionName,
        );
      }

      _socket!.listen(
        (dynamic data) async {
          developer.log(
            '📥 Message received: $data',
            name: '$logClassName - $logFunctionName',
          );
          try {
            Map<String, dynamic> parsedData = {};
            var events = LineSplitter.split(data.toString());
            for (var event in events) {
              if (event.isNotEmpty) {
                var jsonData = jsonDecode(event);
                if (jsonData is Map<String, dynamic>) {
                  parsedData.addAll(jsonData);
                  await listenCallbackOnData(parsedData);
                }
              }
            }
          } catch (e, stacktrace) {
            if (debug) {
              developer.log(
                '❌ Error decoding message: ${e.toString()}',
                error: e,
                stackTrace: stacktrace,
              );
            }
            await listenCallbackOnError({
              'error': e.toString(),
              'stacktrace': stacktrace,
            });
          }
        },
        onError: (error) {
          developer.log(
            '❌ WebSocket error: $error',
            name: '$logClassName - $logFunctionName',
          );
          listenCallbackOnError({'error': error.toString()});
        },
        onDone: () {
          developer.log(
            '🔚 WebSocket closed',
            name: '$logClassName - $logFunctionName',
          );
          listenCallbackOnDone();
        },
        cancelOnError: true,
      );

      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'Listening started',
        className: className,
        functionName: functionName,
      );
    } catch (e, stacktrace) {
      return errorHandler(e, stacktrace: stacktrace);
    }
  }

  Future<ErrorHandler> sendMessageV2({
    required String jsonMessage,
    required String messageID,
    int apiVersion = 1,
  }) async {
    const String functionName = 'sendMessageV2';
    const String logFunctionName = '.::$functionName::.';
    if (_socket == null || _socket!.closeCode != null) {
      if (debug) {
        developer.log(
          '❌ WebSocket is not connected or closed',
          name: '$logClassName - $logFunctionName',
        );
      }
      return ErrorHandler(
        errorCode: -1,
        errorDsc: 'WebSocket is closed',
        className: className,
        functionName: functionName,
        messageID: messageID,
      );
    }
    try {
      _socket!.add(jsonMessage);
      if (debug) {
        developer.log(
          '📤 Sending message: $jsonMessage',
          name: '$logClassName - $logFunctionName',
        );
      }
      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'Message sent',
        className: className,
        functionName: functionName,
        messageID: messageID,
      );
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          '❌ Error sending message: ${e.toString()}',
          error: e,
          stackTrace: stacktrace,
          name: '$logClassName - $logFunctionName',
        );
      }
      return errorHandler(e, stacktrace: stacktrace);
    }
  }

  ErrorHandler errorHandler(
    dynamic e, {
    StackTrace? stacktrace,
  }) {
    return ErrorHandler(
      errorCode: 1,
      errorDsc: e.toString(),
      className: className,
      functionName: 'errorHandler',
      propertyName: 'Exception',
      propertyValue: e.runtimeType.toString(),
      stacktrace: stacktrace,
    );
  }
}
