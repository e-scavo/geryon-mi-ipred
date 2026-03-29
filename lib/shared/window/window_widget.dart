import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/pages/CatchMainScreen/widget.dart';
import 'package:geryon_web_app_ws_v2/shared/window/window_model.dart';

class WindowWidget extends StatefulWidget {
  final WindowModel windowModel;

  const WindowWidget({
    super.key,
    required this.windowModel,
  });

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  @override
  Widget build(BuildContext context) {
    const String functionName = 'WindowWidget.build';
    const String logFunc = '.::$functionName::.';
    final double windowWidth = widget.windowModel.constraints.maxWidth;
    final double windowHeight = widget.windowModel.constraints.maxHeight;
    const double windowTitle = 30;
    final bool hasHeader = widget.windowModel.headerWidget != null;
    final String titleMessage = widget.windowModel.title;

    developer.log(
      'logFunc: $logFunc, titleMessage: $titleMessage, '
      'windowWidth: $windowWidth, windowHeight: $windowHeight, hasHeader: $hasHeader',
      name: logFunc,
    );

    try {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        width: windowWidth,
        height: windowHeight,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.windowModel.titleColorBackground,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(8),
                  topEnd: Radius.circular(8),
                ),
              ),
              height: windowTitle,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: titleMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                    left: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                    right: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    if (hasHeader) widget.windowModel.headerWidget!,
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child:
                            widget.windowModel.bodyWidget ?? const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e, stacktrace) {
      return CatchMainScreen(
        locFunc: logFunc,
        constraints: widget.windowModel.constraints,
        e: e,
        stacktrace: stacktrace,
        debug: true,
        pScreenMaxHeight: widget.windowModel.constraints.maxHeight,
        pScreenMaxWidth: widget.windowModel.constraints.maxWidth,
      );
    }
  }
}
