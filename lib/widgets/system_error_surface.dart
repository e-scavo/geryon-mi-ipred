import 'dart:developer' as developer;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CatchMainScreen extends StatefulWidget {
  static String mainFunc = 'CatchMainScreen';
  final String locFunc;
  final BoxConstraints constraints;
  final Object e;
  final StackTrace stacktrace;
  final bool debug;
  final double pScreenMaxWidth;
  final double pScreenMaxHeight;
  final bool showTitleBar;
  final bool showClosebutton;
  final bool showStacktrace;
  const CatchMainScreen({
    required this.locFunc,
    required this.constraints,
    required this.e,
    required this.stacktrace,
    required this.debug,
    required this.pScreenMaxHeight,
    required this.pScreenMaxWidth,
    this.showTitleBar = true,
    this.showClosebutton = true,
    this.showStacktrace = true,
    super.key,
  });

  @override
  State<CatchMainScreen> createState() => _CatchMainScreenState();
}

class _CatchMainScreenState extends State<CatchMainScreen> {
  final String locFunc = '_CatchMainScreenState';
  late final ScrollController mainCatchScroller;
  late final ScrollController secondCatchScroller;
  late double screenMaxWidth;
  late double screenMaxHeight;
  @override
  void initState() {
    super.initState();
    mainCatchScroller = ScrollController();
    secondCatchScroller = ScrollController();
    screenMaxWidth = widget.pScreenMaxWidth;
    screenMaxHeight = widget.pScreenMaxHeight;
  }

  @override
  Widget build(BuildContext context) {
    double maxScreenWidth = MediaQuery.of(context).size.width;
    double maxScreenHeight = MediaQuery.of(context).size.height;
    const String locFunc2 = '.::LayoutBuilder::.';
    var e = widget.e;
    var stacktrace = widget.stacktrace;
    var constraints = widget.constraints;
    if (widget.debug) {
      developer.log(
          '${CatchMainScreen.mainFunc} - $locFunc - $locFunc2 - maxScreenWidth:$maxScreenWidth[${constraints.maxWidth}] - maxScreenHeight:$maxScreenHeight[${constraints.maxHeight}]');
    }
    final themeData = Theme.of(context);
    double titleHeight = 30;

    double bodyHeight = widget.constraints.maxHeight - 4 - 4 - titleHeight;
    return Scrollbar(
      controller: mainCatchScroller,
      thumbVisibility: true,
      child: Card(
        semanticContainer: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showTitleBar)

              /// Header Title
              Container(
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  border: Border(
                    bottom: BorderSide(
                      color: themeData.primaryColorDark,
                    ),
                  ),
                ),
                height: titleHeight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: const TextSpan(
                        text: 'Error de SISTEMA',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            /// Body
            ///

            SizedBox(
              height: bodyHeight,
              width: screenMaxWidth,
              child: SingleChildScrollView(
                  controller: mainCatchScroller,
                  scrollDirection: Axis.horizontal,
                  dragStartBehavior: DragStartBehavior.start,
                  child: Column(
                    children: [
                      Expanded(
                          child: SizedBox(
                              //width: screenMaxWidth,
                              child: SingleChildScrollView(
                                  //controller: mainScroller,
                                  scrollDirection: Axis.vertical,
                                  dragStartBehavior: DragStartBehavior.start,
                                  child: Scrollbar(
                                    controller: secondCatchScroller,
                                    thumbVisibility: true,
                                    child: SizedBox(
                                      //width: screenMaxWidth,
                                      child: SingleChildScrollView(
                                        controller: secondCatchScroller,
                                        scrollDirection: Axis.vertical,
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Error:\r\n\t${e.toString()}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (widget.showStacktrace)
                                              Text(
                                                'Stacktrace:\r\n\t${stacktrace.toString()}',
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )))),
                      const SizedBox(
                        height: 5,
                      ),
                      if (widget.showClosebutton)
                        Row(
                          children: [
                            SizedBox(
                              width: screenMaxWidth * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5.0), // Adjust the radius as needed
                                      ),
                                      elevation: 5),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.close),
                                      Text(
                                        'Cerrar',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
