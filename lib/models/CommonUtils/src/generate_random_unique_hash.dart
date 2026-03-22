part of '../common_utils.dart';

/// Genera un hash único y rándom
///
String generateRandomUniqueHash() {
  // 1. Generar un número aleatorio usando Random
  final random = Random.secure();
  final randomBytes = List<int>.generate(16, (_) => random.nextInt(256));

  // 2. Convertir a una cadena de texto (puedes combinarlo con otros valores si es necesario)
  final randomString = base64Url.encode(randomBytes);

  // 3. Generar el hash (SHA-256)
  final bytes =
      utf8.encode(randomString); // Convertimos el string aleatorio a bytes
  final hash = sha256.convert(bytes); // Usamos SHA-256 para el hash

  // 4. Retornar el valor en formato hexadecimal
  return hash.toString();
}
