import 'package:flutter/material.dart';

class BillingWorkbenchColumn {
  final String key;
  final String label;
  final double width;
  final Alignment alignment;
  final bool sortable;
  final String? sortField;

  const BillingWorkbenchColumn({
    required this.key,
    required this.label,
    required this.width,
    this.alignment = Alignment.centerLeft,
    this.sortable = false,
    this.sortField,
  });
}
