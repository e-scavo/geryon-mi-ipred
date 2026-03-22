import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/pages/CatchMainScreen/widget.dart';

class FrameWithScroll extends ConsumerStatefulWidget {
  final Widget pBody;
  const FrameWithScroll({
    super.key,
    required this.pBody,
  });

  @override
  ConsumerState<FrameWithScroll> createState() => _FrameWithScrollState();
}

class _FrameWithScrollState extends ConsumerState<FrameWithScroll> {
  late final ScrollController mainScroller;
  late final ScrollController mainCatchScroller;
  late final ScrollController secondScroller;
  late final ScrollController secondCatchScroller;

  @override
  void initState() {
    super.initState();
    mainScroller = ScrollController();
    mainCatchScroller = ScrollController();
    secondScroller = ScrollController();
    secondCatchScroller = ScrollController();
    _initWork();
  }

  @override
  void dispose() {
    mainScroller.dispose();
    mainCatchScroller.dispose();
    secondScroller.dispose();
    secondCatchScroller.dispose();
    super.dispose();
  }

  void _initWork() {
    // Initialize any work needed for the widget
  }

  @override
  Widget build(BuildContext context) {
    BoxConstraints rConstraints = BoxConstraints.tight(Size(400, 400));

    try {
      return LayoutBuilder(builder: (context, constraints) {
        rConstraints = constraints;
        double windowWidth = constraints.maxWidth - 4 - 4;
        double windowHeight = constraints.maxHeight - 4 - 4;
//        double bodyHeight = constraints.maxHeight - 4 - 4 - titleHeight;
        //double bodyHeight = screenMaxHeight - 4 - 4 - titleHeight;
        //double bodyWidth = constraints.maxWidth - 4 - 4;

        return Scrollbar(
          controller: mainScroller,
          thumbVisibility: true,
          child: Card(
            semanticContainer: true,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: windowHeight,
                  width: windowWidth,
                  child: SingleChildScrollView(
                    controller: mainScroller,
                    scrollDirection: Axis.horizontal,
                    dragStartBehavior: DragStartBehavior.start,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            dragStartBehavior: DragStartBehavior.start,
                            child: Scrollbar(
                              controller: secondScroller,
                              thumbVisibility: true,
                              child: Container(
                                // width: windowWidth,
                                // height: windowHeight,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  controller: secondScroller,
                                  scrollDirection: Axis.vertical,
                                  dragStartBehavior: DragStartBehavior.start,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     Center(
                                      //       child: Text(
                                      //         'Contenido de la página',
                                      //         style: TextStyle(fontSize: 24),
                                      //       ),
                                      //     ),
                                      //     Center(
                                      //       child: Text(
                                      //         'Contenido de la página',
                                      //         style: TextStyle(fontSize: 24),
                                      //       ),
                                      //     ),
                                      //     Center(
                                      //       child: Text(
                                      //         'Contenido de la página',
                                      //         style: TextStyle(fontSize: 24),
                                      //       ),
                                      //     ),
                                      //     Center(
                                      //       child: Text(
                                      //         'Contenido de la página',
                                      //         style: TextStyle(fontSize: 24),
                                      //       ),
                                      //     ),
                                      //     Center(
                                      //       child: Text(
                                      //         'Contenido de la página',
                                      //         style: TextStyle(fontSize: 24),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      widget.pBody,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
    } catch (e, stacktrace) {
      // Handle exceptions and return a CatchMainScreen or similar widget
      return CatchMainScreen(
        locFunc: '.::FrameWithScroll.build::.',
        constraints: rConstraints,
        e: e,
        stacktrace: stacktrace,
        debug: true,
        pScreenMaxHeight: rConstraints.maxHeight, // Example height
        pScreenMaxWidth: rConstraints.maxWidth, // Example width
      );
    }
  }
}
