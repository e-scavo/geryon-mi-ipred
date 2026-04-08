import 'package:flutter/material.dart';

class BillingWorkbenchToolbar extends StatefulWidget {
  final String collectionLabel;
  final int totalItems;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final bool compact;
  final String searchText;
  final bool isRefreshing;
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
    required this.isRefreshing,
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
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${widget.totalItems} ${widget.collectionLabel}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (widget.searchText.trim().isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Búsqueda: "${widget.searchText.trim()}"',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (widget.isRefreshing)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Actualizando',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );

    final searchField = SizedBox(
      width: widget.compact ? double.infinity : 280,
      child: TextField(
        controller: _searchController,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _submitSearch(),
        decoration: InputDecoration(
          hintText: 'Buscar por Nº de comprobante',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.trim().isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpiar búsqueda',
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close),
                ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );

    final controls = Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        searchField,
        FilledButton.icon(
          onPressed: widget.isRefreshing ? null : _submitSearch,
          icon: const Icon(Icons.search),
          label: const Text('Buscar'),
        ),
        if (widget.searchText.trim().isNotEmpty)
          OutlinedButton.icon(
            onPressed: widget.isRefreshing ? null : _clearSearch,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Limpiar'),
          ),
        Tooltip(
          message: 'Cantidad de filas visibles por página',
          child: DropdownButtonHideUnderline(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<int>(
                  value: widget.rowsPerPage,
                  borderRadius: BorderRadius.circular(12),
                  items: widget.availableRowsPerPage
                      .map(
                        (value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value filas'),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: widget.isRefreshing
                      ? null
                      : (value) {
                          if (value != null) {
                            widget.onRowsPerPageChanged(value);
                          }
                        },
                ),
              ),
            ),
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Actualizar listado',
          onPressed: widget.isRefreshing ? null : widget.onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: widget.compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoBlock,
                const SizedBox(height: 12),
                controls,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: infoBlock),
                const SizedBox(width: 16),
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: controls,
                  ),
                ),
              ],
            ),
    );
  }
}
