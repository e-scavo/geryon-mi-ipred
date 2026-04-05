import 'package:flutter/material.dart';

class BillingWorkbenchSummary extends StatelessWidget {
  final String collectionLabel;
  final int totalItems;
  final int visibleFrom;
  final int visibleTo;
  final int currentPage;
  final int totalPages;
  final bool compact;
  final String searchText;

  const BillingWorkbenchSummary({
    super.key,
    required this.collectionLabel,
    required this.totalItems,
    required this.visibleFrom,
    required this.visibleTo,
    required this.currentPage,
    required this.totalPages,
    required this.compact,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[
      _SummaryTile(
        icon: Icons.view_week_outlined,
        label: 'Rango visible',
        value: totalItems == 0
            ? '0 de 0'
            : '$visibleFrom-$visibleTo de $totalItems',
      ),
      _SummaryTile(
        icon: Icons.layers_outlined,
        label: 'Página',
        value: '$currentPage de $totalPages',
      ),
      _SummaryTile(
        icon: Icons.receipt_long_outlined,
        label: 'Total',
        value: '$totalItems $collectionLabel',
      ),
    ];

    final normalizedSearch = searchText.trim();
    if (normalizedSearch.isNotEmpty) {
      items.add(
        _SummaryTile(
          icon: Icons.search,
          label: 'Búsqueda',
          value: normalizedSearch,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key == items.length - 1 ? 0 : 10,
                      ),
                      child: entry.value,
                    ),
                  )
                  .toList(growable: false),
            )
          : Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items
                  .map(
                    (item) => SizedBox(
                      width: 184,
                      child: item,
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
