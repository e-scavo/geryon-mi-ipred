import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDownloadLocally/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/header_request.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/error_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ClientesV2/additionalparams.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/system_error_surface.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/app_overlay_panel.dart';

class CommonDownloadLocallyScreen<T extends CommonModel<T>>
    extends ConsumerStatefulWidget {
  final double pScreenMaxWidth;
  final double pScreenMaxHeight;
  final ConstRequests pGlobalRequest;
  final ConstRequests pActionRequest;
  final ConstRequests pLocalActionRequest;
  final List<CommonDownloadLocallyModel> pParams;
  final bool autoStart;
  const CommonDownloadLocallyScreen({
    required this.pGlobalRequest,
    required this.pActionRequest,
    required this.pLocalActionRequest,
    required this.pScreenMaxWidth,
    required this.pScreenMaxHeight,
    required this.pParams,
    this.autoStart = false,
    super.key,
  });

  @override
  ConsumerState<CommonDownloadLocallyScreen<T>> createState() =>
      _CommonDownloadLocallyScreenState<T>();
}

class _CommonDownloadLocallyScreenState<T extends CommonModel<T>>
    extends ConsumerState<CommonDownloadLocallyScreen<T>>
    with TickerProviderStateMixin {
  ///
  final String mainFunc = ".::_CommonDownloadLocallyScreenState::.";

  ///
  bool debug = false;
  String dThreadHashID = "";
  late bool _loading;
  late GenericDataModel<T> tEnteDataModel;

  ///////
  late final ScrollController mainScroller;
  late final ScrollController mainCatchScroller;
  late final ScrollController secondScroller;
  late final ScrollController secondCatchScroller;
  late ConstRequests globalRequest;
  late ConstRequests localRequest;
  late AnimationController _progressController;
  late String _progressText;
  late String _progressTextInfo;
  String _progressErrorTextInfo = "";
  late bool _showProgress;
  late bool _cancelProcess;
  bool isAuto = false;
  bool isProcessRunning = false;

  List<CommonDownloadLocallyModel> selectedItems = [];
  int totalRecords = 0;
  bool waitingFordata = false;
  bool mustRefresh = false;
  bool silenceMode = true;
  bool showOnlyFiltered = true;
  var periodoInstalaciones = CommonDateModel.fromNow();

  String windowTitleCaption = '.::Título no establecido::.';

  @override
  void initState() {
    super.initState();
    debug = ref.read(notifierServiceProvider).debug;
    _loading = true;
    mainScroller = ScrollController();
    mainCatchScroller = ScrollController();
    secondScroller = ScrollController();
    secondCatchScroller = ScrollController();
    globalRequest = widget.pGlobalRequest;
    localRequest = widget.pActionRequest;
    windowTitleCaption = _windowTitleForAction(widget.pLocalActionRequest);

    _progressController = AnimationController(vsync: this);

    _progressText = "";
    _progressTextInfo = "";
    _showProgress = false;
    _cancelProcess = false;

    _initWork();

    /// Register a callback to execute a function after the widget is built.
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_initWork();
    });
  }

  @override
  void dispose() {
    periodoInstalaciones.dispose();
    mainScroller.dispose();
    mainCatchScroller.dispose();
    secondScroller.dispose();
    secondCatchScroller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _initWork({
    bool autoStart = false,
  }) async {
    const String functionName = '_initWork';
    try {
      if (dThreadHashID.isEmpty) {
        dThreadHashID = generateRandomUniqueHash();
      }
      await ref.read(notifierServiceProvider).mapThreadsToDataModels.set(
            key: dThreadHashID,
            value: GenericDataModel<CommonDownloadLocallyModel>(
              wRef: ref,
              debug: debug,
            ),
          );
      if (!mounted) {
        return;
      }
      setState(() {
        _showProgress = false;
        _cancelProcess = false;
        _loading = true;
        tEnteDataModel = ref
            .read(notifierServiceProvider)
            .mapThreadsToDataModels
            .get(dThreadHashID);
        tEnteDataModel.pGlobalRequest = ConstRequests.viewRecord;
        tEnteDataModel.pLocalRequest = ConstRequests.viewRecord;
        tEnteDataModel.cEmpresa = ref.read(notifierServiceProvider).cEmpresa;
        tEnteDataModel.threadParams = {
          'SelectBy': '',
        };
        periodoInstalaciones = tEnteDataModel.pPeriodoInstalaciones;
        showOnlyFiltered = tEnteDataModel.showOnlyFiltered;
      });

      /// Si no se enviaron datos que procesar, no tiene sentido continuar
      /// Volvemos a la pantalla anterior
      ///
      if (widget.pParams.isEmpty) {
        await Navigator.of(context).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: ErrorHandler(
              errorCode: 878787,
              errorDsc: '''No hay datos por procesar.''',
            ),
          ),
        );
        if (!mounted) {
          return;
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        return;
      }
      if (debug) {
        developer.log(
          '$mainFunc - $functionName - Iniciando trabajo [${widget.pParams}]',
          name: 'CommonDownloadLocallyScreen',
        );
      }
      setState(() {
        windowTitleCaption = _windowTitleForAction(widget.pLocalActionRequest);
        totalRecords = widget.pParams.length;
        selectedItems = widget.pParams;
        String t = "comprobante";
        if (selectedItems.length > 1) t = "comprobantes";
        _progressTextInfo =
            'Hay ${selectedItems.length} $t de $totalRecords para procesar.';
        _loading = false;
        if (totalRecords == 0 || selectedItems.isEmpty) {
          mustRefresh = true;
          _progressTextInfo = 'NO HAY REGISTROS QUE PROCESAR';
        } else {
          mustRefresh = false;
        }
      });
      if (autoStart || widget.autoStart) {
        _doInitProcess();
      }
      return;
    } catch (e, stacktrace) {
      if (mounted) {
        if (debug) {
          developer.log(
            '$mainFunc - $functionName - CATCHED - $e - $stacktrace',
            name: 'CommonDownloadLocallyScreen',
          );
        }

        /// Register a callback to execute a function after the widget is built.
        ///
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Navigator.of(context).push(ModelGeneralPoPUpErrorMessageDialog(
              error: ErrorHandler(
            errorCode: 99999,
            errorDsc: '''Se produjo un error al inicializar el procedimiento.
              Error: ${e.toString()}
              ''',
            className: mainFunc,
            functionName: functionName,
            stacktrace: stacktrace,
          )));
          if (!mounted) {
            return;
          }
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          return;
        });
      }
    }
  }

  /// Process that initiate a loop to process all records retrieved from server
  /// which are pending of billing.
  /// [n] is the current record to be proccessed
  /// [of] is the total records retrieved from server
  ///
  runLoopProcess(int n, int of) async {
    double cPct = n.toDouble() / of.toDouble();
    if (n < of) {
      var record = selectedItems[n];
      setState(() {
        _progressController.value = cPct;
        _progressText = '${n + 1} de $of (procesando)';
        _progressTextInfo = 'Comprobante ';
        _progressTextInfo += 'Nº ${record.nroCpbte.toString().padLeft(6, '0')}';
        _progressTextInfo +=
            '\r\nCliente ${record.codClie.toString().padLeft(6, '0')} - ${record.razonSocial}';
        _showProgress = true;
        _cancelProcess = false;
      });
      String defaultTable = 'tbl_SharedDataTypes';
      String table = defaultTable;
      String actionRequest = '';
      switch (widget.pLocalActionRequest) {
        case ConstRequests.downloadRequest:
          switch (record.claseCpbte) {
            case "PedidosVT":
              table = 'tbl_ComprobantesPedidosVT';
              actionRequest = 'GenerateAndDownloadPDFFromVoucher';
              break;
            case "FacturasVT":
            case "RecibosVT":
            case "DebitosVT":
            case "CreditosVT":
              table = 'tbl_ComprobantesVT';
              actionRequest = 'GenerateAndDownloadPDFFromVoucher';
              break;
            default:
          }
          break;
        case ConstRequests.sendEMailRequest:
          switch (record.claseCpbte) {
            case "PedidosVT":
              table = 'tbl_ComprobantesPedidosVT';
              actionRequest = 'SendMassiveBillingEmails';
              break;
            case "FacturasVT":
            case "RecibosVT":
              table = 'tbl_ComprobantesVT';
              actionRequest = 'SendMassiveBillingEmails';
              break;
          }
          break;
        default:
      }
      var pHeaderGlobalRequest = ConstRequests.viewRequest;
      var pHeaderLocalRequest = ConstRequests.viewRequest;
      var pActionRequest = ConstRequests.customRequest;
      var pHeaderParamsRequests = HeaderParamsRequest();
      pHeaderParamsRequests.realGlobalRequest =
          ConstRequests.customRequest.typeId;
      pHeaderParamsRequests.realLocalRequest =
          ConstRequests.customRequest.typeId;
      pHeaderParamsRequests.globalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.localRequest = ConstRequests.customRequest.typeId;
      pHeaderParamsRequests.actionRequest = "CustomRequest";
      pHeaderParamsRequests.offset = 0;
      pHeaderParamsRequests.pageSize = 0;
      // pHeaderParamsRequests.sortField = "KeyEmpresa";
      pHeaderParamsRequests.sortIndex = 1;
      pHeaderParamsRequests.sortAsc = false;
      pHeaderParamsRequests.search = "";
      pHeaderParamsRequests.table = table;
      //"ActionRequest": "GraphDataPedidosVTByMonth",
      pHeaderParamsRequests.localParams = {
        'DBVersion': 10,
        "ActionRequest": actionRequest,
        "SubActionRequest": "Process",
        "Table": table,
        "CodEmp": record.codEmp,
        "NroCpbte": record.nroCpbte,
        "ShowOnlyFiltered": showOnlyFiltered,
        "FilterEstados": [],
        "FilterTAGs": [],
        "FilterSaldos": [],
        "FilterTiposServicios": [],
        // "SelectBy": "KeyGraphDataGroupedByMonth",
        "AdditionalParams": AdditionalParams(
          actionRequest: actionRequest,
          periodoFacturacion: CommonDateModel.fromDefault(),
          fechaEnvioMails: CommonDateModel.fromDefault(),
          periodoInstalaciones: CommonDateModel.fromDefault(),
          tipoFacturacion: "",
          tipoRegistracion: "",
          codEmp: record.codEmp,
          tipoCliente: record.tipoCliente,
          codClie: record.codClie,
          nroCpbte: record.nroCpbte,
          fromDate: CommonDateModel.fromDefault(),
          toDate: CommonDateModel.fromDefault(),
        ),
        // "SpecificParams": widget.pDataModel.specificParams,
      };
      var rData = await tEnteDataModel.abmCalls(
        pGlobalRequest: pHeaderGlobalRequest,
        pLocalRequest: pHeaderLocalRequest,
        pActionRequest: pActionRequest,
        pTable: table,
        pEnte: record as T,
        returnResults: true,
        pHeaderParamsRequest: pHeaderParamsRequests,
      );
      if (!mounted) {
        return ErrorHandler(
          errorCode: 9900,
          errorDsc: 'Widget no montado',
          className: mainFunc,
          functionName: "",
          stacktrace: StackTrace.current,
        );
      }
      if (rData.errorCode != 0) {
        /// Error. We show the message (normally)
        /// We wait for some X time before continuing.
        /// 1) We show the error
        setState(() {
          _progressText = '${n + 1} de $of (en error)';
          _progressErrorTextInfo = '''Código: ${rData.errorCode}
Detalle: ${rData.errorDsc}
''';
        });

        if (!silenceMode) {
          await Navigator.of(context)
              .push(ModelGeneralPoPUpErrorMessageDialog(error: rData));
          if (!mounted) {
            return;
          }
        }

        /// 2) We continue.
        /// ONLY if _cancelProcess = false;
        if (!_cancelProcess) {
          runLoopProcess(n + 1, of);
        }
      } else {
        /// No error. We continue
        setState(() {
          _progressController.value = (n + 1).toDouble() / of.toDouble();
          _progressText = '${n + 1} de $of (completado)';
          _progressTextInfo += '\r\nComprobante descargado';
          _progressErrorTextInfo = "";
          //_progressErrorTextInfo = '${rBill.errorCode} ${rBill.errorDsc}';
        });
        if (!_cancelProcess) {
          runLoopProcess(n + 1, of);
          return;
        }
      }
    } else {
      // if (n < of) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) {
          return;
        }
        setState(() {
          isAuto = false;
          isProcessRunning = false;
          _progressText = '';
          _progressTextInfo = '';
          _progressErrorTextInfo = "";
          _progressController.value = 0;
          _showProgress = false;
          _cancelProcess = false;
          totalRecords = 0;
          selectedItems = [];
          waitingFordata = true;
        });
        if (Navigator.canPop(context)) {
          Navigator.pop(context, null);
        }
      });
    }
  }

  Future<void> _doInitProcess() async {
    setState(() {
      isAuto = true;
      silenceMode = false;
      isProcessRunning = true;
      _progressText = '';
      _progressTextInfo = '';
      _progressErrorTextInfo = "";
      _progressController.value = 0;
      _showProgress = true;
      _cancelProcess = false;
    });
    if (totalRecords == 0) {
      await Navigator.of(context).push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: ErrorHandler(errorCode: 9999, errorDsc: '''
Para poder iniciar el proceso debe haber al menos un comprobante seleccionado.
Actualmente, no hay comprobantes seleccionado.
Por favor verifique para poder continuar y vuelva a intentar la operación.
                  '''),
        ),
      );
      setState(() {
        isAuto = false;
        silenceMode = false;
        isProcessRunning = false;
        _progressText = '';
        _progressTextInfo = '';
        _progressErrorTextInfo = "";
        _progressController.value = 0;
        _showProgress = false;
        _cancelProcess = false;
      });
      return;
    } else {
      runLoopProcess(0, selectedItems.length);
      return;
    }
  }

  // void _doCancelProcess() {
  //   setState(() {
  //     _cancelProcess = true;
  //   });
  // }

  // /// This function validates fechaEnvioMails constraints
  // ///
  // Future<void> _validatePeriodoInstalaciones() async {
  //   await periodoInstalaciones.selectDate(
  //     context,
  //     firstDate: DateTime(2024),
  //   );
  //   setState(() {
  //     tEnteDataModel.pPeriodoInstalaciones =
  //         CommonDateModel.fromDateTime(periodoInstalaciones.date);
  //     tEnteDataModel.pPeriodoInstalaciones.formatType = "periodo";
  //   });
  //   _initWork();
  // }

  String _windowTitleForAction(ConstRequests request) {
    switch (request) {
      case ConstRequests.sendEMailRequest:
        return 'ENVÍO DE COMPROBANTES';
      case ConstRequests.downloadRequest:
      default:
        return 'DESCARGA DE COMPROBANTES';
    }
  }

  String get _operationTitle {
    switch (widget.pLocalActionRequest) {
      case ConstRequests.sendEMailRequest:
        return 'Enviando comprobante';
      case ConstRequests.downloadRequest:
      default:
        return 'Preparando comprobante';
    }
  }

  String get _operationIdleTitle {
    switch (widget.pLocalActionRequest) {
      case ConstRequests.sendEMailRequest:
        return 'Comprobante listo para enviar';
      case ConstRequests.downloadRequest:
      default:
        return 'Comprobante listo para descargar';
    }
  }

  String get _primaryActionLabel {
    switch (widget.pLocalActionRequest) {
      case ConstRequests.sendEMailRequest:
        return 'Enviar';
      case ConstRequests.downloadRequest:
      default:
        return 'Descargar';
    }
  }

  IconData get _operationIcon {
    switch (widget.pLocalActionRequest) {
      case ConstRequests.sendEMailRequest:
        return Icons.mail_outline;
      case ConstRequests.downloadRequest:
      default:
        return Icons.download_outlined;
    }
  }

  Widget _buildOperationBody(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasError = _progressErrorTextInfo.trim().isNotEmpty;
    final bool isWorking = _loading || isProcessRunning;
    final String info = _progressTextInfo.trim();
    final String progress = _progressText.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isWorking && !hasError)
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colorScheme.primary,
              ),
            )
          else
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: (hasError ? colorScheme.error : colorScheme.primary)
                    .withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasError ? Icons.error_outline : _operationIcon,
                color: hasError ? colorScheme.error : colorScheme.primary,
                size: 28,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            hasError
                ? 'No pudimos completar la operación'
                : isWorking
                    ? _operationTitle
                    : _operationIdleTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: hasError ? colorScheme.error : colorScheme.onSurface,
            ),
          ),
          if (progress.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              progress,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (_showProgress && totalRecords > 0) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: _progressController.value.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
          if (info.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                info,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ),
          ],
          if (hasError) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _progressErrorTextInfo.trim(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
          if (!isWorking) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: totalRecords > 0 ? _doInitProcess : null,
                icon: Icon(_operationIcon),
                label: Text(_primaryActionLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String locFunc = 'build';
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (debug) {
          developer.log(
            '$mainFunc - $locFunc - '
            'windowWidth:${constraints.maxWidth} - '
            'windowHeight:${constraints.maxHeight}',
            name: 'CommonDownloadLocallyScreen',
          );
        }

        try {
          return AppOverlayPanel(
            title: windowTitleCaption,
            titleColorBackground: theme.colorScheme.primary,
            constraints: constraints,
            bodyWidget: _buildOperationBody(context),
          );
        } catch (e, stacktrace) {
          return CatchMainScreen(
            locFunc: locFunc,
            constraints: constraints,
            e: e,
            stacktrace: stacktrace,
            debug: debug,
            pScreenMaxHeight: constraints.maxHeight,
            pScreenMaxWidth: constraints.maxWidth,
          );
        }
      },
    );
  }
}

/// This process is call to ensures it is called/executed as a PopUp
///
class ScreenPoPUpCommonDownloadLocallyScreen<T extends CommonModel<T>>
    extends PopupRoute<T> {
  final ConstRequests pGlobalRequest;
  final ConstRequests pActionRequest;
  final ConstRequests pLocalActionRequest;
  final List<CommonDownloadLocallyModel> pParams;
  final bool autoStart;

  ScreenPoPUpCommonDownloadLocallyScreen({
    required this.pGlobalRequest,
    required this.pActionRequest,
    required this.pLocalActionRequest,
    required this.pParams,
    this.autoStart = false,
  });

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Procesando comprobante';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Size mediaSize = MediaQuery.sizeOf(context);
    final double availableWidth = (mediaSize.width - 32).clamp(0.0, 520.0);
    final double availableHeight = (mediaSize.height - 32).clamp(0.0, 420.0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: availableWidth,
            height: availableHeight,
            child: CommonDownloadLocallyScreen<T>(
              pScreenMaxWidth: availableWidth,
              pScreenMaxHeight: availableHeight,
              pGlobalRequest: pGlobalRequest,
              pActionRequest: pActionRequest,
              pLocalActionRequest: pLocalActionRequest,
              pParams: pParams,
              autoStart: autoStart,
            ),
          ),
        ),
      ),
    );
  }
}
