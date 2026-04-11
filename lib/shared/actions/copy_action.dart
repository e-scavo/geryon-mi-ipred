import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyAction {
  static Future<void> copy({
    required BuildContext context,
    required String value,
    String? successMessage,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage ?? 'Copiado al portapapeles'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
