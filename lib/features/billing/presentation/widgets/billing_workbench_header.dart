import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';

class BillingWorkbenchHeader extends StatelessWidget {
  final List<BillingWorkbenchColumn> columns;
  final double tableWidth;
  final String sortField;
  final bool sortAsc;
  final ValueChanged<BillingWorkbenchColumn>? onSortRequested;

  const BillingWorkbenchHeader({
    super.key,
    required this.columns,
    required this.tableWidth,
    required this.sortField,
    required this.sortAsc,
    this.onSortRequested,
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
                  child: _HeaderCell(
                    column: column,
                    sortField: sortField,
                    sortAsc: sortAsc,
                    onSortRequested: onSortRequested,
                    textStyle: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
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

class _HeaderCell extends StatelessWidget {
  final BillingWorkbenchColumn column;
  final String sortField;
  final bool sortAsc;
  final ValueChanged<BillingWorkbenchColumn>? onSortRequested;
  final TextStyle? textStyle;

  const _HeaderCell({
    required this.column,
    required this.sortField,
    required this.sortAsc,
    required this.onSortRequested,
    required this.textStyle,
  });

  bool get _isActiveSort =>
      column.sortable &&
      column.sortField != null &&
      column.sortField == sortField;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(
      column.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );

    if (!column.sortable || column.sortField == null) {
      return Align(
        alignment: column.alignment,
        child: label,
      );
    }

    final Color activeColor = Theme.of(context).colorScheme.primary;
    final IconData iconData = _isActiveSort
        ? (sortAsc ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)
        : Icons.unfold_more_rounded;

    final Color? iconColor = _isActiveSort ? activeColor : Colors.grey.shade500;

    return Align(
      alignment: column.alignment,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onSortRequested?.call(column),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: label),
              const SizedBox(width: 6),
              Icon(
                iconData,
                size: 16,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
