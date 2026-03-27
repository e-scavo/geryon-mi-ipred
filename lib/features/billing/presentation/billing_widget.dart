import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/features/billing/controllers/billing_controller.dart';
import 'package:geryon_web_app_ws_v2/models/LoadingGeneric/widget.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/SimpleTableWithScroll/widget.dart';
import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/pages/CatchMainScreen/widget.dart';
import 'package:geryon_web_app_ws_v2/shared/window/window_model.dart';
import 'package:geryon_web_app_ws_v2/shared/window/window_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _billingState = _controller.buildInitialState();
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

  Future<void> _reloadBillingData() async {
    const String functionName = 'BillingWidget._reloadBillingData';
    final String logFunctionName = '.::$functionName::.';
    final currentClientIndex = _controller.resolveCurrentClientIndex(ref: ref);

    if (mounted) {
      setState(() {
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
          final currentClientIndex = next.loggedUser?.cCliente;

          if (debug) {
            developer.log(
              '🚀 _initWork: trackedClientIndex: ${_billingState.trackedClientIndex}',
              name: '$mainFunc - $listenerLogFunctionName',
            );
          }

          if (_controller.shouldReloadForClientChange(
            state: _billingState,
            currentClientIndex: currentClientIndex,
          )) {
            developer.log(
              '🟢 _initWork: Cliente cambió de ${_billingState.trackedClientIndex} a $currentClientIndex',
              name: '$mainFunc - $listenerLogFunctionName',
            );

            unawaited(_reloadBillingData());
          }
        },
      );

      final currentClientIndex =
          _controller.resolveCurrentClientIndex(ref: ref);

      if (_controller.shouldBootstrap(
        state: _billingState,
        currentClientIndex: currentClientIndex,
      )) {
        developer.log(
          '🟢 _initWork: Primer cliente detectado: $currentClientIndex',
          name: '$mainFunc - $logFunctionName',
        );

        unawaited(_reloadBillingData());
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

  @override
  Widget build(BuildContext context) {
    String functionName = 'BillingWidget.build';
    String locFunc = '.::$functionName::.';

    Widget buildWindowHeader() {
      return Placeholder(
        fallbackHeight: 50,
        child: Text('Header for ${widget.pType}'),
      );
    }

    Widget buildWindowBody({
      required BoxConstraints constraints,
    }) {
      if (_billingState.hasError) {
        constraints = BoxConstraints(
          maxHeight: constraints.maxHeight - 32,
          maxWidth: constraints.maxWidth,
        );

        return CatchMainScreen(
          locFunc: locFunc,
          constraints: constraints,
          e: _billingState.error?.errorDsc ?? 'Error desconocido',
          stacktrace: _billingState.error?.stacktrace ?? StackTrace.current,
          debug: true,
          pScreenMaxHeight: constraints.maxHeight - 32,
          pScreenMaxWidth: constraints.maxWidth,
          showTitleBar: false,
          showClosebutton: false,
          showStacktrace: false,
        );
      }

      final List<Map<String, dynamic>> comprobantes = _billingState.isReady
          ? _controller.buildTableRows(
              dataModel: _billingState.dataModel!,
            )
          : const <Map<String, dynamic>>[];

      return _billingState.isLoading
          ? LoadingGeneric()
          : SizedBox(
              child: SimpleTableWithScrollLimit(
                data: comprobantes,
                constraints: constraints,
              ),
            );
    }

    developer.log(
      'BillingWidget.build: widget.pType: ${widget.pType}, locFunc: $locFunc',
      name: '$mainFunc - $locFunc',
    );

    String wTitle = 'Comprobantes';
    Color? wColor;

    switch (widget.pType) {
      case "FacturasVT":
        wTitle = 'FACTURAS';
        wColor = Colors.redAccent;
        break;
      case "RecibosVT":
        wTitle = 'RECIBOS';
        wColor = Colors.greenAccent.shade700;
        break;
      case "DebitosVT":
        wTitle = 'NOTAS DE DÉBITO';
        wColor = Colors.redAccent.shade400;
        break;
      case "CreditosVT":
        wTitle = 'NOTAS DE CRÉDITO';
        wColor = Colors.blueAccent.shade400;
      default:
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double windowWidth = constraints.maxWidth;
        double windowHeight = constraints.maxHeight;

        developer.log(
          '$mainFunc - $locFunc - windowWidth:$windowWidth - windowHeight:$windowHeight',
          name: 'BillingWidget',
        );

        try {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            width: windowWidth,
            height: windowHeight,
            constraints: constraints,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WindowWidget(
                    windowModel: WindowModel(
                      title: wTitle,
                      titleColorBackground: wColor ?? Colors.black45,
                      constraints: constraints,
                      headerWidget: buildWindowHeader(),
                      bodyWidget: buildWindowBody(
                        constraints: constraints,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } catch (e, stacktrace) {
          return CatchMainScreen(
            locFunc: locFunc,
            constraints: constraints,
            e: e,
            stacktrace: stacktrace,
            debug: true,
            pScreenMaxHeight: constraints.maxHeight,
            pScreenMaxWidth: constraints.maxWidth,
          );
        }
      },
    );
  }
}
