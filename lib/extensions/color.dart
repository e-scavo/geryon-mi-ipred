import 'package:flutter/material.dart';

extension SafeOpacity on Color {
  Color withSafeOpacity(double opacity) {
    return withValues(
      red: r,
      green: g,
      blue: b,
      alpha: (opacity * 255).toDouble(),
    );
  }
}
