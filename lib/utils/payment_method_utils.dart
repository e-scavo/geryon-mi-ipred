class PaymentMethodUtils {
  static String? extractExternalUrl(Map<String, dynamic> method) {
    // Orden de prioridad basado en lo que típicamente devuelve backend
    final possibleKeys = [
      'url',
      'link',
      'paymentUrl',
      'externalUrl',
      'redirectUrl',
    ];

    for (final key in possibleKeys) {
      final value = method[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return null;
  }
}
