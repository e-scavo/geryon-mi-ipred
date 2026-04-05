import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/features/billing/controllers/billing_controller.dart';
import 'package:geryon_web_app_ws_v2/features/contracts/application_coordinator.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/loading_generic.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/error_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/system_error_surface.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_empty_state.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_error_state.dart';

class BillingWidget extends ConsumerStatefulWidget {
  final BoxConstraints constraints;
  final String pType;

  const BillingWidget({
    required this.pType,
    required this.constraints,
    super.key,
  });

  @override
  ConsumerState<BillingWidget> createState() => _BillingWidgetState();
}

class _BillingWidgetState extends ConsumerState<BillingWidget> {
  final String mainFunc = 'BillingWidget';
  final bool debug = true;
  final BillingController _controller = BillingController();

  late final ScrollController mainScroller;
  late final ScrollController mainCatchScroller;
  late final ScrollController secondScroller;
  late final ScrollController secondCatchScroller;

  final ConstRequests pGlobalRequest = ConstRequests.viewRecord;
  final ConstRequests pLocalRequest = ConstRequests.viewRecord;

  late BillingFeatureState _billingState;
  ProviderSubscription<ServiceProvider>? _subscription;
  late int _rowsPerPage;
  int _currentPage = 1;
  String _sortField = 'FechaCpbte';
  bool _sortAsc = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _billingState = _controller.buildInitialState();
    _rowsPerPage = _resolveDefaultRowsPerPage();
    mainScroller = ScrollController();
    mainCatchScroller = ScrollController();
    secondScroller = ScrollController();
    secondCatchScroller = ScrollController();
    _initWork();
  }

  @override
  void dispose() {
    mainScroller.dispose();
    mainCatchScroller.dispose();
    secondScroller.dispose();
    secondCatchScroller.dispose();
    _subscription?.close();
    super.dispose();
  }

  int _resolveDefaultRowsPerPage() {
    return widget.constraints.maxWidth >= 1100 ? 20 : 10;
  }

  Future<void> _reloadBillingData({
    int? page,
    int? rowsPerPage,
    String? sortField,
    bool? sortAsc,
    String? searchText,
  }) async {
    const String functionName = 'BillingWidget._reloadBillingData';
    final String logFunctionName = '.::$functionName::.';
    final currentClientIndex = _controller.resolveCurrentClientIndex(ref: ref);
    final int nextPage = page ?? _currentPage;
    final int nextRowsPerPage = rowsPerPage ?? _rowsPerPage;
    final String nextSortField = sortField ?? _sortField;
    final bool nextSortAsc = sortAsc ?? _sortAsc;
    final String nextSearchText = searchText ?? _searchText;

    if (mounted) {
      setState(() {
        _currentPage = nextPage;
        _rowsPerPage = nextRowsPerPage;
        _sortField = nextSortField;
        _sortAsc = nextSortAsc;
        _searchText = nextSearchText;
        _billingState = _controller.buildLoadingState(
          currentState: _billingState,
          trackedClientIndex: currentClientIndex,
        );
      });
    }

    final nextState = await _controller.reloadBillingState(
      ref: ref,
      currentState: _billingState,
      billingType: widget.pType,
      globalRequest: pGlobalRequest,
      localRequest: pLocalRequest,
      debug: debug,
      currentPage: _currentPage,
      rowsPerPage: _rowsPerPage,
      sortField: _sortField,
      sortAsc: _sortAsc,
      searchText: _searchText,
    );

    if (!mounted) {
      return;
    }

    if (nextState.hasError) {
      developer.log(
        'Error al cargar billing: ${nextState.error?.errorDsc}',
        name: '$mainFunc - $logFunctionName',
      );
      setState(() {
        _billingState = nextState;
      });
      return;
    }

    final int totalItems = nextState.isReady && nextState.dataModel != null
        ? _controller.resolveTotalItems(dataModel: nextState.dataModel!)
        : 0;
    final int totalPages =
        totalItems <= 0 ? 1 : ((totalItems + _rowsPerPage - 1) ~/ _rowsPerPage);

    if (totalItems > 0 && _currentPage > totalPages) {
      setState(() {
        _currentPage = totalPages;
      });
      await _reloadBillingData(
        page: totalPages,
        rowsPerPage: _rowsPerPage,
      );
      return;
    }

    setState(() {
      _billingState = nextState;
    });

    developer.log(
      'Datos de billing cargados correctamente.',
      name: '$mainFunc - $logFunctionName',
    );
  }

  void _initWork() async {
    String functionName = 'BillingWidget._initWork';
    String logFunctionName = '.::$functionName::.';

    try {
      developer.log(
        'Iniciando trabajo en billing',
        name: '$mainFunc - $logFunctionName',
      );

      _subscription = ref.listenManual<ServiceProvider>(
        notifierServiceProvider,
        (previous, next) {
          final String locFunctionName = 'listenManual';
          final String listenerLogFunctionName =
              '.::$functionName=>::$locFunctionName::.';
          final currentClientIndex = next.activeClientIndex;

          if (debug) {
            developer.log(
              '🚀 _initWork: trackedClientIndex: ${_billingState.trackedClientIndex}',
              name: '$mainFunc - $listenerLogFunctionName',
            );
          }

          if (ApplicationCoordinator.shouldReloadBillingForActiveClientChange(
            state: _billingState,
            currentClientIndex: currentClientIndex,
          )) {
            developer.log(
              '🟢 _initWork: Cliente cambió de ${_billingState.trackedClientIndex} a $currentClientIndex',
              name: '$mainFunc - $listenerLogFunctionName',
            );

            _currentPage = 1;
            unawaited(_reloadBillingData(
              page: 1,
              rowsPerPage: _rowsPerPage,
            ));
          }
        },
      );

      final currentClientIndex =
          _controller.resolveCurrentClientIndex(ref: ref);

      if (ApplicationCoordinator.shouldBootstrapBilling(
        state: _billingState,
        currentClientIndex: currentClientIndex,
      )) {
        developer.log(
          '🟢 _initWork: Primer cliente detectado: $currentClientIndex',
          name: '$mainFunc - $logFunctionName',
        );

        unawaited(_reloadBillingData(
          page: _currentPage,
          rowsPerPage: _rowsPerPage,
        ));
      }
    } catch (e, stacktrace) {
      if (mounted) {
        developer.log('$mainFunc - $functionName - CATCHED - $e - $stacktrace');

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Navigator.of(context).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: ErrorHandler(
                errorCode: 99999,
                errorDsc:
                    '''Se produjo un error al inicializar el procedimiento.
Error: ${e.toString()}
''',
                className: mainFunc,
                functionName: functionName,
                stacktrace: stacktrace,
              ),
            ),
          );

          if (!mounted) {
            return;
          }

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  void _requestBillingReload() {
    unawaited(_reloadBillingData(
      page: _currentPage,
      rowsPerPage: _rowsPerPage,
    ));
  }

  void _requestBillingPageChange(int nextPage) {
    if (nextPage == _currentPage) {
      return;
    }

    unawaited(_reloadBillingData(
      page: nextPage,
      rowsPerPage: _rowsPerPage,
    ));
  }

  void _requestBillingRowsPerPageChange(int nextRowsPerPage) {
    if (nextRowsPerPage == _rowsPerPage) {
      return;
    }

    unawaited(_reloadBillingData(
      page: 1,
      rowsPerPage: nextRowsPerPage,
    ));
  }

  void _requestBillingSortChange(String nextSortField, bool nextSortAsc) {
    if (nextSortField == _sortField && nextSortAsc == _sortAsc) {
      return;
    }

    unawaited(_reloadBillingData(
      page: 1,
      rowsPerPage: _rowsPerPage,
      sortField: nextSortField,
      sortAsc: nextSortAsc,
    ));
  }

  void _requestBillingSearchSubmit(String value) {
    final String normalizedSearch = value.trim();
    if (normalizedSearch == _searchText) {
      return;
    }

    unawaited(_reloadBillingData(
      page: 1,
      rowsPerPage: _rowsPerPage,
      searchText: normalizedSearch,
    ));
  }

  void _requestBillingClearSearch() {
    if (_searchText.isEmpty) {
      return;
    }

    unawaited(_reloadBillingData(
      page: 1,
      rowsPerPage: _rowsPerPage,
      searchText: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    String functionName = 'BillingWidget.build';
    String locFunc = '.::$functionName::.';
    final theme = Theme.of(context);

    Widget buildWindowHeader() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _controller.resolveBillingHeaderTitle(
                billingType: widget.pType,
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _controller.resolveBillingHeaderSubtitle(
                billingType: widget.pType,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.78,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildWindowBody({
      required BoxConstraints constraints,
    }) {
      if (_billingState.isLoading) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: LoadingGeneric(
            loadingText: _controller.resolveBillingLoadingText(
              billingType: widget.pType,
            ),
          ),
        );
      }

      if (_billingState.hasError) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: FeatureErrorState(
            title: _controller.resolveBillingErrorTitle(
              billingType: widget.pType,
              state: _billingState,
            ),
            message: _controller.resolveBillingErrorMessage(
              billingType: widget.pType,
              state: _billingState,
            ),
            retryLabel: 'Volver a intentar',
            onRetry: _requestBillingReload,
          ),
        );
      }

      if (_controller.isEmptyState(state: _billingState)) {
        final bool hasActiveSearch = _controller.hasActiveSearch(
          searchText: _searchText,
        );

        return Padding(
          padding: const EdgeInsets.all(18),
          child: FeatureEmptyState(
            title: hasActiveSearch
                ? _controller.resolveBillingFilteredEmptyTitle(
                    billingType: widget.pType,
                    searchText: _searchText,
                  )
                : _controller.resolveBillingEmptyTitle(
                    billingType: widget.pType,
                  ),
            message: hasActiveSearch
                ? _controller.resolveBillingFilteredEmptyMessage(
                    billingType: widget.pType,
                    searchText: _searchText,
                  )
                : _controller.resolveBillingEmptyMessage(
                    billingType: widget.pType,
                  ),
            actionLabel:
                hasActiveSearch ? 'Limpiar búsqueda' : 'Actualizar listado',
            onAction: hasActiveSearch
                ? _requestBillingClearSearch
                : _requestBillingReload,
          ),
        );
      }

      final List<Map<String, dynamic>> comprobantes = _billingState.isReady
          ? _controller.buildTableRows(
              dataModel: _billingState.dataModel!,
            )
          : const <Map<String, dynamic>>[];
      final int totalItems =
          _billingState.isReady && _billingState.dataModel != null
              ? _controller.resolveTotalItems(
                  dataModel: _billingState.dataModel!,
                )
              : 0;

      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: BillingWorkbench(
          data: comprobantes,
          constraints: constraints,
          collectionLabel: _controller.resolveBillingCollectionLabel(
            billingType: widget.pType,
          ),
          currentPage: _currentPage,
          rowsPerPage: _rowsPerPage,
          totalItems: totalItems,
          sortField: _sortField,
          sortAsc: _sortAsc,
          searchText: _searchText,
          onRefresh: _requestBillingReload,
          onPageChanged: _requestBillingPageChange,
          onRowsPerPageChanged: _requestBillingRowsPerPageChange,
          onSortChanged: _requestBillingSortChange,
          onSearchSubmitted: _requestBillingSearchSubmit,
          onClearSearch: _requestBillingClearSearch,
        ),
      );
    }

    developer.log(
      'BillingWidget.build: widget.pType: ${widget.pType}, locFunc: $locFunc',
      name: '$mainFunc - $locFunc',
    );

    String wTitle = 'Comprobantes';

    switch (widget.pType) {
      case 'FacturasVT':
        wTitle = 'FACTURAS';
        break;
      case 'RecibosVT':
        wTitle = 'RECIBOS';
        break;
      case 'DebitosVT':
        wTitle = 'NOTAS DE DÉBITO';
        break;
      case 'CreditosVT':
        wTitle = 'NOTAS DE CRÉDITO';
        break;
      default:
    }

    final Color wColor = theme.colorScheme.primary;
    final double effectiveWidth = widget.constraints.hasBoundedWidth
        ? widget.constraints.maxWidth
        : MediaQuery.sizeOf(context).width;
    final BoxConstraints bodyConstraints = BoxConstraints(
      minWidth: 0,
      maxWidth: effectiveWidth,
    );

    try {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: wColor,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(8),
                  topEnd: Radius.circular(8),
                ),
              ),
              height: 30,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: wTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black26,
                    width: 1.0,
                  ),
                  left: BorderSide(
                    color: Colors.black26,
                    width: 1.0,
                  ),
                  right: BorderSide(
                    color: Colors.black26,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Colors.black26,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildWindowHeader(),
                  buildWindowBody(
                    constraints: bodyConstraints,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e, stacktrace) {
      return CatchMainScreen(
        locFunc: locFunc,
        constraints: bodyConstraints,
        e: e,
        stacktrace: stacktrace,
        debug: true,
        pScreenMaxHeight: 0,
        pScreenMaxWidth: effectiveWidth,
      );
    }
  }
}
