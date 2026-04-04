import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_loading_state.dart';

class LoadingGeneric extends StatelessWidget {
  final String loadingText;

  const LoadingGeneric({
    super.key,
    this.loadingText = 'Cargando...',
  });

  @override
  Widget build(BuildContext context) {
    return FeatureLoadingState(
      title: loadingText,
    );
  }
}
