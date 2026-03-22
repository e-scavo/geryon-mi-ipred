import 'dart:developer' as developer;
import 'dart:developer';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names_values.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/common_param_prequest.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/header_request.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/ScreenGeneralWorkInProgress/popup_frame.dart';
import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

typedef SetTest<T> = Future<ErrorHandler> Function({
  required String searchText,
  required TableEmpresaModel pEmpresa,
  required T p,
  String fromProcessAsString,
  String setProperty,
});

abstract class CommonDataModel<T extends CommonModel<T>>
    extends AdvancedDataTableSource<T> {
  static final String _className = 'CommonDataModel';
  static final String aClassName = '.::$_className::';

  T Function({
    required Map<String, dynamic> map,
    int errorCode,
  }) fromJsonFunction = ({
    errorCode = 0,
    required map,
  }) {
    throw ErrorHandler(
      errorCode: 199,
      errorDsc:
          'Función fromJson no fue implementada por la clase correspondiente',
      className: _className,
      functionName: 'fromJsonFunction',
      stacktrace: StackTrace.current,
    );
  };

  /// Método estático genérico para llamar a `onInsertRecord` en la subclase de `T`
  Future<ErrorHandler> Function() onInsertRecord = () async {
    const String functionName = 'onInsertRecord';
    var rError = ErrorHandler(
      errorCode: 198,
      errorDsc:
          'Función $functionName no fue implementada por la clase correspondiente',
      className: _className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: rError,
        ),
      );
    }
    return rError;
  };

  /// Método estático genérico para llamar a `onChangeRecord` en la subclase de `T`
  Future<ErrorHandler> Function({
    required T pEnteData,
  }) onChangeRecord = ({required T pEnteData}) async {
    const String functionName = 'onChangeRecord';
    var rError = ErrorHandler(
      errorCode: 198,
      errorDsc:
          'Función $functionName no fue implementada por la clase correspondiente',
      className: _className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: rError,
        ),
      );
    }
    return rError;
  };

  /// Método estático genérico para llamar a `onDeleteRecord` en la subclase de `T`
  Future<ErrorHandler> Function({
    required T pEnteData,
  }) onDeleteRecord = ({required T pEnteData}) async {
    const String functionName = 'onDeleteRecord';
    var rError = ErrorHandler(
      errorCode: 198,
      errorDsc:
          'Función $functionName no fue implementada por la clase correspondiente',
      className: _className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: rError,
        ),
      );
    }
    return rError;
  };

  /// Método estático genérico para llamar a `onViewRecord` en la subclase de `T`
  Future<ErrorHandler> Function({
    required T pEnteData,
  }) onViewRecord = ({required T pEnteData}) async {
    const String functionName = 'onViewRecord';
    var rError = ErrorHandler(
      errorCode: 198,
      errorDsc:
          'Función $functionName no fue implementada por la clase correspondiente',
      className: _className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: rError,
        ),
      );
    }
    return rError;
  };

  /// Método estático genérico para llamar a `onRevertRecord` en la subclase de `T`
  Future<ErrorHandler> Function({
    required T pEnteData,
  }) onRevertRecord = ({required T pEnteData}) async {
    const String functionName = 'onRevertRecord';
    var rError = ErrorHandler(
      errorCode: 198,
      errorDsc:
          'Función $functionName no fue implementada por la clase correspondiente',
      className: _className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
        ModelGeneralPoPUpErrorMessageDialog(
          error: rError,
        ),
      );
    }
    return rError;
  };

  final WidgetRef wRef;
  bool debug;
  Duration requestTimeOut = defaultRequestTimeOut;

  late T cEncRecord;
  late T cEncOriginalRecord;
  late TableEmpresaModel cEmpresa;
  Map<String, dynamic> threadParams = {};
  CommonDateModel pPeriodoFacturacion = CommonDateModel.fromNow();
  CommonDateModel pPeriodoInstalaciones = CommonDateModel.fromNow();
  CommonDateModel pFechaEnvioMails = CommonDateModel.fromNow();
  bool showOnlyNotSentInGeneral = true;
  bool showOnlyNotSentToday = false;
  bool showOnlyFiltered = false;

  int totalRecords = 0;
  int totalFilteredRecords = 0;
  Map<String, dynamic> grandTotals = {};

  CommonDataModel({
    required this.wRef,
    required this.debug,
  }) {
    //cEncRecord = cEncRecord.fromJson({});
    //cEncRecord = CommonModel.fromJson(map: {}) as T;
    cEmpresa = wRef.read(notifierServiceProvider).cEmpresa;
    //defaultTable = 'CommonDefaultTable';
  }

  bool canInsertRecord = true;
  // bool get canInsertRecord;
  // set canInsertRecord(bool value);

  bool canChangeRecord = true;
  // bool get canChangeRecord;
  // set canChangeRecord(bool value);

  bool canDeleteRecord = true;
  // bool get canDeleteRecord;
  // set canDeleteRecord(bool value);

  // bool get debug;
  // set debug(bool value);

  ConstRequests get pGlobalRequest;
  set pGlobalRequest(ConstRequests value);

  ConstRequests get pLocalRequest;
  set pLocalRequest(ConstRequests value);

  void filterServerSide(String filterQuery);

  Future<ErrorHandler> abmCalls({
    required ConstRequests pGlobalRequest,
    required ConstRequests pLocalRequest,
    required ConstRequests pActionRequest,
    required T pEnte,
    String pTable = "",
    int pTimeout = 120,
    bool returnResults = false,
    Map<String, dynamic>? pLocalParamsRequest,
    HeaderParamsRequest? pHeaderParamsRequest,
  }) async {
    Map<String, dynamic> pLocalParams = {};
    pLocalParams["ActionRequest"] = "UnknownRequest";
    pLocalParams["Table"] = pTable;
    pLocalParams["CodEmp"] = 0;
    pLocalParams["Filters"] = [];
    pLocalParams["Search"] = "";
    pLocalParams["Target"] = "customers";
    if (pLocalParamsRequest != null) {
      pLocalParamsRequest.forEach((key, value) {
        pLocalParams[key] = value;
      });
    }

    CommonParamRequest pParamRequest = CommonParamRequest.fromData(
      pAction: pActionRequest.typeId,
      pTable: pTable,
      pGlobalRequest: pGlobalRequest,
      pLocalRequest: pLocalRequest,
      pLocalParams: pLocalParams,
      pDuration: Duration(seconds: pTimeout),
      pHeaderParamsRequest: pHeaderParamsRequest,
    );
    var rData = await callRPC(
        pGlobalRequest: pGlobalRequest,
        pLocalRequest: pLocalRequest,
        pParamRequest: pParamRequest,
        returnResults: returnResults,
        pActionRequest: pActionRequest);
    log('Generic_FromJSON ${pEnte.runtimeType} - $rData');

    return rData;
  }

  /// callRPC method and callRPCCallback
  /// are generic method to abstract and simplify the call to backend.
  ///
  Future<ErrorHandler> callRPC({
    required ConstRequests pGlobalRequest,
    required ConstRequests pLocalRequest,
    required CommonParamRequest pParamRequest,
    bool returnResults = false,
    ConstRequests? pActionRequest,
  }) async {
    const String functionName = 'CallRPC';
    const String logLocalFunc = '.::$functionName::.';
    bool pShowWorkInProgress = false;
    Duration pRequestTimeOut =
        pParamRequest.pOptions['requestTimeOut'] as Duration? ?? requestTimeOut;

    /// We prepare the pRequest
    ///
    Map<String, dynamic> pRequest = {};
    pRequest = pParamRequest.pRequest;
    pRequest["pParams"]["LocalParams"] = pParamRequest.pLocalParams;
    pRequest["returnResults"] = returnResults;

    /// Según sea el caso, aquí habilito mostrar el cuadro de aguardar
    ///
    switch (pActionRequest) {
      case ConstRequests.cancelRequest:
        pShowWorkInProgress = true;
        break;
      case ConstRequests.saveRequest:
        pShowWorkInProgress = true;
        break;
      default:
    }

    /// We make the the RPC Call
    ///
    ErrorHandler rSendMessageV2 =
        await wRef.read(notifierServiceProvider).sendMessageV2(
              pData: pRequest,
              pShowWorkInProgress: pShowWorkInProgress,
              pTimeOut: pRequestTimeOut,
              callBackFunction: callbackRPC,
            );
    if (rSendMessageV2.errorCode != 0) {
      return rSendMessageV2;
    }
    if (pShowWorkInProgress) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!
            .push(
          ScreenGeneralPoPUpWorkInProgress(messageID: rSendMessageV2.messageID),
        )
            .then((result) async {
          await Future.delayed(const Duration(milliseconds: 500));

          /// Detecto el Pop y establezco ciertos valores del mensaje.
          ///
          try {
            CommonRPCMessageResponse? rMessageResponse = wRef
                .read(notifierServiceProvider)
                .wssMessagesTrackingV2
                .get(rSendMessageV2.messageID);
            if (rMessageResponse == null) {
              return ErrorHandler(
                errorCode: 411000,
                errorDsc:
                    'No pudimos encontrar la referencia al mensaje enviado al backend',
                messageID: rSendMessageV2.messageID,
                className: _className,
                functionName: functionName,
                propertyName: 'MessageID',
                propertyValue: null,
                stacktrace: StackTrace.current,
              );
            } else {
              rMessageResponse.isWorkInProgress = false;
            }
          } catch (e, stacktrace) {
            return ErrorHandler(
              errorCode: 411001,
              errorDsc:
                  '''Se produjo un error al procesar el mensaje de respuesta del backend.
              Error: ${e.toString()}
              ''',
              messageID: rSendMessageV2.messageID,
              className: _className,
              functionName: functionName,
              propertyName: 'MessageID',
              propertyValue: null,
              stacktrace: stacktrace,
            );
          }
        });
      }
    }
    CommonRPCMessageResponse? rMessageResponse = wRef
        .read(notifierServiceProvider)
        .wssMessagesTrackingV2
        .get(rSendMessageV2.messageID);
    if (rMessageResponse == null) {
      return ErrorHandler(
        errorCode: 400000,
        errorDsc:
            'No pudimos encontrar la referencia al mensaje enviado al backend',
        messageID: rSendMessageV2.messageID,
        className: _className,
        functionName: functionName,
        propertyName: 'MessageID',
        propertyValue: null,
        stacktrace: StackTrace.current,
      );
    }

    /// Solo muestro el "Work In Progress" cuando es debido
    /// En primer instancia solo cuando guardo
    ///
    rMessageResponse.replyWithError = false;
    rMessageResponse.localError = null;
    whileLoop: //
    while (true) {
      if (rMessageResponse.recordOldHash !=
          rMessageResponse.recordNew.hashCode) {
        break;
      } else {
        switch (rMessageResponse.status) {
          case "init":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} is initialized but not sent yet to backend.');
            }
            break;
          case "sent":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} sent to backend. Waiting response from server');
            }
            break;
          case "queued":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} queued for processing. Waiting response from server');
            }
            break;
          case "processing":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} replied from backend. Processing reply received');
            }
            break;
          case "ok":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} proccessed from backend.');
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400001,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: rMessageResponse.messageID,
              className: _className,
              functionName: functionName,
              propertyName: 'Status',
              propertyValue: rMessageResponse.status,
              stacktrace: StackTrace.current,
            );
        }
      }

      /// Wait for [data] to be updated
      ///
      await Future.delayed(const Duration(milliseconds: 100));
      rMessageResponse.timeElapsed += const Duration(milliseconds: 100);

      /// Según sea el caso, aquí habilito mostrar el cuadro de aguardar
      ///
      switch (pActionRequest) {
        case ConstRequests.cancelRequest:
          wRef.read(notifierServiceProvider).updateListeners(
                calledFrom: 'CallRPC:CancelRequest:While',
              );
          break;
        case ConstRequests.saveRequest:
          wRef.read(notifierServiceProvider).updateListeners(
                calledFrom: 'CallRPC:SaveRequest:While',
              );
          break;
        default:
      }
      Duration pRealTimeout = rMessageResponse.timeOut;
      if (rMessageResponse.timeElapsed > pRealTimeout) {
        /// Occurred a TimeOut
        ///
        switch (rMessageResponse.status) {
          case "init":
          case "sent":
          case "queued":
            if (debug) {
              if (debug) {
                developer.log(
                    '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured');
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 4000029999,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: _className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "processing":
            if (debug) {
              if (debug) {
                developer.log(
                    '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured');
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 400009,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: _className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "ok":
            if (debug) {
              developer.log(
                  '$_className - $logLocalFunc - Message ${rMessageResponse.messageID} proccessed from backend.');
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400010,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: rMessageResponse.messageID,
              propertyName: 'Status',
              propertyValue: rMessageResponse.status,
              className: _className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
        }
      }
    } // while(true) loop
    ErrorHandler rFinalResponse = rMessageResponse.finalResponse;
    if (rMessageResponse.status == "ok") {
      if (rMessageResponse.isWorkInProgress) {
        while (true) {
          if (!rMessageResponse.isWorkInProgress) {
            break;
          }
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      await wRef
          .read(notifierServiceProvider)
          .wssMessagesTrackingV2
          .remove(rSendMessageV2.messageID);
    }
    try {
      if (debug) {
        developer.log(
            '$_className - $logLocalFunc - UpdateListeners for Message:${rSendMessageV2.messageID}');
      }
      wRef.read(notifierServiceProvider).updateListeners(
            calledFrom: 'callRPC',
          );
      return rFinalResponse;
    } catch (e, stacktrace) {
      return ErrorHandler(
        errorCode: 999666,
        errorDsc: '''Se produjo un error desconocido.
        Error: ${e.toString()}
        ''',
        stacktrace: stacktrace,
      );
    }
  }

  /// callbackRPC
  Future<ErrorHandler> callbackRPC({
    required bool pFromCallback,
    required String pMessageID,
    required dynamic pParams,
  }) async {
    const String functionName = 'CallbackRPC';
    const String logLocalFunc = '.::$functionName::.';
    CommonDataModelWholeMessage<T> pData;
    CommonRPCMessageResponse? rMessageResponse;
    try {
      rMessageResponse = wRef
          .read(notifierServiceProvider)
          .wssMessagesTrackingV2
          .get(pMessageID);
      if (rMessageResponse == null) {
        return ErrorHandler(
          errorCode: 400003,
          errorDsc:
              'No pudimos encontrar la referencia al mensaje enviado al backend',
          messageID: pMessageID,
          className: _className,
          functionName: functionName,
          propertyName: 'MessageID',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      pData = CommonDataModelWholeMessage<T>.fromJson(
        map: pParams,
        fromJsonFunction: fromJsonFunction,
      );
    } catch (e, stacktrace) {
      developer.log('callBackRPC2: Qué pasó? ${e.toString()}');
      if (debug) {
        developer.log(
            '$_className - $logLocalFunc - Catched error: ${e.toString()}');
      }
      ErrorHandler finalError;
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        finalError = e;
      } else {
        finalError = ErrorHandler(
          errorCode: 400004,
          errorDsc: e.toString(),
          className: _className,
          stacktrace: stacktrace,
        );
      }
      rMessageResponse?.finalResponse = finalError;
      rMessageResponse?.status = 'ok';
      wRef.read(notifierServiceProvider).updateListeners(
            calledFrom: 'CallbackRPC:Catch',
          );
      return finalError;
    }
    developer.log('callBackRPC2: ${pData.toString()}');
    if (pData.errorCode != 0) {
      ErrorHandler stdError = standarizeErrors(pData.errors);
      stdError.errorCode = pData.errorCode;

      /// Si el ErrorCode < 0 entonces no procesamos y dejamos todo tal cual vino
      ///
      if (pData.errorCode > 0) {
        stdError.errorDsc = '${pData.errorDsc}\r\n${stdError.errorDsc}';
      } else {
        stdError.errorDsc = pData.errorDsc;
      }
      rMessageResponse.finalResponse = stdError;
      rMessageResponse.status = 'ok';
      wRef.read(notifierServiceProvider).updateListeners(
            calledFrom: 'CallbackRPC:Error_Code!=0',
          );
      return ErrorHandler(
        errorCode: 0,
        errorDsc: "No error on callback",
      );
    }

    /// We are here. No errors have occurred
    ///
    /// We filter based on status
    ///
    switch (pData.data.status) {
      case "queued":
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Message is queued in server",
        );
      default:
    }
    ErrorHandler finalResponse = ErrorHandler(
      errorCode: 400008,
      errorDsc: 'Respuesta no comprendida en recepción de datos del servicio',
    );

    /// Analizo por cascada
    /// GlobalRequest => LocalRequest => LocalParams->ActionRequest
    ///
    developer.log(
        '.::DEBUG666::. $_className - $logLocalFunc - GlobalRequest: ${pData.data.data.globalRequest} - LocalRequest: ${pData.data.data.localRequest} - ActionRequest: ${pData.data.data.localParams.actionRequest}');
    bool stopProcess = false;
    switch (pData.data.data.globalRequest) {
      case ConstRequests.viewRequest:
        switch (pData.data.data.localRequest) {
          case ConstRequests.viewRequest:

            /// Si ActionRequest = InsertRecord || ChangeRecord || ViewRecord
            /// entonces es un Browse (un DataTable)
            switch (pData.data.data.localParams.actionRequest) {
              case "InsertRecord":
              case "ChangeRecord":
              case "ViewRecord":
                finalResponse = ErrorHandler(
                  errorCode: 0,
                  errorDsc: "",
                  data: pData.data.data.records,
                );
                finalResponse.rawData = pData;
                stopProcess = true;

                break;
              default:
            }
            break;
          default:
        }
        break;
      default:
    }
    if (stopProcess) {
      developer.log(
        '.::DEBUG666::. $_className - $logLocalFunc - StopProcess: ${pData.data.data.globalRequest} - ${pData.data.data.localRequest} - ${pData.data.data.localParams.actionRequest}',
      );
      rMessageResponse.finalResponse = finalResponse;
      rMessageResponse.status = 'ok';
      wRef.read(notifierServiceProvider).updateListeners();
      return ErrorHandler(
        errorCode: 0,
        errorDsc: "No error on callback",
      );
    }
    developer.log(
      '.::DEBUG666::. $_className - $logLocalFunc - StopProcess FUERA: ${pData.data.data.globalRequest} - ${pData.data.data.localRequest} - ${pData.data.data.localParams.actionRequest}',
    );

    /// Esto queda por compatibilidad (por ahora)
    switch (pData.data.data.localParams.actionRequest) {
      case "FilterDataSuspensionDeServicioMasivaByPeriodo":
      case "FilterDataReactivacionDeServicioMasivaByPeriodo":
      case "GenerateBillingFromMassiveProcessByPeriod":
      case "GenerateDetComprobantesPedidosVTFromPerfilVT":
      case "SendMassiveBillingEmails":
        finalResponse = ErrorHandler(
          errorCode: 0,
          errorDsc: "",
          data: pData.data.data.records,
        );
        break;
      case "GenerateAndDownloadPDFFromVoucher":
        var lFiles = pData.data.data.lFiles;
        for (var element in lFiles) {
          var pFile = element;
          pFile.fileNameOnDisk = pFile.metaData.claseCpbte;
          pFile.fileNameOnDisk += '-';
          pFile.fileNameOnDisk +=
              pFile.metaData.nroCpbte.toString().padLeft(6, '0');
          pFile.fileNameOnDisk += '-';
          pFile.fileNameOnDisk += pFile.metaData.tipoCliente;
          pFile.fileNameOnDisk += '-';
          pFile.fileNameOnDisk +=
              pFile.metaData.codClie.toString().padLeft(5, '0');
          pFile.fileNameOnDisk += '.::counter::.';
          pFile.fileNameOnDisk += '.pdf';

          var rSaveOnLocalDisk =
              await wRef.read(notifierServiceProvider).saveFileOnLocalDisk(
                    pFile: pFile,
                    pSubFolder: pFile.metaData.claseCpbte,
                  );
          developer.log('rSaveOnLocalDisk $rSaveOnLocalDisk');
          //if (rSaveOnLocalDisk.errorCode != 0)
        }
        finalResponse = ErrorHandler(
          errorCode: 0,
          errorDsc: "",
          data: pData.data.data,
        );
        break;
      case "ViewRecord":
        finalResponse = ErrorHandler(
          errorCode: 0,
          errorDsc: "",
          data: pData.data.data.records,
        );
        finalResponse.rawData = pData;
        // if (pData.data.data.records.length == 1) {
        //   cEncRecord = pData.data.data.records.first as T;
        //   cEncOriginalRecord = pData.data.data.records.first as T;
        // }
        break;
      case "CancelRecord":
        finalResponse = ErrorHandler(
          errorCode: 0,
          errorDsc: pData.errorDsc,
        );
        break;
      case "SaveRecord":
        finalResponse = ErrorHandler(
          errorCode: 0,
          errorDsc: pData.errorDsc,
        );
        break;
      case "ChangeRecord":
      case "RevertRecord":
        if (pData.data.data.records.isEmpty) {
          finalResponse = ErrorHandler(
            errorCode: 400005,
            errorDsc:
                "Se esperaba encontrar el registro solicitado pero el servidor ha enviado un registro vacío.",
          );
        } else {
          cEncRecord = pData.data.data.records.first as T;
          cEncOriginalRecord = pData.data.data.records.first as T;
          finalResponse = ErrorHandler(
            errorCode: 0,
            errorDsc: "",
          );
          finalResponse.rawData = pData;
        }
        break;
      case "InsertRecord":
        if (pData.data.data.records.isEmpty) {
          finalResponse = ErrorHandler(
            errorCode: 400005,
            errorDsc:
                "Se esperaba encontrar el registro agregado pero el servidor ha enviado un registro vacío.",
          );
        } else {
          cEncRecord = pData.data.data.records.first as T;
          cEncOriginalRecord = pData.data.data.records.first as T;
          finalResponse = ErrorHandler(
            errorCode: 0,
            errorDsc: "",
          );
          finalResponse.rawData = pData;
        }
        break;
      default:
        finalResponse = ErrorHandler(
          errorCode: 400007,
          errorDsc:
              "ActionRequest [${pData.data.data.localParams.actionRequest}] no programada en la respuesta recibida del servidor.",
        );
    }
    rMessageResponse.finalResponse = finalResponse;
    rMessageResponse.status = 'ok';
    wRef.read(notifierServiceProvider).updateListeners();
    return ErrorHandler(
      errorCode: 0,
      errorDsc: "No error on callback",
    );
  }

  /// filterSearchFromDropDown: generic function (could be override) to perform filter
  /// over a DropDown widget.
  ///
  Future<ErrorHandler> filterSearchFromDropDown({
    required GenericModel pParams,
    required T pEnte,
    HeaderParamsRequest? pHeaderParamsRequest,
  }) async {
    String functionName = '$runtimeType';
    try {
      ErrorHandler rCall = await abmCalls(
        pGlobalRequest: pParams.pGlobalRequest,
        pLocalRequest: pParams.pLocalRequest,
        pActionRequest: pParams.pActionRequest,
        pEnte: pEnte,
        pTable: pParams.pTable,
        returnResults: pParams.pReturnResults,
        pLocalParamsRequest: pParams.pLocalParamsRequest,
        pHeaderParamsRequest: pHeaderParamsRequest,
      );
      if (rCall.errorCode != 0) {
        return rCall;
      }
      if (rCall.data is! List<T>) {
        return rCall;
      } else {
        var gg = rCall.data as List<T>;
        if (gg.isNotEmpty) {
          return rCall;
        } else {
          return rCall;
        }
      }
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        return e;
      } else {
        return ErrorHandler(
          errorCode: 998877,
          errorDsc: '<Desconocido>${e.toString()}',
          className: _className,
          functionName: functionName,
          propertyName: '<Desconocida>',
          propertyValue: '<Desconocido>',
          stacktrace: stacktrace,
        );
      }
    }
  }

  List<T> cData = [];
  List<T> selectedData = [];
  List<String> selectedFilter = [];
  String lastSearchTerm = "";
  Map<int, String> columns = {};

  /// Column descriptions to use on DataTable (field description)
  ///
  CommonFieldNames fieldNames = CommonFieldNames();
  List<CommonFieldNamesValues> getColumnFields() {
    fieldNames = cEncRecord.getView(pViewName: 'default');
    return fieldNames.getFieldNames();
  }

  // AdvancedDataTableSource<T>
  //
  /// Columns descriptions to use on DataTables
  ///
  List<String> getColumnFieldDescriptions() {
    const String functionName = "getColumnFieldDescriptions";
    fieldNames = cEncRecord.getView(pViewName: 'default');
    var s = fieldNames.getFieldNames().map((e) => e.value).toList();
    developer.log('$aClassName - $functionName - $s');
    return s;
  }

  @override
  DataRow? getRow(int index) {
    String functionName = "$runtimeType";
    try {
      if (cData.isNotEmpty && index >= cData.length) {
        return null;
      }
      final currentRowData = lastDetails!.rows[index];
      List<DataCell> cells = [];
      var headerColumns = getColumnFields();
      for (var element in headerColumns) {
        switch (element.key) {
          case "NroIDFiscal":
            var mMap = currentRowData.toJson();
            var lData = '';
            var nroDoc = '';
            switch (mMap['NroDoc']) {
              case null:
              case '':
                lData = '<NO ESPECIFICADO>';
                break;
              default:
                var rawDoc = '${mMap['NroDoc']}'.padLeft(8, '0');
                nroDoc = rawDoc.replaceAllMapped(
                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
            }
            var cuit = '';
            switch (mMap['CUIT']) {
              case null:
              case '':
                cuit = '<NO ESPECIFICADO>';
                break;
              default:
                var rawCuit = '${mMap['CUIT']}'.padLeft(11, '0');
                cuit =
                    '${rawCuit.substring(0, 2)}-${rawCuit.substring(2, 10)}-${rawCuit.substring(10)}';
            }
            switch (mMap['CodCatIVA']) {
              case null:
              case '':
                lData = '<NO ESPECIFICADO>';
                break;
              case 'I':
              case 'M':
              case 'E':
                lData = cuit;
                break;
              default:
                lData = nroDoc;
            }
            cells.add(
              DataCell(
                Align(
                  alignment: element.contentAlignment,
                  child: SizedBox(
                    child: Text(
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      //textAlign: TextAlign.center,
                      maxLines: 1,
                      lData,
                    ),
                  ),
                ),
              ),
            );
            break;
          case "DatosDomicilio":
            var mMap = currentRowData.toJson();
            var domicilio = '';
            switch (mMap['Domicilio']) {
              case null:
              case '':
                domicilio = '';
                break;
              default:
                domicilio = '${mMap['Domicilio']}';
            }
            var nroPuerta = '';
            switch (mMap['NroPuerta']) {
              case null:
              case '':
                nroPuerta = '';
                break;
              default:
                nroPuerta = ' Nº ${mMap['NroPuerta']}';
            }
            var piso = '';
            switch (mMap['Piso']) {
              case null:
              case '':
                piso = '';
                break;
              default:
                piso = ' Piso: ${mMap['Piso']}';
            }
            var depto = '';
            switch (mMap['Depto']) {
              case null:
              case '':
                depto = '';
                break;
              default:
                depto = ' Depto: ${mMap['Depto']}';
            }
            var torre = '';
            switch (mMap['Torre']) {
              case null:
              case '':
                torre = '';
                break;
              default:
                torre = ' Torre: ${mMap['Torre']}';
            }
            var sector = '';
            switch (mMap['Sector']) {
              case null:
              case '':
                sector = '';
                break;
              default:
                sector = ' Sector: ${mMap['Sector']}';
            }
            var lData = '$domicilio$nroPuerta$piso$depto$torre$sector';
            cells.add(
              DataCell(
                Align(
                  alignment: element.contentAlignment,
                  child: SizedBox(
                    child: Text(
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      //textAlign: TextAlign.center,
                      maxLines: 1,
                      lData,
                    ),
                  ),
                ),
              ),
            );
            break;
          case "DatosCpbteVT":
            var mMap = currentRowData.toJson();
            var codLetra = '(${mMap['CodLetra']})';
            var nroSucursal = mMap["NroSucursal"].toString().padLeft(5, '0');
            var numero = mMap["Numero"].toString().padLeft(9, '0');
            var lData = '$codLetra-$nroSucursal-$numero';
            cells.add(
              DataCell(
                Align(
                  alignment: element.contentAlignment,
                  child: SizedBox(
                    child: Text(
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      //textAlign: TextAlign.center,
                      maxLines: 1,
                      lData,
                    ),
                  ),
                ),
              ),
            );
            break;
          default:
            currentRowData.toMap().forEach(
              (key, value) {
                if (element.key.toLowerCase() == key.toLowerCase()) {
                  cells.add(
                    DataCell(
                      Align(
                        alignment: element.contentAlignment,
                        child: SizedBox(
                          width: element.width > 0 ? element.width : null,
                          child: Text(
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                            element.getFormattedFieldData(value),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {}
              },
            );
        }
      }
      var ss = selectedData.firstWhereOrNull((e) {
            var kMapSelected = e.getKeyEntity();
            var kMapCurrentRow = currentRowData.getKeyEntity();
            for (final key in kMapSelected.keys) {
              if (key == "LockHash") continue;
              if (kMapSelected[key] != kMapCurrentRow[key]) return false;
            }
            return true;
          }) !=
          null;

      void showContextMenu(
          BuildContext context, Offset position, int rowIndex) {
        // var myElement = headerColumns[rowIndex];

        /// Show context menu on right-click
        ///
        /// Get the current row data
        // bool showCopyToClipboard = false;
        // bool isCopyToClipboardEnabled = false;
        // if (myElement.copyToClipboard != null) {
        //   showCopyToClipboard = true;
        //   isCopyToClipboardEnabled = true;
        // }

        var fields = currentRowData.toJson();
        bool showInsertRecord = true;
        bool isInsertRecordEnabled = true;

        bool showRevertRecord = true;
        bool isRevertRecordEnabled = true;

        bool showChangeRecord = true;
        bool isChangeRecordEnabled = true;

        bool showViewRecord = false;
        bool isViewRecordEnabled = false;

        switch (fields['Estado']) {
          case 'PENDIENTE':
            showRevertRecord = true;
            isRevertRecordEnabled = true;

            showChangeRecord = true;
            isChangeRecordEnabled = true;

            showViewRecord = false;
            isViewRecordEnabled = false;
            break;
          case 'RENDIDO':
            showRevertRecord = false;
            isRevertRecordEnabled = false;

            showChangeRecord = true;
            isChangeRecordEnabled = false;

            showViewRecord = true;
            isViewRecordEnabled = true;
            break;
          case 'ANULADO':
            showRevertRecord = false;
            isRevertRecordEnabled = false;

            showChangeRecord = true;
            isChangeRecordEnabled = false;

            showViewRecord = true;
            isViewRecordEnabled = true;
            break;
          case 'FINALIZADO-ANULADO':
            showRevertRecord = false;
            isRevertRecordEnabled = false;

            showChangeRecord = true;
            isChangeRecordEnabled = false;

            showViewRecord = true;
            isViewRecordEnabled = true;
            break;
          case 'FINALIZADO':
            showRevertRecord = false;
            isRevertRecordEnabled = false;

            showChangeRecord = true;
            isChangeRecordEnabled = false;

            showViewRecord = true;
            isViewRecordEnabled = true;
            break;

          default:
        }
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy,
            position.dx,
            position.dy,
          ),
          items: [
            if (showInsertRecord)
              PopupMenuItem(
                enabled: isInsertRecordEnabled,
                value: 'insert',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Agregar'),
                ),
              ),
            if (showChangeRecord)
              PopupMenuItem(
                enabled: isChangeRecordEnabled,
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Modificar'),
                ),
              ),
            if (showRevertRecord)
              PopupMenuItem(
                enabled: isRevertRecordEnabled,
                value: 'revert',
                child: ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text('Anular'),
                ),
              ),
            if (showViewRecord)
              PopupMenuItem(
                enabled: isViewRecordEnabled,
                value: 'view',
                child: ListTile(
                  leading: Icon(Icons.table_view),
                  title: Text('Ver'),
                ),
              ),
            ...fieldNames.getCopyToClipboardFunctions().keys.map(
              (e) {
                var v = fieldNames.getCopyToClipboardFunctions()[e];
                bool isCopyToClipboardEnabled = false;
                if (v != null) {
                  isCopyToClipboardEnabled = true;
                }
                return PopupMenuItem<CommonFieldNamesValues>(
                  enabled: isCopyToClipboardEnabled,
                  value: e,
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Copiar ${e.value} al portapapeles'),
                  ),
                );
              },
            ),
          ],
        ).then((value) async {
          if (value == 'insert') {
            /// Handle right-click INSERT tap event here
            ///
            notifyListeners();
            if (navigatorKey.currentState != null) {
              await onInsertRecord();
              refreshData(search: lastSearchTerm);
            }
          } else if (value == 'edit') {
            /// Handle right-click EDIT tap event here
            ///
            notifyListeners();
            if (navigatorKey.currentState != null) {
              await onChangeRecord(
                pEnteData: currentRowData,
              );
              refreshData(search: lastSearchTerm);
            }
          } else if (value == 'view') {
            /// Handle right-click VIEW tap event here
            ///
            notifyListeners();
            if (navigatorKey.currentState != null) {
              await onViewRecord(
                pEnteData: currentRowData,
              );
              refreshData(search: lastSearchTerm);
            }
          } else if (value == 'revert') {
            /// Handle right-click REVERT tap event here
            ///
            notifyListeners();
            if (navigatorKey.currentState != null) {
              await onRevertRecord(
                pEnteData: currentRowData,
              );
              refreshData(search: lastSearchTerm);
            }
          } else {
            // Manejo las funciones de Clipboard
            /// Handle right-click COPY TO CLIPBOARD tap event here
            ///

            var fClipboard = fieldNames.getCopyToClipboardFunctions();
            var f = fClipboard[value];
            if (f != null) {
              if (navigatorKey.currentState != null) {
                f(navigatorKey.currentContext!, cData[rowIndex]);
              }
            }
          }
        });
      }

      return DataRow(
        selected: ss,
        onSelectChanged: (isSelected) {
          if (isSelected == null) return;
          int sIndex = selectedData.indexWhere((element) {
            var kMapSelected = element.getKeyEntity();
            var kMapCurrentRow = currentRowData.getKeyEntity();
            for (final key in kMapSelected.keys) {
              if (key == "LockHash") continue;
              if (kMapSelected[key] != kMapCurrentRow[key]) return false;
            }
            return true;
          });
          //int sIndex = selectedData.indexOf(currentRowData);
          if (isSelected) {
            if (sIndex == -1) {
              selectedData.add(currentRowData);
            } else {
              selectedData.removeAt(sIndex);
              //selectedData.remove(currentRowData);
            }
          } else {
            selectedData.removeAt(sIndex);
            //selectedData.remove(currentRowData);
          }
          notifyListeners();
        },
        cells: cells.map((cell) {
          /// Wrap each cell with InkWell and provide an onDoubleTap callback
          return DataCell(
            GestureDetector(
              child: cell.child,
              onDoubleTap: () async {
                /// Handle double tap event here
                ///
                notifyListeners();
                if (navigatorKey.currentState != null) {
                  await onChangeRecord(
                    pEnteData: currentRowData,
                  );
                  refreshData(search: lastSearchTerm);
                }
              },
              onSecondaryTapDown: (details) {
                if (navigatorKey.currentContext != null) {
                  showContextMenu(
                    navigatorKey.currentContext!,
                    details.globalPosition,
                    index,
                  );
                }
              },
            ),
          );
        }).toList(),
      );
    } catch (e, stacktrace) {
      developer.log(
          '.::CATCH::. - Class:$_className: Error: $e - Stacktrace: $stacktrace');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (navigatorKey.currentState != null &&
            navigatorKey.currentState!.mounted) {
          await navigatorKey.currentState?.push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: ErrorHandler(
                errorCode: 8765,
                errorDsc:
                    '''Se produjo un error al obtener los datos de la fila de la tabla.
              El error es ${e.toString()}
              ''',
                stacktrace: stacktrace,
                className: _className,
                functionName: functionName,
              ),
            ),
          );
        }
      });
      return null;
    }
  }

  @override
  int get selectedRowCount => selectedData.length;

  @override
  int get rowCount => cData.length;

  @override
  Future<RemoteDataSourceDetails<T>> getNextPage(
      NextPageRequest pageRequest) async {
    try {
      cData = [];
      //int cDataOldHash = cData.hashCode;
      //isBrowseLoaded = null;
      var pHeaderParamsRequests = HeaderParamsRequest();
      // pHeaderParamsRequests.realGlobalRequest =
      //     ConstRequests.viewRequest.typeId;
      // pHeaderParamsRequests.realLocalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.realGlobalRequest = pGlobalRequest.typeId;
      pHeaderParamsRequests.realLocalRequest = pLocalRequest.typeId;
      pHeaderParamsRequests.globalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.localRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.offset = pageRequest.offset;
      pHeaderParamsRequests.pageSize = pageRequest.pageSize;
      var fields = getColumnFields();
      var fieldName = fields[pageRequest.columnSortIndex ?? 0].key;
      pHeaderParamsRequests.sortField = fieldName;
      pHeaderParamsRequests.sortIndex =
          ((pageRequest.columnSortIndex ?? 0) + 1);
      pHeaderParamsRequests.sortAsc =
          ((pageRequest.sortAscending ?? true) ? true : false);
      pHeaderParamsRequests.search = lastSearchTerm;
      pHeaderParamsRequests.table = cEncRecord.iDefaultTable();

      Map<String, dynamic> pLocalParams = {};
      pLocalParams['ActionRequest'] = 'ViewRecord';
      pLocalParams['Table'] = cEncRecord.iDefaultTable();
      pLocalParams['CodEmp'] = cEmpresa.codEmp;
      // pLocalParams['TipoCliente'] = cEnteCliente.tipoCliente;
      // pLocalParams['CodClie'] = cEnteCliente.codClie;
      pLocalParams['Filters'] = selectedFilter;

      /// Agrego los parámetros del thread
      threadParams.forEach((key, value) {
        pLocalParams[key] = value;
      });

      // pParams['LocalParams'] = pLocalParams;
      // pRequest['pParams'] = pParams;

      pHeaderParamsRequests.localParams = pLocalParams;

      var rReturnResult = await abmCalls(
        pGlobalRequest: ConstRequests.viewRequest,
        pLocalRequest: ConstRequests.viewRequest,
        pActionRequest: ConstRequests.viewRequest,
        pEnte: cEncRecord,
        pHeaderParamsRequest: pHeaderParamsRequests,
        returnResults: true,
      );
      if (rReturnResult.errorCode != 0) {
        developer.log('.::CATCH::. - Class:$_className: Error: $rReturnResult');
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (navigatorKey.currentState != null &&
              navigatorKey.currentState!.mounted) {
            await navigatorKey.currentState?.push(
              ModelGeneralPoPUpErrorMessageDialog(
                error: ErrorHandler(
                  errorCode: rReturnResult.errorCode,
                  errorDsc:
                      'Error en tiempo de ejecución. \r\nError: ${rReturnResult.errorDsc}',
                  stacktrace: rReturnResult.stacktrace,
                ),
              ),
            );
          }
        });
        totalRecords = 0;
        cData = [];
        int filteredRows = 0;
        grandTotals = {};
        notifyListeners();
        return RemoteDataSourceDetails(
          0,
          cData,
          filteredRows: filteredRows,
        );
      } else {
        var rawData = rReturnResult.rawData as CommonDataModelWholeMessage<T>;
        var rawDataData =
            rawData.data.data as CommonDataModelWholeDataDataMessage<T>;
        cData = rawDataData.records;
        int? filteredRows;
        if (cData.isNotEmpty) {
          totalRecords = rawDataData.totalRecords;
          totalFilteredRecords = rawDataData.totalFilteredRecords;
          //totalRecords = cData.length;
        } else {
          totalRecords = 0;
          totalFilteredRecords = 0;
        }
        //filteredRows = lastSearchTerm.isNotEmpty ? totalFilteredRecords : null;
        filteredRows = totalFilteredRecords > 0 ? totalFilteredRecords : null;
        var rS = RemoteDataSourceDetails(
          totalRecords,
          cData,
          filteredRows: filteredRows,
        );
        developer.log('10PREMIER1: $grandTotals');
        grandTotals = rawDataData.grandTotals;
        developer.log('10PREMIER2: $grandTotals');
        developer.log(
            '10PREMIER2 DEBUG666: ${rS.filteredRows} - ${rS.totalRows} ${rS.rows}');
        notifyListeners();
        return rS;
      }
    } catch (e, stacktrace) {
      developer.log('.::CATCH::. - Class:$_className: Error: $e');
      ErrorHandler rError;
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rError = e;
      } else {
        rError = ErrorHandler(
          errorCode: 99999,
          errorDsc: '<desconocido> $e',
          stacktrace: stacktrace,
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (navigatorKey.currentState != null &&
            navigatorKey.currentState!.mounted) {
          await navigatorKey.currentState?.push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: ErrorHandler(
                errorCode: rError.errorCode,
                errorDsc:
                    'Error en tiempo de ejecución. \r\nError: ${rError.errorDsc}',
                stacktrace: rError.stacktrace,
              ),
            ),
          );
        }
      });
      totalRecords = cData.length;
      int? filteredRows =
          lastSearchTerm.isNotEmpty ? totalFilteredRecords : null;
      grandTotals = {};
      notifyListeners();
      return RemoteDataSourceDetails(
        totalRecords,
        cData,
        filteredRows: filteredRows,
      );
    }
  }

  /// refreshData()
  ///
  void refreshData({
    String search = "",
    Function? onComplete,
  }) async {
    // if (onComplete != null) {
    //   callOnGetNextPage = onComplete;
    // }
    filterServerSide(search);
  }

  @override
  void notifyListeners() {
    if (debug) {
      developer.log(
        '$_className - notifyListeners DEBUG_7888',
      );
    }
    super.notifyListeners();
    wRef.read(notifierServiceProvider).updateListeners(
          calledFrom: '$_className - notifyListeners DEBUG_11',
        );
  }
}
