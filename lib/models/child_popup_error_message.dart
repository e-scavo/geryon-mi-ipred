import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/const_buttons.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ModelGeneralPoPUpErrorMessageDialog<T> extends PopupRoute<T> {
  final ErrorHandler error;

  ModelGeneralPoPUpErrorMessageDialog({
    required this.error,
  });

  final FocusNode _buttonOkFocusNode = FocusNode();

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Dismissible Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    _buttonOkFocusNode.requestFocus();
    return Center(
      // Provide DefaultTextStyle to ensure that the dialog's text style
      // matches the rest of the text in the app.
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        // UnconstrainedBox is used to make the dialog size itself
        // to fit to the size of the content.
        child: UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
                Row(
                  children: [
                    TextButton(
                      focusNode: _buttonOkFocusNode,
                      onPressed: () {
                        Navigator.of(context).pop(AppConstButtons.buttonOk);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
