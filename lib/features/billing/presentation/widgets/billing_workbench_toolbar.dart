import 'package:flutter/material.dart';

class BillingWorkbenchToolbar extends StatefulWidget {
  final String collectionLabel;
  final int totalItems;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final bool compact;
  final String searchText;
  final VoidCallback? onRefresh;
  final ValueChanged<int> onRowsPerPageChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onClearSearch;

  const BillingWorkbenchToolbar({
    super.key,
    required this.collectionLabel,
    required this.totalItems,
    required this.rowsPerPage,
    required this.availableRowsPerPage,
    required this.compact,
    required this.searchText,
    required this.onRowsPerPageChanged,
    this.onRefresh,
    this.onSearchSubmitted,
    this.onClearSearch,
  });

  @override
  State<BillingWorkbenchToolbar> createState() =>
      _BillingWorkbenchToolbarState();
}

class _BillingWorkbenchToolbarState extends State<BillingWorkbenchToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchText);
  }

  @override
  void didUpdateWidget(covariant BillingWorkbenchToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchText != widget.searchText &&
        _searchController.text != widget.searchText) {
      _searchController.value = TextEditingValue(
        text: widget.searchText,
        selection: TextSelection.collapsed(offset: widget.searchText.length),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    widget.onSearchSubmitted?.call(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final infoBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.totalItems} registros disponibles',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
          ),
        ),
        if (widget.searchText.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Búsqueda activa: "${widget.searchText.trim()}"',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    final rowsPerPageOptions = <int>{
      ...widget.availableRowsPerPage,
      widget.rowsPerPage,
    }.toList()
      ..sort();

    final Widget searchField = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.compact ? 220 : 260,
        maxWidth: widget.compact ? 360 : 420,
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _submitSearch(),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Buscar comprobante',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.trim().isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpiar búsqueda',
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close_rounded),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );

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
            '${widget.totalItems} ${widget.collectionLabel}',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        searchField,
        FilledButton.icon(
          onPressed: _submitSearch,
          icon: const Icon(Icons.search),
          label: const Text('Buscar'),
        ),
        if (widget.searchText.trim().isNotEmpty)
          OutlinedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Limpiar'),
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
                value: widget.rowsPerPage,
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
                  widget.onRowsPerPageChanged(value);
                },
              ),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: widget.onRefresh,
          icon: const Icon(Icons.refresh),
          label: const Text('Actualizar'),
        ),
      ],
    );

    if (widget.compact) {
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
