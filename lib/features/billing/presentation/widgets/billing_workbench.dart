import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_page_state.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/overlays/billing_document_download_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_pagination.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_summary.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_table.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_toolbar.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDownloadLocally/model.dart';

class BillingWorkbench extends StatelessWidget {
  final BoxConstraints constraints;
  final List<Map<String, dynamic>> data;
  final String collectionLabel;
  final int currentPage;
  final int rowsPerPage;
  final int totalItems;
  final String sortField;
  final bool sortAsc;
  final String searchText;
  final VoidCallback? onRefresh;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onRowsPerPageChanged;
  final void Function(String sortField, bool sortAsc)? onSortChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onClearSearch;
  final bool isRefreshing;

  const BillingWorkbench({
    super.key,
    required this.constraints,
    required this.data,
    required this.collectionLabel,
    required this.currentPage,
    required this.rowsPerPage,
    required this.totalItems,
    required this.sortField,
    required this.sortAsc,
    required this.searchText,
    this.onRefresh,
    this.onPageChanged,
    this.onRowsPerPageChanged,
    this.onSortChanged,
    this.onSearchSubmitted,
    this.onClearSearch,
    this.isRefreshing = false,
  });

  static const List<int> availableRowsPerPage = <int>[10, 20, 50];

  List<BillingWorkbenchColumn> get _columns => const [
        BillingWorkbenchColumn(
          key: 'NroCpbte',
          label: 'Nº de comprobante',
          width: 220,
          sortable: true,
          sortField: 'NroCpbte',
        ),
        BillingWorkbenchColumn(
          key: 'FechaCpbte',
          label: 'Fecha',
          width: 180,
          sortable: true,
          sortField: 'FechaCpbte',
        ),
        BillingWorkbenchColumn(
          key: 'ImporteTotalConImpuestos',
          label: 'Monto',
          width: 200,
          alignment: Alignment.centerRight,
          sortable: true,
          sortField: 'ImporteTotalConImpuestos',
        ),
        BillingWorkbenchColumn(
          key: 'download',
          label: 'Acción',
          width: 110,
          alignment: Alignment.center,
        ),
      ];

  bool get _isCompact => constraints.maxWidth < 860;

  double get _minTableWidth =>
      _columns.fold<double>(0, (sum, column) => sum + column.width) + 32;

  double _resolveEffectiveTableWidth() {
    final double availableWidth = constraints.hasBoundedWidth
        ? math.max(0, constraints.maxWidth)
        : _minTableWidth;

    return math.max(_minTableWidth, availableWidth);
  }

  BillingWorkbenchPageState get _pageState => BillingWorkbenchPageState(
        currentPage: currentPage,
        rowsPerPage: rowsPerPage,
        totalItems: totalItems,
      );

  int _asInt(dynamic value, {int fallback = -1}) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  Future<void> _downloadVoucher(Map<String, dynamic> item) async {
    developer.log(
      'Descargando comprobante: ${item['ClaseCpbte']} - ${item['CodEmp']} - ${item['NroCpbte']}',
      name: 'BillingWorkbench._downloadVoucher',
    );

    final CommonDownloadLocallyModel voucher =
        CommonDownloadLocallyModel.fromClaseCpbte(
      pModulo: 'Ventas',
      pClaseCpbte: item['ClaseCpbte']?.toString() ?? 'Unknown',
      pCodEmp: _asInt(item['CodEmp']),
      pNroCpbte: _asInt(item['NroCpbte']),
    )
          ..claseCpbte = item['ClaseCpbte']
          ..codEmp = _asInt(item['CodEmp'])
          ..nroCpbte = _asInt(item['NroCpbte'])
          ..tipoCliente = item['TipoCliente']?.toString() ?? 'Unknown'
          ..codClie = _asInt(item['CodClie'])
          ..razonSocial = item['RazonSocial'];

    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.push(
          ScreenPoPUpCommonDownloadLocallyScreen<CommonDownloadLocallyModel>(
        pGlobalRequest: ConstRequests.viewRequest,
        pActionRequest: ConstRequests.viewRequest,
        pLocalActionRequest: ConstRequests.downloadRequest,
        pParams: <CommonDownloadLocallyModel>[voucher],
        autoStart: true,
      ));
    }

    developer.log(
      'Comprobante descargado: ${item['ClaseCpbte']} - ${item['CodEmp']} - ${item['NroCpbte']}',
      name: 'BillingWorkbench._downloadVoucher',
    );
  }

  void _handleSortRequested(BillingWorkbenchColumn column) {
    if (!column.sortable || column.sortField == null) {
      return;
    }

    final bool nextSortAsc = sortField == column.sortField ? !sortAsc : true;

    onSortChanged?.call(column.sortField!, nextSortAsc);
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveTableWidth = _resolveEffectiveTableWidth();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BillingWorkbenchToolbar(
          collectionLabel: collectionLabel,
          totalItems: totalItems,
          rowsPerPage: rowsPerPage,
          availableRowsPerPage: availableRowsPerPage,
          compact: _isCompact,
          searchText: searchText,
          isRefreshing: isRefreshing,
          onRefresh: onRefresh,
          onRowsPerPageChanged: (value) {
            onRowsPerPageChanged?.call(value);
          },
          onSearchSubmitted: onSearchSubmitted,
          onClearSearch: onClearSearch,
        ),
        const SizedBox(height: 12),
        BillingWorkbenchSummary(
          collectionLabel: collectionLabel,
          totalItems: totalItems,
          visibleFrom: _pageState.visibleFrom,
          visibleTo: _pageState.visibleTo,
          currentPage: _pageState.safeCurrentPage,
          totalPages: _pageState.totalPages,
          compact: _isCompact,
          searchText: searchText,
        ),
        const SizedBox(height: 12),
        BillingWorkbenchTable(
          rows: data,
          columns: _columns,
          tableWidth: effectiveTableWidth,
          sortField: sortField,
          sortAsc: sortAsc,
          onSortRequested: _handleSortRequested,
          onDownload: (item) {
            _downloadVoucher(item);
          },
          isRefreshing: isRefreshing,
        ),
        const SizedBox(height: 12),
        BillingWorkbenchPagination(
          currentPage: _pageState.safeCurrentPage,
          totalPages: _pageState.totalPages,
          visibleFrom: _pageState.visibleFrom,
          visibleTo: _pageState.visibleTo,
          totalItems: totalItems,
          compact: _isCompact,
          onPreviousPage: () {
            if (_pageState.safeCurrentPage <= 1) {
              return;
            }
            onPageChanged?.call(_pageState.safeCurrentPage - 1);
          },
          onNextPage: () {
            if (_pageState.safeCurrentPage >= _pageState.totalPages) {
              return;
            }
            onPageChanged?.call(_pageState.safeCurrentPage + 1);
          },
        ),
      ],
    );
  }
}
