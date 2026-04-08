import 'package:flutter/material.dart';

class BillingWorkbenchPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int visibleFrom;
  final int visibleTo;
  final int totalItems;
  final bool compact;
  final bool isRefreshing;
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
    this.isRefreshing = false,
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

    final Widget progressChip = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isRefreshing
          ? Container(
              key: const ValueKey('pagination_refreshing'),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.blueGrey.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Actualizando página...',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(
              key: ValueKey('pagination_idle'),
            ),
    );

    final navButtons = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Tooltip(
          message: currentPage > 1
              ? 'Ir a la página anterior'
              : 'No hay página anterior',
          child: OutlinedButton.icon(
            onPressed: !isRefreshing && currentPage > 1 ? onPreviousPage : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Anterior'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            'Página $currentPage de $totalPages',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Tooltip(
          message: currentPage < totalPages
              ? 'Ir a la página siguiente'
              : 'No hay más páginas',
          child: OutlinedButton.icon(
            onPressed:
                !isRefreshing && currentPage < totalPages ? onNextPage : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Siguiente'),
          ),
        ),
      ],
    );

    final content = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pageInfo,
              if (isRefreshing) ...[
                const SizedBox(height: 10),
                progressChip,
              ],
              const SizedBox(height: 12),
              navButtons,
            ],
          )
        : Row(
            children: [
              Expanded(child: pageInfo),
              if (isRefreshing) ...[
                const SizedBox(width: 12),
                progressChip,
              ],
              const SizedBox(width: 12),
              navButtons,
            ],
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRefreshing
              ? Colors.blueGrey.withValues(alpha: 0.22)
              : Colors.grey.shade300,
        ),
      ),
      child: content,
    );
  }
}
