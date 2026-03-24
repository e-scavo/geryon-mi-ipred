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
    // Reserved for future setup.
  }

  @override
  Widget build(BuildContext context) {
    BoxConstraints rConstraints = BoxConstraints.tight(const Size(400, 400));

    try {
      return LayoutBuilder(
        builder: (context, constraints) {
          rConstraints = constraints;
          final double windowWidth = constraints.maxWidth - 4 - 4;
          final double windowHeight = constraints.maxHeight - 4 - 4;

          return Scrollbar(
            controller: mainScroller,
            thumbVisibility: true,
            child: Card(
              semanticContainer: true,
              child: Column(
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
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    controller: secondScroller,
                                    scrollDirection: Axis.vertical,
                                    dragStartBehavior: DragStartBehavior.start,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
        },
      );
    } catch (e, stacktrace) {
      return CatchMainScreen(
        locFunc: '.::FrameWithScroll.build::.',
        constraints: rConstraints,
        e: e,
        stacktrace: stacktrace,
        debug: true,
        pScreenMaxHeight: rConstraints.maxHeight,
        pScreenMaxWidth: rConstraints.maxWidth,
      );
    }
  }
}
