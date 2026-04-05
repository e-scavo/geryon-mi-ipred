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
    final theme = Theme.of(context);

    final List<Widget> items = <Widget>[
      _SummaryTile(
        label: 'Rango visible',
        value: totalItems == 0
            ? '0 de 0'
            : '$visibleFrom-$visibleTo de $totalItems',
      ),
      _SummaryTile(
        label: 'Página',
        value: '$currentPage de $totalPages',
      ),
      _SummaryTile(
        label: 'Total',
        value: '$totalItems $collectionLabel',
      ),
    ];

    final normalizedSearch = searchText.trim();
    if (normalizedSearch.isNotEmpty) {
      items.add(
        _SummaryTile(
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
                        bottom: entry.key == items.length - 1 ? 0 : 12,
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
                      width: 180,
                      child: item,
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
