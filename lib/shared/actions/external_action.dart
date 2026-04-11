import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalAction {
  static Future<void> open({
    required BuildContext context,
    required String url,
  }) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showError(context, 'URL inválida');
      return;
    }

    try {
      final success =
          await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!success) {
        _showError(context, 'No se pudo abrir el enlace');
      }
    } catch (_) {
      _showError(context, 'Error al abrir el enlace');
    }
  }

  static void _showError(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
