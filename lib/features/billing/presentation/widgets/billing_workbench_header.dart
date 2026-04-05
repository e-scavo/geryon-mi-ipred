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
    return SizedBox(
      width: tableWidth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatefulWidget {
  final BillingWorkbenchColumn column;
  final String sortField;
  final bool sortAsc;
  final ValueChanged<BillingWorkbenchColumn>? onSortRequested;

  const _HeaderCell({
    required this.column,
    required this.sortField,
    required this.sortAsc,
    required this.onSortRequested,
  });

  @override
  State<_HeaderCell> createState() => _HeaderCellState();
}

class _HeaderCellState extends State<_HeaderCell> {
  bool _hovered = false;

  bool get _isActiveSort =>
      widget.column.sortable &&
      widget.column.sortField != null &&
      widget.column.sortField == widget.sortField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool interactive =
        widget.column.sortable && widget.column.sortField != null;
    final Color foregroundColor = _isActiveSort
        ? theme.colorScheme.primary
        : (_hovered && interactive
            ? theme.colorScheme.primary.withValues(alpha: 0.90)
            : (theme.textTheme.labelLarge?.color ?? Colors.black87));
    final FontWeight weight = _isActiveSort ? FontWeight.w800 : FontWeight.w700;

    final Widget label = Text(
      widget.column.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: weight,
        color: foregroundColor,
      ),
    );

    if (!interactive) {
      return Align(
        alignment: widget.column.alignment,
        child: label,
      );
    }

    final IconData indicator = _isActiveSort
        ? (widget.sortAsc ? Icons.arrow_upward : Icons.arrow_downward)
        : Icons.unfold_more;

    return Align(
      alignment: widget.column.alignment,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => widget.onSortRequested?.call(widget.column),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _isActiveSort
                    ? theme.colorScheme.primary.withValues(alpha: 0.10)
                    : (_hovered
                        ? theme.colorScheme.primary.withValues(alpha: 0.06)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: label),
                  const SizedBox(width: 6),
                  Icon(
                    indicator,
                    size: 16,
                    color: _isActiveSort
                        ? theme.colorScheme.primary
                        : foregroundColor.withValues(alpha: 0.78),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
