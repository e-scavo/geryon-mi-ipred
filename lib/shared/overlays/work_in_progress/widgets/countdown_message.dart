import 'dart:developer' as developer;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/MessageHandler/model.dart';
import 'package:geryon_web_app_ws_v2/models/const_buttons.dart';

class ScreenGeneralWorkInProgressCountDownTimerMessageDialog
    extends StatefulWidget {
  final CommonRPCMessageResponse messageStatus;
  final int maxTicks;
  final bool backwards;
  final MessageHandler message;

  const ScreenGeneralWorkInProgressCountDownTimerMessageDialog({
    required this.messageStatus,
    required this.message,
    this.backwards = false,
    this.maxTicks = 0,
    super.key,
  });

  @override
  State<ScreenGeneralWorkInProgressCountDownTimerMessageDialog> createState() =>
      _ScreenGeneralWorkInProgresProgresssMessageDialogState();
}

class _ScreenGeneralWorkInProgresProgresssMessageDialogState
    extends State<ScreenGeneralWorkInProgressCountDownTimerMessageDialog> {
  late CommonRPCMessageResponse messageStatus;
  late int maxTicks;
  late bool backwards;
  late MessageHandler message;
  late final ScrollController mainScroller;

  @override
  void initState() {
    super.initState();

    messageStatus = widget.messageStatus;
    message = widget.message;
    maxTicks = widget.maxTicks;
    backwards = widget.backwards;
    mainScroller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var layoutBodyBuilder = LayoutBuilder(
      builder: (context, constraints) {
        developer.log(
          'WorkInProgressPopUp - Body - $constraints',
          name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
        );
        return DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          // UnconstrainedBox is used to make the dialog size itself
          // to fit to the size of the content.
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(),
              color: Colors.transparent,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  message.msgTitle ?? 'LISTO!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: message.msgDsc,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    fontFamily: 'Scavium',
                                    fontFeatures: [
                                      //FontFeature
                                      //  .scientificInferiors(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularCountDownTimer(
                            duration: maxTicks,
                            initialDuration: 0,
                            controller: CountDownController(),
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2,
                            ringColor: Colors.grey[300]!,
                            ringGradient: null,
                            fillColor: Colors.purpleAccent[100]!,
                            fillGradient: null,
                            backgroundColor: Colors.purple[500],
                            backgroundGradient: null,
                            strokeWidth: 10.0,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.S,
                            isReverse: backwards,
                            isReverseAnimation: backwards,
                            isTimerTextShown: true,
                            autoStart: true,
                            onStart: () {
                              debugPrint('Countdown Started');
                            },
                            onComplete: () {
                              debugPrint('Countdown Ended');
                              if (Navigator.canPop(context)) {
                                Navigator.of(context)
                                    .pop(AppConstButtons.buttonClose);
                              }
                            },
                            onChange: (String timeStamp) {
                              debugPrint('Countdown Changed $timeStamp');
                            },
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return "";
                              } else {
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: const TextSpan(
                                  text: 'Code: ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    fontFamily: 'Scavium',
                                    fontFeatures: [
                                      //FontFeature
                                      //  .scientificInferiors(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: '${message.msgCode}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    fontFamily: 'Scavium',
                                    fontFeatures: [
                                      //FontFeature
                                      //  .scientificInferiors(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    var layoutBuilder = LayoutBuilder(
      builder: (context, constraints) {
        developer.log(
          'WorkInProgressPopUp - constraints $constraints',
          name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
        );
        return Scrollbar(
          controller: mainScroller,
          thumbVisibility: true,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              controller: mainScroller,
              scrollDirection: Axis.horizontal,
              dragStartBehavior: DragStartBehavior.start,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                dragStartBehavior: DragStartBehavior.start,
                child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                    //color: Colors.purple.shade100,
                    child: layoutBodyBuilder),
              ),
            ),
          ),
        );
      },
    );
    return layoutBuilder;
  }
}
