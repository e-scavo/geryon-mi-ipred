// import 'dart:convert';
// import 'dart:io';
// import 'dart:developer' as developer;

// import 'package:flutter/material.dart';
// import 'package:geryon_web_app_ws_v2/common_vars.dart';
// import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
// import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketClient extends ChangeNotifier {
//   static final String className = 'WebSocketClient';
//   static final String logClassName = '.::$className::.';
//   final String wssURI;
//   final bool debug;
//   late WebSocketChannel channel;
//   late Stream stream;
//   late Socket socket;
//   late Function listenCallbackOnData;
//   late dynamic listenCallbackOnError;
//   late dynamic listenCallbackOnDone;
//   //Function<Map<dynamic,dynamic> sdsd;

//   WebSocketClient({
//     required this.wssURI,
//     required this.listenCallbackOnData,
//     required this.listenCallbackOnError,
//     required this.listenCallbackOnDone,
//     this.debug = false,
//   });

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
//       case const (WebSocketChannelException):
//         var eException = e as WebSocketChannelException;
//         return ErrorHandler(
//           errorCode: 1,
//           errorDsc: eException.message,
//           className: className,
//           functionName: functionName,
//           propertyName: 'Exception',
//           propertyValue: {
//             'Message': e.message,
//             'Inner': e.inner,
//           }.toString(),
//           stacktrace: stacktrace,
//         );
//       case const (SocketException):
//         var eException = e as SocketException;
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

//   /// Function to initialize the websotcket channel to the backend
//   /// Returns `null` on no errors
//   ///
//   Future<ErrorHandler?> init() async {
//     const functionName = 'init';
//     const logFunctionName = '.::$functionName::.';
//     try {
//       if (debug) {
//         developer
//             .log('$logClassName - $logFunctionName - Connecting to $wssURI');
//       }
//       var realURI = Uri.parse(wssURI);
//       if (realURI.port == 0 || realURI.host == "0.0.0.0") {
//         return ErrorHandler(
//           errorCode: 1,
//           errorDsc: 'Invalid URI',
//           className: className,
//           functionName: functionName,
//           propertyName: 'URI',
//           propertyValue: wssURI,
//         );
//       }
//       channel = WebSocketChannel.connect(
//         Uri.parse(wssURI),
//       );
//       if (debug) {
//         developer.log('$logClassName - $logFunctionName - Done.');
//       }
//       if (debug) {
//         developer.log(
//             '$logClassName - $logFunctionName - Waiting for channel to be ready');
//       }
//       await channel.ready;
//       if (debug) {
//         developer
//             .log('$logClassName - $logFunctionName - Done. Channel is ready');
//       }

//       return null;
//     } catch (error, stacktrace) {
//       if (debug) {
//         developer.log(
//             '$logClassName - $logFunctionName - Exception caught: ${error.toString()}');
//       }
//       return errorHandler(
//         error,
//         stacktrace: stacktrace,
//       );
//     }
//   }

//   ///
//   ///
//   ///
//   /// Listen for all incoming data
//   Future<ErrorHandler?> listen() async {
//     const String logFunctionName = '.::Listen::.';
//     stream = channel.stream;

//     /// StreamSubscription<dynamic> steamListen =
//     stream.listen(
//       (event) async {
//         Map<String, dynamic> data = {};
//         try {
//           var myEvents = LineSplitter.split(event);
//           for (var element in myEvents) {
//             Map<String, dynamic> rEvent =
//                 jsonDecode(element, reviver: (key, value) {
//               if (value.runtimeType == int) {
//                 //return value.toString();
//               }

//               return value;
//             }) as Map<String, dynamic>;
//             //Map<String, dynamic> rEventMap = Map<String, dynamic>.from(rEvent);
//             if (debug) {
//               developer.log(
//                   '$logClassName - $logFunctionName - Data received. Calling OnData callback function');
//             }
//             data = rEvent;
//             var rCallBack = await listenCallbackOnData(rEvent);

//             if (rCallBack.runtimeType == ErrorHandler) {
//               if (debug) {
//                 developer.log(
//                     '$logClassName - $logFunctionName - Errors received from OnData callback function');
//               }
//               if (navigatorKey.currentState != null) {
//                 await navigatorKey.currentState?.push(
//                     ModelGeneralPoPUpErrorMessageDialog(
//                         error: rCallBack as ErrorHandler));
//               }
//             }
//             if (debug) {
//               developer.log('$logClassName - $logFunctionName - Done.');
//             }
//           }
//         } catch (e, stackTrace) {
//           if (debug) {
//             developer.log(
//                 '$logClassName - $logFunctionName - Exception caught: ${e.toString()} - stack: $stackTrace');
//           }
//           Map<dynamic, dynamic> j = {};
//           j['error_code'] = 1;
//           j['error_dsc'] = e.toString;
//           j['data'] = data;
//           j['stacktrace'] = stackTrace;
//           Map<String, dynamic> jMap = Map<String, dynamic>.from(j);
//           await listenCallbackOnData(jMap);
//         }
//       },
//       onError: (error) {
//         Map rError = {};
//         rError['key'] = error;
//         listenCallbackOnError(rError);
//       },
//       onDone: () {
//         listenCallbackOnDone();
//       },
//     );
//     return null;
//   }

//   /// SendMessage
//   ///
//   ///
//   Future<ErrorHandler> sendMessage({
//     required String jsonMessage,
//     required String messageID,
//     int apiVersion = 1,
//   }) async {
//     if (channel.closeCode != null) {
//       return ErrorHandler(
//         errorCode: -1,
//         errorDsc: 'Websocket is closed',
//         propertyName: "CloseCode",
//         className: className,
//       );
//     }
//     try {
//       channel.sink.add(jsonMessage);
//       return ErrorHandler(
//         errorCode: 0,
//         errorDsc: 'Message sent',
//         data: messageID,
//         className: className,
//       );
//     } catch (e, stacktrace) {
//       return ErrorHandler(
//         errorCode: 40,
//         errorDsc: e.toString(),
//         className: className,
//         stacktrace: stacktrace,
//       );
//     }
//   }

//   /// SendMessageV2
//   ///
//   ///
//   Future<ErrorHandler> sendMessageV2({
//     required String jsonMessage,
//     required String messageID,
//     int apiVersion = 1,
//   }) async {
//     final String functionName = 'sendMessageV2';
//     final String logFunctionName = '.::$functionName::.';
//     if (channel.closeCode != null) {
//       ErrorHandler rError = ErrorHandler(
//         errorCode: -1,
//         errorDsc: 'Websocket is closed',
//         className: className,
//         functionName: functionName,
//         messageID: messageID,
//         propertyName: "CloseCode",
//         propertyValue: {
//           'Code': channel.closeCode.toString(),
//           'Reason': channel.closeReason.toString(),
//         }.toString(),
//         stacktrace: StackTrace.current,
//       );
//       developer.log('$className - $logFunctionName - $rError');
//       return rError;
//     }
//     try {
//       channel.sink.add(jsonMessage);
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
