import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/header_request.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/LoadingGeneric/widget.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/SimpleTableWithScroll/widget.dart';
import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ComprobantesVT/model.dart';
import 'package:geryon_web_app_ws_v2/pages/CatchMainScreen/widget.dart';
import 'package:geryon_web_app_ws_v2/pages/WindowWidget/mode.dart';
import 'package:geryon_web_app_ws_v2/pages/WindowWidget/widget.dart';

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
  late final ScrollController mainScroller;
  late final ScrollController mainCatchScroller;
  late final ScrollController secondScroller;
  late final ScrollController secondCatchScroller;
  String dThreadHashID = "";
  bool isInit = true;
  late GenericDataModel<TableComprobantesVTModel> tEnteDataModel;
  ConstRequests pGlobalRequest = ConstRequests.viewRecord;
  ConstRequests pLocalRequest = ConstRequests.viewRecord;
  bool hasError = false;
  ErrorHandler? errorHandler;
  // Dentro de tu State:
  late final ProviderSubscription<ServiceProvider> _subscription;
  int? _lastCCliente;

  @override
  void initState() {
    super.initState();
    isInit = true;
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
    _subscription.close();
    super.dispose();
  }

  Future<void> _onStateChange(
    ServiceProvider previous,
    ServiceProvider next,
  ) async {
    final String functionName = 'BillingWidget._onStateChange';
    final String logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '🚀 $mainFunc - $logFunctionName: State changed from $previous to $next',
        name: '$mainFunc - $logFunctionName',
      );
    }
    // Aquí puedes manejar el cambio de cliente, por ejemplo, reiniciar datos
    if (dThreadHashID.isEmpty) {
      dThreadHashID = generateRandomUniqueHash();
    }
    await ref.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: dThreadHashID,
          value: GenericDataModel<TableComprobantesVTModel>(
            wRef: ref,
            debug: debug,
            threadID: dThreadHashID,
          ),
        );
    if (!mounted) {
      return;
    }
    var pHeaderParamsRequests = HeaderParamsRequest();
    setState(() {
      tEnteDataModel = ref
          .read(notifierServiceProvider)
          .mapThreadsToDataModels
          .get(dThreadHashID);
      // tEnteDataModel.pGlobalRequest = ConstRequests.viewRecord;
      // tEnteDataModel.pLocalRequest = ConstRequests.viewRecord;
      tEnteDataModel.pGlobalRequest = pGlobalRequest;
      tEnteDataModel.pLocalRequest = pLocalRequest;
      tEnteDataModel.cEmpresa = ref.read(notifierServiceProvider).cEmpresa;
      tEnteDataModel.cEncRecord = TableComprobantesVTModel.fromDefault(
        pEmpresa: tEnteDataModel.cEmpresa,
      );
      tEnteDataModel.fromJsonFunction = TableComprobantesVTModel.fromJson;
      pHeaderParamsRequests.realGlobalRequest = pGlobalRequest.typeId;
      pHeaderParamsRequests.realLocalRequest = pLocalRequest.typeId;
      pHeaderParamsRequests.globalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.localRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.offset = 0;
      pHeaderParamsRequests.pageSize = 0;
      pHeaderParamsRequests.sortField = 'FechaCpbte';
      pHeaderParamsRequests.sortIndex = 0;
      pHeaderParamsRequests.sortAsc = false;
      pHeaderParamsRequests.search = "";
      pHeaderParamsRequests.table = tEnteDataModel.cEncRecord.iDefaultTable();
      var cUser = ref
          .read(notifierServiceProvider)
          .loggedUser!
          .clientes[ref.read(notifierServiceProvider).loggedUser!.cCliente];
      tEnteDataModel.threadParams = {
        'DBVersion': 2,
        'SelectBy': 'KeyCliente',
        'CodEmp': tEnteDataModel.cEmpresa.codEmp,
        'TipoCliente': cUser.tipoCliente,
        'CodClie': cUser.codClie,
        'ClaseCpbte': widget.pType,
        'ClaseCpbteVT': widget.pType,
        'IsEmpresaAggregated': true,
      };
      developer.log(
        'BillingWidget._initWork: tEnteDataModel: tEnteDataModel.threadParams: ${tEnteDataModel.threadParams}  ',
        name: '$mainFunc - .::$functionName::.',
      );

      isInit = true;
    });
    // Obtengo los datos de los comprobantes del cliente para el tipo de comprobante seleccionado
    Map<String, dynamic> pLocalParams = tEnteDataModel.threadParams;
    pLocalParams["ActionRequest"] = "ViewRecord";
    pLocalParams["Table"] = tEnteDataModel.cEncRecord.iDefaultTable();
    // TableEmpresaModel eEmpresa = pEnteSelected.eEmpresa;
    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pTable = tEnteDataModel.cEncRecord.iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;

    pHeaderParamsRequests.localParams = pLocalParams;
    ErrorHandler rFilteredRecords =
        await tEnteDataModel.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: tEnteDataModel.cEncRecord,
      pHeaderParamsRequest: pHeaderParamsRequests,
    );
    if (!mounted) {
      return;
    }
    if (rFilteredRecords.errorCode != 0) {
      developer.log(
        'BillingWidget._initWork: Error al obtener los datos de los comprobantes: ${rFilteredRecords.errorDsc}',
        name: '$mainFunc - .::$functionName::.',
      );
      setState(() {
        hasError = true;
        errorHandler = rFilteredRecords;
      });
      // await Navigator.of(context).push(ModelGeneralPoPUpErrorMessageDialog(
      //   error: rFilteredRecords,
      // ));
      return;
    }

    developer.log(
      'BillingWidget._initWork: Datos de los comprobantes obtenidos correctamente ${rFilteredRecords.rawData.runtimeType}',
      name: '$mainFunc - .::$functionName::.',
    );
    CommonDataModelWholeMessage<TableComprobantesVTModel> rReturnedRawData;
    if (rFilteredRecords.rawData
        is! CommonDataModelWholeMessage<TableComprobantesVTModel>) {
      developer.log(
        'BillingWidget._initWork: rawData is not CommonDataModelWholeMessage<TableComprobantesVTModel>',
        name: '$mainFunc - .::$functionName::.',
      );
      setState(() {
        hasError = true;
        errorHandler = ErrorHandler(
          errorCode: 99999,
          errorDsc: '''Error al obtener los datos de los comprobantes
            Esperado un CommonDataModelWholeMessage<TableComprobantesVTModel>
            pero se obtuvo: ${rFilteredRecords.rawData.runtimeType}
            ''',
          className: mainFunc,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      });
      return;
    }
    rReturnedRawData = rFilteredRecords.rawData;
    CommonDataModelWholeDataMessage<TableComprobantesVTModel>
        rReturnedRawDataData;
    developer.log(
      'BillingWidget._initWork: rawDataData is ${rReturnedRawData.data.runtimeType}',
      name: '$mainFunc - .::$functionName::.',
    );
    if (rReturnedRawData.data
        is! CommonDataModelWholeDataMessage<TableComprobantesVTModel>) {
      developer.log(
        'BillingWidget._initWork: rawDataData is not CommonDataModelWholeDataMessage<TableComprobantesVTModel>',
        name: '$mainFunc - .::$functionName::.',
      );
      setState(() {
        hasError = true;
        errorHandler = ErrorHandler(
          errorCode: 99999,
          errorDsc: '''Error al obtener los datos de los comprobantes
            Esperado un CommonDataModelWholeDataMessage<TableComprobantesVTModel>
            pero se obtuvo: ${rReturnedRawData.data.runtimeType}
            ''',
          className: mainFunc,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      });
      return;
    }
    rReturnedRawDataData = rReturnedRawData.data
        as CommonDataModelWholeDataMessage<TableComprobantesVTModel>;
    // CommonDataModelWholeDataDataMessage<TableComprobantesVTModel>
    //     rReturnedRawDataDataData;
    setState(() {
      hasError = false;
      errorHandler = null;
      isInit = false;
      tEnteDataModel.cData = rReturnedRawDataData.data.records;
      tEnteDataModel.totalRecords = rReturnedRawDataData.data.totalRecords;
      tEnteDataModel.totalFilteredRecords =
          rReturnedRawDataData.data.totalFilteredRecords;
    });
    developer.log(
      'BillingWidget._initWork: Datos de los comprobantes cargados correctamente: ${tEnteDataModel.cData.length} registros',
      name: '$mainFunc - .::$functionName::.',
    );
    return;
  }

  void _initWork() async {
    String functionName = 'BillingWidget._initWork';
    String logFunctionName = '.::$functionName::.';
    // Initialize any work needed for the widget
    try {
      developer.log(
        'Iniciando trabajo en ',
        name: '$mainFunc - .::$logFunctionName::.',
      );
      _subscription = ref.listenManual<ServiceProvider>(notifierServiceProvider,
          (previous, next) {
        final String locFunctionName = 'listenManual';
        final String logFunctionName =
            '.::$functionName=>::$locFunctionName::.';
        final currentCCliente = next.loggedUser?.cCliente;

        if (debug) {
          developer.log(
            '🚀 _initWork: _lastCCliente: $_lastCCliente',
            name: '$mainFunc - $logFunctionName',
          );
        }
        if (_lastCCliente != null && _lastCCliente != currentCCliente) {
          // ✅ Cambio detectado correctamente
          developer.log(
            '🟢 _initWork: Cliente cambió de $_lastCCliente a $currentCCliente',
            name: '$mainFunc - $logFunctionName',
          );

          setState(() {
            _lastCCliente = currentCCliente;
          });

          unawaited(_onStateChange(previous!, next));
          return;
        }
      });
      if (_lastCCliente == null) {
        // ✅ Primer cambio detectado, inicializo _lastCCliente
        setState(() {
          _lastCCliente =
              ref.read(notifierServiceProvider).loggedUser?.cCliente;
        });
        developer.log(
          '🟢 _initWork: Primer cliente detectado: $_lastCCliente',
          name: '$mainFunc - $logFunctionName',
        );
        unawaited(_onStateChange(
          ref.read(notifierServiceProvider),
          ref.read(notifierServiceProvider),
        ));
        return;
      }
    } catch (e, stacktrace) {
      if (mounted) {
        developer.log('$mainFunc - $functionName - CATCHED - $e - $stacktrace');

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

  @override
  Widget build(BuildContext context) {
    String functionName = 'BillingWidget.build';
    String locFunc = '.::$functionName::.';
    ref.watch(notifierServiceProvider);
    Widget buildWindowHeader() {
      return Placeholder(
        fallbackHeight: 50,
        child: Text('Header for ${widget.pType}'),
      );
    }

    Widget buildWindowBody({
      required BoxConstraints constraints,
    }) {
      if (hasError) {
        constraints = BoxConstraints(
          maxHeight: constraints.maxHeight - 32,
          maxWidth: constraints.maxWidth,
        );
        return CatchMainScreen(
          locFunc: locFunc,
          constraints: constraints,
          e: errorHandler?.errorDsc ?? 'Error desconocido',
          stacktrace: errorHandler?.stacktrace ?? StackTrace.current,
          debug: true,
          pScreenMaxHeight: constraints.maxHeight - 32,
          pScreenMaxWidth: constraints.maxWidth,
          showTitleBar: false,
          showClosebutton: false,
          showStacktrace: false,
        );
      }
      List<Map<String, dynamic>> comprobantes = [];
      if (!isInit) {
        comprobantes = tEnteDataModel.cData
            .map((e) => {
                  'ClaseCpbte': e.claseCpbte,
                  'ClaseCpbteVT': e.claseCpbte,
                  'CodEmp': e.codEmp,
                  'TipoCliente': e.tipoCliente,
                  'CodClie': e.codClie,
                  'RazonSocial': e.razonSocialCodClie,
                  'NroCpbte': e.nroCpbte,
                  'FechaCpbte': e.fechaCpbte.toES(),
                  'ImporteTotalConImpuestos':
                      e.importeTotalConImpuestos.asStringWithPrecSpanish(2),
                })
            .toList(growable: false);
      }
      var rReturn = isInit
          ? LoadingGeneric()
          : SizedBox(
              //fallbackHeight: 50,
              child: SimpleTableWithScrollLimit(
                data: comprobantes,
                constraints: constraints,
              ),
            );
      return rReturn;
    }

    developer.log(
      'BillingWidget.build: widget.pType: ${widget.pType}, locFunc: $locFunc',
      name: '$mainFunc - $locFunc',
    );
    // Build the widget tree based on the pType
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
    return LayoutBuilder(builder: (context, constraints) {
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
                /// Billing Type
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
    });
  }
}
