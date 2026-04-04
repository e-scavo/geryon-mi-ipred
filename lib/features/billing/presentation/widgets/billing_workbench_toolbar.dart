import 'package:flutter/material.dart';

class BillingWorkbenchToolbar extends StatelessWidget {
  final String collectionLabel;
  final int totalItems;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final bool compact;
  final VoidCallback? onRefresh;
  final ValueChanged<int> onRowsPerPageChanged;

  const BillingWorkbenchToolbar({
    super.key,
    required this.collectionLabel,
    required this.totalItems,
    required this.rowsPerPage,
    required this.availableRowsPerPage,
    required this.compact,
    required this.onRowsPerPageChanged,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final infoBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$totalItems registros disponibles',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
          ),
        ),
      ],
    );

    final rowsPerPageOptions = <int>{
      ...availableRowsPerPage,
      rowsPerPage,
    }.toList()
      ..sort();

    final controls = Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            '$totalItems $collectionLabel',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filas',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: rowsPerPage,
                borderRadius: BorderRadius.circular(12),
                items: rowsPerPageOptions
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  onRowsPerPageChanged(value);
                },
              ),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Actualizar'),
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoBlock,
          const SizedBox(height: 12),
          controls,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: infoBlock),
        const SizedBox(width: 16),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: controls,
          ),
        ),
      ],
    );
  }
}
