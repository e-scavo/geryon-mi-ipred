part of '../common_utils.dart';

/// Valida si un valor es "nulo" en sentido amplio:
/// - null real
/// - string 'null'
/// - string vacío
/// - Map vacío
/// - List vacía
bool isNull(dynamic pData) {
  if (pData == null) return true;

  final str = pData.toString().trim().toLowerCase();
  if (str == 'null') return true;

  if (pData is Map && pData.isEmpty) return true;
  if (pData is List && pData.isEmpty) return true;
  if (pData is String && pData.trim().isEmpty) return true;

  return false;
}
