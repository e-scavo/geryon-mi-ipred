import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/work_in_progress/work_in_progress_dialog.dart';

class ScreenGeneralPoPUpWorkInProgress<T> extends PopupRoute<T> {
  final String messageID;
  ScreenGeneralPoPUpWorkInProgress({
    required this.messageID,
  });

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Dismissible Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: ScreenGeneralWorkInProgress(
        messageID: messageID,
      ),
    ));
  }
}
