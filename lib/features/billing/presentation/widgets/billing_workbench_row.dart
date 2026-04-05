import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';

class BillingWorkbenchRow extends StatefulWidget {
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

  @override
  State<BillingWorkbenchRow> createState() => _BillingWorkbenchRowState();
}

class _BillingWorkbenchRowState extends State<BillingWorkbenchRow> {
  bool _hovered = false;

  String _resolveValue(String key) {
    switch (key) {
      case 'NroCpbte':
        return widget.item[key].toString().padLeft(9, '0');
      default:
        return widget.item[key]?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color baseColor =
        widget.alternate ? Colors.grey.shade50 : Colors.white;
    final Color hoverColor = theme.colorScheme.primary.withValues(alpha: 0.05);

    return SizedBox(
      width: widget.tableWidth,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? hoverColor : baseColor,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: widget.columns.map((column) {
              if (column.key == 'download') {
                return SizedBox(
                  width: column.width,
                  child: Align(
                    alignment: column.alignment,
                    child: Material(
                      color: Colors.transparent,
                      child: InkResponse(
                        radius: 20,
                        onTap: widget.onDownload,
                        child: Tooltip(
                          message: 'Descargar comprobante',
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _hovered
                                  ? theme.colorScheme.primary
                                      .withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.download_outlined,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: column.key == 'ImporteTotalConImpuestos'
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ),
      ),
    );
  }
}
