import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDownloadLocally/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/extensions/color.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/loading_generic.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/error_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ClientesV2/additionalparams.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/system_error_surface.dart';
import 'package:geryon_web_app_ws_v2/shared/window/window_model.dart';
import 'package:geryon_web_app_ws_v2/shared/window/window_widget.dart';

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
  late double screenMaxWidth;
  late double screenMaxHeight;
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
    screenMaxWidth = widget.pScreenMaxWidth - 8;
    screenMaxHeight = widget.pScreenMaxHeight - 8;
    globalRequest = widget.pGlobalRequest;
    localRequest = widget.pActionRequest;

    _progressController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      //duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

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
    //
    periodoInstalaciones.dispose();
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
        switch (widget.pLocalActionRequest) {
          case ConstRequests.downloadRequest:
            windowTitleCaption = 'DESCARGA DE COMPROBANTES';
            break;
          case ConstRequests.sendEMailRequest:
            windowTitleCaption = 'ENVÍO DE MAILS DE COMPROBANTES';
            break;
          default:
        }
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
    double cPct = (n.toDouble() + 1) / of.toDouble();
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

      /// We call the procedure.
      ///
      Map<String, dynamic> pLocalParamsRequest = {
        "ActionRequest": actionRequest,
        "SubActionRequest": "Process",
        "Table": table,
        "CodEmp": record.codEmp,
        "NroCpbte": record.nroCpbte,
        "ShowOnlyFiltered": showOnlyFiltered,
        "AdditionalParams": AdditionalParams(
          actionRequest: "MassiveText",
          periodoFacturacion: CommonDateModel.fromDefault(),
          fechaEnvioMails: CommonDateModel.fromDefault(),
          periodoInstalaciones: periodoInstalaciones,
          tipoFacturacion: "Mensual:ByPerfilFacturacion",
          tipoRegistracion: "Simulacion",
          codEmp: record.codEmp,
          tipoCliente: record.tipoCliente,
          codClie: record.codClie,
          nroCpbte: record.nroCpbte,
        ),
      };
      ErrorHandler rData;

      rData = await tEnteDataModel.abmCalls(
        pGlobalRequest: ConstRequests.viewRequest,
        pLocalRequest: ConstRequests.customRequest,
        pActionRequest: ConstRequests.customRequest,
        pEnte: record as T,
        pTable: table,
        returnResults: true,
        pLocalParamsRequest: pLocalParamsRequest,
      );
      if (!mounted) {
        return;
      }

      if (rData.errorCode != 0) {
        /// Error. We show the message (normally)
        /// We wait for some X time before continuing.
        /// 1) We show the error
        setState(() {
          _progressText = '${n + 1} de $of (en error)';
          _progressErrorTextInfo = '''Code: ${rData.errorCode}
          Message: ${rData.errorDsc}
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
        setState(() {
          isAuto = false;
          _progressText = '';
          _progressTextInfo = '';
          _progressErrorTextInfo = "";
          _progressController.value = 0;
          _showProgress = false;
          _cancelProcess = false;
          totalRecords = 0;
          selectedItems = [];
          waitingFordata = true;
          // _initWork(
          //   autoStart: true,
          // );
        });
        if (!mounted) {
          return;
        }
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

  void _doCancelProcess() {
    setState(() {
      _cancelProcess = true;
    });
  }

  /// This function validates fechaEnvioMails constraints
  ///
  Future<void> _validatePeriodoInstalaciones() async {
    await periodoInstalaciones.selectDate(
      context,
      firstDate: DateTime(2024),
    );
    setState(() {
      tEnteDataModel.pPeriodoInstalaciones =
          CommonDateModel.fromDateTime(periodoInstalaciones.date);
      tEnteDataModel.pPeriodoInstalaciones.formatType = "periodo";
    });
    _initWork();
  }

  @override
  Widget build(BuildContext context) {
    const String locFunc = ".::BUILD::";
    double maxScreenWidth = MediaQuery.of(context).size.width;
    double maxScreenHeight = MediaQuery.of(context).size.height;
    if (debug) {
      developer.log(
          '$mainFunc - $locFunc - maxScreenWidth:$maxScreenWidth[$screenMaxWidth] - maxScreenHeight:$maxScreenHeight[$screenMaxHeight]');
    }
    Widget buildWindowHeader() {
      return Placeholder(
        fallbackHeight: 50,
        child: Text('Header for $windowTitleCaption'),
      );
    }

    Widget buildWindowBody({
      required BoxConstraints constraints,
    }) {
      if (widget.autoStart) {
        isAuto = true;
      }
      return Column(
        children: [
          if (isAuto)
            SizedBox(
              height: 5,
            ),
          if (isAuto)
            LoadingGeneric(
              loadingText: "Descargando...",
            ),
          if (!isAuto)
            SizedBox(
              height: 5,
            ),
          SizedBox(
            height: 50,
            width: screenMaxWidth,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: _progressTextInfo,
                style: const TextStyle(
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (!isAuto || !isProcessRunning)
            SizedBox(
              width: screenMaxWidth * 0.5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5.0), // Adjust the radius as needed
                        ),
                        elevation: 5),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download),
                        Text(
                          'DESCARGAR',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      _doInitProcess();
                    }),
              ),
            ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const String locFunc = 'LayoutBuilder';
        const String logLocFunc = '.::$locFunc::.';
        double windowWidth = constraints.maxWidth;
        double windowHeight = constraints.maxHeight;
        if (debug) {
          developer.log(
            '$mainFunc - $logLocFunc - windowWidth:$windowWidth - windowHeight:$windowHeight',
            name: 'CommonDownloadLocallyScreen',
          );
        }
        try {
          var wTitle = windowTitleCaption;
          var wColor = Colors.redAccent;
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
                      titleColorBackground: wColor,
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

        // try {
        //   if (!_loading) {
        //     periodoInstalaciones = CommonDateModel.fromDateTime(
        //       tEnteDataModel.pPeriodoInstalaciones.date,
        //       pType: 'periodo',
        //     );
        //     periodoInstalaciones.readOnly = false;
        //     periodoInstalaciones.type = 'periodo';
        //     showOnlyFiltered = tEnteDataModel.showOnlyFiltered;
        //     periodoInstalaciones.isVisible = false;
        //   }
        //   final themeData = Theme.of(context);
        //   double titleHeight = 30;
        //   double bodyHeight = constraints.maxHeight - 4 - 4 - titleHeight;
        //   var rMainScreen = _loading
        //       ? LoadingGeneric()
        //       : Stack(
        //           children: [
        //             Scrollbar(
        //               controller: mainScroller,
        //               thumbVisibility: true,
        //               child: Card(
        //                 semanticContainer: false,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.stretch,
        //                   children: [
        //                     /// Header Title
        //                     ///
        //                     Container(
        //                       decoration: BoxDecoration(
        //                         color: themeData.primaryColor,
        //                         border: Border(
        //                           bottom: BorderSide(
        //                             color: themeData.primaryColorDark,
        //                           ),
        //                         ),
        //                       ),
        //                       height: titleHeight,
        //                       child: Padding(
        //                         padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        //                         child: Align(
        //                           alignment: Alignment.centerLeft,
        //                           child: RichText(
        //                             textAlign: TextAlign.start,
        //                             text: TextSpan(
        //                               text: windowTitleCaption,
        //                               style: TextStyle(
        //                                 overflow: TextOverflow.ellipsis,
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ),

        //                     /// Body
        //                     ///
        //                     SizedBox(
        //                       /*
        //                       decoration: BoxDecoration(
        //                         color: Colors.blue.shade400,
        //                       ),
        //                       */
        //                       height: bodyHeight,
        //                       width: screenMaxWidth,
        //                       child: SingleChildScrollView(
        //                         controller: mainScroller,
        //                         scrollDirection: Axis.horizontal,
        //                         dragStartBehavior: DragStartBehavior.start,
        //                         child: Column(
        //                           children: [
        //                             /// Separador
        //                             SizedBox(
        //                               height: 10,
        //                             ),

        //                             /// periodoInstalaciones
        //                             Visibility(
        //                               visible: periodoInstalaciones.isVisible,
        //                               child: SizedBox(
        //                                 width: 200,
        //                                 height: 50,
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.all(4.0),
        //                                   child: TextFormField(
        //                                     style: const TextStyle(
        //                                       fontSize: 12,
        //                                       height: 1,
        //                                       overflow: TextOverflow.ellipsis,
        //                                     ),
        //                                     readOnly:
        //                                         periodoInstalaciones.readOnly,
        //                                     textAlign: TextAlign.end,
        //                                     controller:
        //                                         periodoInstalaciones.controller,
        //                                     focusNode:
        //                                         periodoInstalaciones.focusNode,
        //                                     decoration: InputDecoration(
        //                                         suffixIcon: AbsorbPointer(
        //                                           absorbing:
        //                                               periodoInstalaciones
        //                                                   .readOnlyOnIcon,
        //                                           child: IconButton(
        //                                             icon: const Icon(
        //                                               Icons.calendar_today,
        //                                             ),
        //                                             onPressed: () async {
        //                                               await _validatePeriodoInstalaciones();
        //                                             },
        //                                           ),
        //                                         ),
        //                                         border:
        //                                             const OutlineInputBorder(),
        //                                         labelText:
        //                                             'PERIODO DE INSTALACIONES'),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),

        //                             /// showOnlyFiltered
        //                             Visibility(
        //                               visible: periodoInstalaciones.isVisible,
        //                               child: Tooltip(
        //                                 message:
        //                                     'Filtra y muestra solos los comprobantes asociados al período seleccionado.',
        //                                 child: Row(
        //                                   children: [
        //                                     Container(
        //                                       decoration: BoxDecoration(
        //                                         color: Colors.pink.shade100,
        //                                       ),
        //                                       //height: 40,
        //                                       width: screenMaxWidth,
        //                                       child: SwitchListTile(
        //                                         title: const Text(
        //                                           'SOLO los del período',
        //                                           //style: TextStyle(fontSize: 14),
        //                                         ),
        //                                         value: showOnlyFiltered,
        //                                         onChanged: (bool value) {
        //                                           setState(() {
        //                                             tEnteDataModel
        //                                                     .showOnlyFiltered =
        //                                                 value;
        //                                             mustRefresh = true;
        //                                           });
        //                                         },
        //                                         secondary: const Icon(
        //                                             Icons.filter_alt),
        //                                       ),
        //                                     )
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),

        //                             /// ProgressBar
        //                             Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.center,
        //                               children: [
        //                                 Stack(
        //                                   alignment:
        //                                       AlignmentDirectional.center,
        //                                   children: [
        //                                     SizedBox(
        //                                       width: screenMaxWidth,
        //                                       height: 30,
        //                                       child: LinearProgressIndicator(
        //                                         value:
        //                                             _progressController.value,
        //                                         //semanticsLabel: 'Linear progress indicator',
        //                                       ),
        //                                     ),
        //                                     RichText(
        //                                       textAlign: TextAlign.start,
        //                                       text: TextSpan(
        //                                         text: _progressText,
        //                                         style: const TextStyle(
        //                                           overflow:
        //                                               TextOverflow.ellipsis,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ],
        //                             ),

        //                             /// Separador
        //                             const SizedBox(
        //                               height: 10,
        //                             ),

        //                             /// ProgressTextInfoResponse
        //                             SizedBox(
        //                               height: 30,
        //                               width: screenMaxWidth,
        //                               child: SingleChildScrollView(
        //                                 //controller: mainScroller,
        //                                 scrollDirection: Axis.vertical,
        //                                 dragStartBehavior:
        //                                     DragStartBehavior.start,
        //                                 child: RichText(
        //                                   textAlign: TextAlign.center,
        //                                   text: TextSpan(
        //                                     text: _progressErrorTextInfo,
        //                                     style: const TextStyle(
        //                                       color: Colors.black54,
        //                                       overflow: TextOverflow.ellipsis,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),

        //                             /// Continúa con errores
        //                             Tooltip(
        //                               message:
        //                                   'Si ocurren errores durante el proceso de envío del mail\r\nel sistema continuará con el próximo registro.\r\nEsto permite que el proceso finalice y los registros con errores quedarán pendientes.',
        //                               child: Row(
        //                                 children: [
        //                                   Container(
        //                                     decoration: BoxDecoration(
        //                                       color: Colors.pink.shade100,
        //                                     ),
        //                                     //height: 40,
        //                                     width: screenMaxWidth,
        //                                     child: SwitchListTile(
        //                                       title: const Text(
        //                                         'NO MOSTRAR ERRORES (CONTINUAR)',
        //                                         //style: TextStyle(fontSize: 14),
        //                                       ),
        //                                       value: silenceMode,
        //                                       onChanged: (bool value) {
        //                                         setState(() {
        //                                           silenceMode = value;
        //                                         });
        //                                       },
        //                                       secondary: Icon(MdiIcons.doctor),
        //                                     ),
        //                                   )
        //                                 ],
        //                               ),
        //                             ),

        //                             /// Separador
        //                             const SizedBox(
        //                               height: 10,
        //                             ),

        //                             /// Iniciar
        //                             Row(
        //                               children: [
        //                                 if (mustRefresh)
        //                                   SizedBox(
        //                                     width: screenMaxWidth * 0.5,
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               4, 0, 4, 0),
        //                                       child: ElevatedButton(
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                                   shape:
        //                                                       RoundedRectangleBorder(
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .circular(
        //                                                                 5.0), // Adjust the radius as needed
        //                                                   ),
        //                                                   elevation: 5),
        //                                           child: const Column(
        //                                             mainAxisAlignment:
        //                                                 MainAxisAlignment
        //                                                     .center,
        //                                             children: [
        //                                               Icon(Icons.refresh),
        //                                               Text(
        //                                                 'REFRESH',
        //                                                 style: TextStyle(
        //                                                     fontSize: 12),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                           onPressed: () async {
        //                                             _initWork();
        //                                           }),
        //                                     ),
        //                                   ),
        //                                 if (!mustRefresh)
        //                                   SizedBox(
        //                                     width: screenMaxWidth * 0.5,
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               4, 0, 4, 0),
        //                                       child: ElevatedButton(
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                                   shape:
        //                                                       RoundedRectangleBorder(
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .circular(
        //                                                                 5.0), // Adjust the radius as needed
        //                                                   ),
        //                                                   elevation: 5),
        //                                           child: const Column(
        //                                             mainAxisAlignment:
        //                                                 MainAxisAlignment
        //                                                     .center,
        //                                             children: [
        //                                               Icon(Icons.start),
        //                                               Text(
        //                                                 'Iniciar',
        //                                                 style: TextStyle(
        //                                                     fontSize: 12),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                           onPressed: () async {
        //                                             _doInitProcess();
        //                                           }),
        //                                     ),
        //                                   ),
        //                                 if (_showProgress && !_cancelProcess)
        //                                   SizedBox(
        //                                     width: screenMaxWidth * 0.5,
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               4, 0, 4, 0),
        //                                       child: ElevatedButton(
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                                   shape:
        //                                                       RoundedRectangleBorder(
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .circular(
        //                                                                 5.0), // Adjust the radius as needed
        //                                                   ),
        //                                                   elevation: 5),
        //                                           child: const Column(
        //                                             mainAxisAlignment:
        //                                                 MainAxisAlignment
        //                                                     .center,
        //                                             children: [
        //                                               Icon(Icons
        //                                                   .cancel_outlined),
        //                                               Text(
        //                                                 'Cancelar',
        //                                                 style: TextStyle(
        //                                                     fontSize: 12),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                           onPressed: () {
        //                                             _doCancelProcess();
        //                                           }),
        //                                     ),
        //                                   ),
        //                                 if (!_showProgress ||
        //                                     (_showProgress && _cancelProcess))
        //                                   SizedBox(
        //                                     width: screenMaxWidth * 0.5,
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               4, 0, 4, 0),
        //                                       child: ElevatedButton(
        //                                         style: ElevatedButton.styleFrom(
        //                                             shape:
        //                                                 RoundedRectangleBorder(
        //                                               borderRadius:
        //                                                   BorderRadius.circular(
        //                                                       5.0), // Adjust the radius as needed
        //                                             ),
        //                                             elevation: 5),
        //                                         child: const Column(
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment.center,
        //                                           children: [
        //                                             Icon(Icons.arrow_back),
        //                                             Text(
        //                                               'Volver',
        //                                               style: TextStyle(
        //                                                   fontSize: 12),
        //                                             ),
        //                                           ],
        //                                         ),
        //                                         onPressed: () =>
        //                                             Navigator.of(context).pop(),
        //                                       ),
        //                                     ),
        //                                   ),
        //                               ],
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         );
        //   return rMainScreen;
        // } catch (e, stacktrace) {
        //   return Scrollbar(
        //     child: Card(
        //       child: Column(
        //         children: [
        //           Text(
        //             e.toString(),
        //           ),
        //           Text(stacktrace.toString()),
        //           SizedBox(
        //             height: 63.75,
        //             width: 85,
        //             child: ElevatedButton(
        //               style: ElevatedButton.styleFrom(elevation: 5),
        //               child: const Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(Icons.remove),
        //                   Text(
        //                     'Borrar',
        //                     style: TextStyle(fontSize: 12),
        //                   ),
        //                 ],
        //               ),
        //               onPressed: () => Navigator.of(context).pop(),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }
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
  String? get barrierLabel => 'Dismissible Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  double screenMaxWidth = 400;
  double screenMaxHeight = 200;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12.withSafeOpacity(0.5),
          ),
          width: screenMaxWidth,
          height: screenMaxHeight,
          child: SizedBox(
            height: 63.75,
            width: 85,
            child: CommonDownloadLocallyScreen<T>(
              pScreenMaxWidth: screenMaxWidth,
              pScreenMaxHeight: screenMaxHeight,
              pGlobalRequest: pGlobalRequest,
              pActionRequest: pActionRequest,
              pLocalActionRequest: pLocalActionRequest,
              pParams: pParams,
              autoStart: autoStart,
            ),
          ),
        ),
      ), // Your ConsumerStatefulWidget
    ));
  }
}
