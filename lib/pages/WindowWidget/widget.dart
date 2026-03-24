export 'package:geryon_web_app_ws_v2/shared/window/window_widget.dart';
// import 'dart:developer' as developer;

// import 'package:flutter/material.dart';
// import 'package:geryon_web_app_ws_v2/pages/CatchMainScreen/widget.dart';
// import 'package:geryon_web_app_ws_v2/pages/WindowWidget/mode.dart';

// class WindowWidget extends StatefulWidget {
//   final WindowModel windowModel;

//   const WindowWidget({
//     super.key,
//     required this.windowModel,
//   });

//   @override
//   State<WindowWidget> createState() => _WindowWidgetState();
// }

// class _WindowWidgetState extends State<WindowWidget> {
//   @override
//   Widget build(BuildContext context) {
//     String functionName = 'WindowWidget.build';
//     String logFunc = '.::$functionName::.';
//     double windowWidth = widget.windowModel.constraints.maxWidth;
//     double windowHeight = widget.windowModel.constraints.maxHeight;
//     double windowTitle = 30;
//     double windowFooter = 0;
//     double windowBody = windowHeight - windowTitle - windowFooter;
//     String titleMessage = widget.windowModel.title;
//     developer.log(
//         'logFunc: $logFunc, titleMessage: $titleMessage'
//         ', windowWidth: $windowWidth, windowHeight: $windowHeight',
//         name: logFunc);

//     try {
//       return Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           color: Colors.white,
//         ),
//         width: windowWidth,
//         height: windowHeight,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               /// Header
//               ///
//               Container(
//                 decoration: BoxDecoration(
//                   color: widget.windowModel.titleColorBackground,
//                   borderRadius: const BorderRadiusDirectional.only(
//                     topStart: Radius.circular(5),
//                     topEnd: Radius.circular(5),
//                   ),
//                 ),
//                 height: windowTitle,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     textAlign: TextAlign.start,
//                     text: TextSpan(
//                       text: titleMessage,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               /// Body
//               ///
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                   border: Border(
//                     top: BorderSide(
//                       color: Colors.black26,
//                       width: 1.0,
//                     ),
//                     left: BorderSide(
//                       color: Colors.black26,
//                       width: 1.0,
//                     ),
//                     right: BorderSide(
//                       color: Colors.black26,
//                       width: 1.0,
//                     ),
//                     bottom: BorderSide(
//                       color: Colors.black26,
//                       width: 1.0,
//                     ),
//                   ),
//                   borderRadius: BorderRadiusDirectional.only(
//                     topStart: Radius.zero,
//                     topEnd: Radius.zero,
//                     bottomStart: Radius.zero,
//                     bottomEnd: Radius.zero,
//                   ),
//                 ),
//                 height: windowBody,
//                 width: windowWidth,
//                 child: SizedBox(
//                   child: widget.windowModel.bodyWidget,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     } catch (e, stacktrace) {
//       return CatchMainScreen(
//         locFunc: logFunc,
//         constraints: widget.windowModel.constraints,
//         e: e,
//         stacktrace: stacktrace,
//         debug: true,
//         pScreenMaxHeight: widget.windowModel.constraints.maxHeight,
//         pScreenMaxWidth: widget.windowModel.constraints.maxWidth,
//       );
//     }
//   }
// }
