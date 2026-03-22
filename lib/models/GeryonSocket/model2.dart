// // ignore: avoid_web_libraries_in_flutter
// // import 'dart:html' as html if (dart.library.io) 'dart:io';
// import 'dart:html' as html;
// import 'dart:io' as io;
// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:flutter/foundation.dart';
// import 'package:geryon_web_app_ws_v2/common_vars.dart';
// import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
// import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

// class WebSocketClient extends ChangeNotifier {
//   static const String className = 'WebSocketClient';
//   static const String logClassName = '.::$className::.';

//   final String wssURI;
//   final bool debug;
//   final Function listenCallbackOnData;
//   final dynamic listenCallbackOnError;
//   final dynamic listenCallbackOnDone;

//   dynamic _socket;

//   WebSocketClient({
//     required this.wssURI,
//     required this.listenCallbackOnData,
//     required this.listenCallbackOnError,
//     required this.listenCallbackOnDone,
//     this.debug = false,
//   });

//   Future<ErrorHandler?> init() async {
//     const functionName = 'init';
//     try {
//       final uri = Uri.parse(wssURI);
//       if (uri.port == 0 || uri.host == "0.0.0.0") {
//         return ErrorHandler(
//           errorCode: 1,
//           errorDsc: 'Invalid URI',
//           className: className,
//           functionName: functionName,
//           propertyName: 'URI',
//           propertyValue: wssURI,
//         );
//       }

//       if (kIsWeb) {
//         if (debug)
//           developer.log('🔄 Initializing WebSocket (Web) URI: $wssURI',
//               name: logClassName);
//         _socket = html.WebSocket(wssURI);
//         await _waitForSocketConnection();
//         if (debug)
//           developer.log('✅ WebSocket connected (Web)', name: logClassName);
//         _socket.onMessage.listen((event) => _onData(event.data));
//         _socket.onError.listen((e) => listenCallbackOnError(e));
//         _socket.onClose.listen((_) => listenCallbackOnDone());
//       } else {
//         _socket = await io.WebSocket.connect(wssURI);
//         if (debug)
//           developer.log('✅ WebSocket connected (IO)', name: logClassName);
//         _socket.listen(
//           (event) => _onData(event),
//           onError: listenCallbackOnError,
//           onDone: listenCallbackOnDone,
//         );
//       }
//       return null;
//     } catch (e, stack) {
//       return ErrorHandler(
//         errorCode: 2,
//         errorDsc: e.toString(),
//         stacktrace: stack,
//         className: className,
//         functionName: functionName,
//       );
//     }
//   }

//   void _onData(dynamic event) async {
//     const logFunctionName = '.::onData::.';
//     try {
//       final events = LineSplitter.split(event);
//       for (var element in events) {
//         final decoded = jsonDecode(element);
//         if (debug) developer.log('$decoded', name: logFunctionName);
//         final result = await listenCallbackOnData(decoded);
//         if (result is ErrorHandler && navigatorKey.currentState != null) {
//           await navigatorKey.currentState
//               ?.push(ModelGeneralPoPUpErrorMessageDialog(error: result));
//         }
//       }
//     } catch (e, stack) {
//       final err = ErrorHandler(
//         errorCode: 3,
//         errorDsc: e.toString(),
//         stacktrace: stack,
//         className: className,
//         functionName: '_onData',
//       );
//       await listenCallbackOnData(err.toJson());
//     }
//   }

//   Future<ErrorHandler> sendMessage(String jsonMessage,
//       {required String messageID}) async {
//     try {
//       if (kIsWeb) {
//         if (_socket.readyState != html.WebSocket.OPEN) {
//           return ErrorHandler(errorCode: -1, errorDsc: 'WebSocket not open');
//         }
//         _socket.send(jsonMessage);
//       } else {
//         if (_socket.readyState != io.WebSocket.open) {
//           return ErrorHandler(errorCode: -1, errorDsc: 'WebSocket not open');
//         }
//         _socket.add(jsonMessage);
//       }
//       return ErrorHandler(
//           errorCode: 0, errorDsc: 'Message sent', data: messageID);
//     } catch (e, stacktrace) {
//       return ErrorHandler(
//         errorCode: 4,
//         errorDsc: e.toString(),
//         className: className,
//         stacktrace: stacktrace,
//       );
//     }
//   }

//   Future<void> _waitForSocketConnection() async {
//     const retries = 20;
//     for (int i = 0; i < retries; i++) {
//       if (_socket.readyState == html.WebSocket.OPEN) return;
//       await Future.delayed(Duration(milliseconds: 100));
//     }
//     throw Exception('WebSocket failed to open in time');
//   }

//   /// Function to handle errors
//   /// Returns `ErrorHandler` normalized.
//   ///
//   ErrorHandler errorHandler(
//     dynamic e, {
//     dynamic data,
//     StackTrace? stacktrace,
//   }) {
//     const String functionName = 'errorHandler';
//     const logFunctionName = '.::$functionName::.';
//     if (debug) {
//       developer.log(
//           '$logClassName - $logFunctionName - Exception: ${e.runtimeType}');
//     }
//     switch (e.runtimeType) {
//       // case const (WebSocketChannelException):
//       //   var eException = e as WebSocketChannelException;
//       //   return ErrorHandler(
//       //     errorCode: 1,
//       //     errorDsc: eException.message,
//       //     className: className,
//       //     functionName: functionName,
//       //     propertyName: 'Exception',
//       //     propertyValue: {
//       //       'Message': e.message,
//       //       'Inner': e.inner,
//       //     }.toString(),
//       //     stacktrace: stacktrace,
//       //   );
//       case const (io.SocketException):
//         var eException = e as io.SocketException;
//         return ErrorHandler(
//           errorCode: 1,
//           errorDsc: eException.message,
//           className: className,
//           functionName: functionName,
//           propertyName: 'Exception',
//           propertyValue: {
//             'Address': e.address,
//             'Port': e.port,
//             'OSError': e.osError,
//             'Message': e.message,
//           }.toString(),
//           stacktrace: stacktrace,
//         );
//       default:
//         return ErrorHandler(
//           errorCode: 1,
//           errorDsc: e.toString(),
//           className: className,
//           functionName: functionName,
//           propertyName: 'Desconocido',
//           propertyValue: 'Desconocido',
//           stacktrace: stacktrace,
//         );
//     }
//   }

//   Future<ErrorHandler> sendMessageV2({
//     required String jsonMessage,
//     required String messageID,
//     int apiVersion = 1,
//   }) async {
//     const functionName = 'sendMessageV2';
//     const logFunctionName = '.::$functionName::.';
//     try {
//       _socket.send(jsonMessage);
//       return ErrorHandler(
//         errorCode: 0,
//         errorDsc: 'Message sent',
//         data: messageID,
//         className: className,
//         functionName: functionName,
//         messageID: messageID,
//       );
//     } catch (e, stacktrace) {
//       return ErrorHandler(
//         errorCode: 40,
//         errorDsc: e.toString(),
//         className: className,
//         functionName: functionName,
//         stacktrace: stacktrace,
//         messageID: messageID,
//       );
//     }
//   }
// }
