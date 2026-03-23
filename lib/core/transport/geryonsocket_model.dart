import 'package:flutter/widgets.dart';

// Carga UNO de los dos archivos según la plataforma:
import 'geryonsocket_model_web.dart'
    if (dart.library.io) 'geryonsocket_model_io.dart';

import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class WebSocketClient extends ChangeNotifier {
  static const String className = 'WebSocketClient';
  static const String logClassName = '.::$className::.';

  final dynamic _impl;

  WebSocketClient({
    required String wssURI,
    required Function listenCallbackOnData,
    required Function listenCallbackOnError,
    required Function listenCallbackOnDone,
    bool debug = false,
  }) : _impl = _createPlatformInstance(
          wssURI: wssURI,
          listenCallbackOnData: listenCallbackOnData,
          listenCallbackOnError: listenCallbackOnError,
          listenCallbackOnDone: listenCallbackOnDone,
          debug: debug,
        );

  static dynamic _createPlatformInstance({
    required String wssURI,
    required Function listenCallbackOnData,
    required Function listenCallbackOnError,
    required Function listenCallbackOnDone,
    bool debug = false,
  }) {
    // La clase seleccionada según la plataforma:
    return WebSocketClientPlatform(
      wssURI: wssURI,
      listenCallbackOnData: listenCallbackOnData,
      listenCallbackOnError: listenCallbackOnError,
      listenCallbackOnDone: listenCallbackOnDone,
      debug: debug,
    );
  }

  ErrorHandler errorHandler(
    dynamic e, {
    dynamic data,
    StackTrace? stacktrace,
  }) {
    return _impl.errorHandler(
      e,
      data: data,
      stacktrace: stacktrace,
    );
  }

  Future<ErrorHandler> init() => _impl.init();
  Future<ErrorHandler> listen() => _impl.listen();
  Future<ErrorHandler> sendMessageV2({
    required String jsonMessage,
    required String messageID,
    int apiVersion = 1,
  }) =>
      _impl.sendMessageV2(
        jsonMessage: jsonMessage,
        messageID: messageID,
        apiVersion: apiVersion,
      );
}
