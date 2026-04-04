import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';

class BillingWorkbenchRow extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<BillingWorkbenchColumn> columns;
  final VoidCallback onDownload;
  final double tableWidth;
  final bool alternate;

  const BillingWorkbenchRow({
    super.key,
    required this.item,
    required this.columns,
    required this.onDownload,
    required this.tableWidth,
    required this.alternate,
  });

  String _resolveValue(String key) {
    switch (key) {
      case 'NroCpbte':
        return item[key].toString().padLeft(9, '0');
      default:
        return item[key]?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: tableWidth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: alternate ? Colors.grey.shade50 : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: columns.map((column) {
            if (column.key == 'download') {
              return SizedBox(
                width: column.width,
                child: Align(
                  alignment: column.alignment,
                  child: IconButton(
                    tooltip: 'Descargar comprobante',
                    onPressed: onDownload,
                    icon: const Icon(Icons.download_outlined),
                  ),
                ),
              );
            }

            return SizedBox(
              width: column.width,
              child: Align(
                alignment: column.alignment,
                child: Text(
                  _resolveValue(column.key),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}
