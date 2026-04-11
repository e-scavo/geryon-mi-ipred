import 'package:flutter/material.dart';

class ShareAction {
  static Future<void> share({
    required BuildContext context,
    required String content,
  }) async {
// Placeholder para Phase 16 (share_plus o similar)

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de compartir disponible próximamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
