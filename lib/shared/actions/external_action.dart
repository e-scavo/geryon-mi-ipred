import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalAction {
  static Future<void> open({
    required BuildContext context,
    required String url,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showError(messenger, 'URL inválida');
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        _showError(messenger, 'No se pudo abrir el enlace');
      }
    } catch (_) {
      _showError(messenger, 'Error al abrir el enlace');
    }
  }

  static void _showError(
    ScaffoldMessengerState messenger,
    String message,
  ) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
