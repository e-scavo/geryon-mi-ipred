import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';

class BillingWorkbenchHeader extends StatelessWidget {
  final List<BillingWorkbenchColumn> columns;
  final double tableWidth;

  const BillingWorkbenchHeader({
    super.key,
    required this.columns,
    required this.tableWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: tableWidth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: columns
              .map(
                (column) => SizedBox(
                  width: column.width,
                  child: Align(
                    alignment: column.alignment,
                    child: Text(
                      column.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
