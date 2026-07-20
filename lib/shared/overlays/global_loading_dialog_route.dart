import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/global_loading_dialog.dart';

class ModelGeneralPoPUpLoadingProgress<T> extends PopupRoute<T> {
  ModelGeneralPoPUpLoadingProgress();

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.42);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Conexión en curso';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const Center(
      child: Material(
        type: MaterialType.transparency,
        child: ModelGeneralLoadingProgress(),
      ),
    );
  }
}
