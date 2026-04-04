import 'dart:developer' as developer;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ScreenGeneralWorkInProgressErrorMessageDialog extends StatefulWidget {
  final ErrorHandler error;
  const ScreenGeneralWorkInProgressErrorMessageDialog({
    required this.error,
    super.key,
  });

  @override
  State<ScreenGeneralWorkInProgressErrorMessageDialog> createState() =>
      _ScreenGeneralWorkInProgressErrorMessageDialogState();
}

class _ScreenGeneralWorkInProgressErrorMessageDialogState
    extends State<ScreenGeneralWorkInProgressErrorMessageDialog> {
  final FocusNode _buttonOkFocusNode = FocusNode();
  late final ScrollController mainScroller;

  @override
  void initState() {
    super.initState();

    ///
    ///
    mainScroller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buttonOkFocusNode.requestFocus();
    final ErrorHandler error = widget.error;

    //
    ///
    ///

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
                Text('Error', style: Theme.of(context).textTheme.headlineSmall),
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
                                  text: error.errorDsc,
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
                                  text: '${error.errorCode}',
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
                // Row(
                //   children: [
                //     TextButton(
                //       focusNode: _buttonOkFocusNode,
                //       onPressed: () {
                //         Navigator.of(context).pop(AppConstButtons.buttonOk);
                //       },
                //       child: const Text('Ok'),
                //     ),
                //   ],
                // ),
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
