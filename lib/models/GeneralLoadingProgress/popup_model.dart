import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/GeneralLoadingProgress/model.dart';

class ModelGeneralPoPUpLoadingProgress<T> extends PopupRoute<T> {
  ModelGeneralPoPUpLoadingProgress();

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
    return const Center(
        child: Material(
      type: MaterialType.transparency,
      child: ModelGeneralLoadingProgress(), // Your ConsumerStatefulWidget
    ));
  }
}
