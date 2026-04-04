import 'package:flutter/material.dart';

class BillingWorkbenchPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int visibleFrom;
  final int visibleTo;
  final int totalItems;
  final bool compact;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  const BillingWorkbenchPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.visibleFrom,
    required this.visibleTo,
    required this.totalItems,
    required this.compact,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pageInfo = Text(
      totalItems == 0
          ? 'Sin registros cargados'
          : 'Mostrando $visibleFrom-$visibleTo de $totalItems',
      style: theme.textTheme.bodySmall,
    );

    final navButtons = Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: currentPage > 1 ? onPreviousPage : null,
          icon: const Icon(Icons.chevron_left),
          label: const Text('Anterior'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            'Página $currentPage / $totalPages',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: currentPage < totalPages ? onNextPage : null,
          icon: const Icon(Icons.chevron_right),
          label: const Text('Siguiente'),
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [pageInfo, const SizedBox(height: 12), navButtons],
      );
    }

    return Row(
      children: [
        Expanded(child: pageInfo),
        navButtons,
      ],
    );
  }
}
