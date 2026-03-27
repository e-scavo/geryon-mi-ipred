/// ignore_for_file: unnecessary_cast

import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/header_request.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ComprobantesVT/model.dart';

class BillingFeatureState {
  final String threadHashID;
  final bool isLoading;
  final GenericDataModel<TableComprobantesVTModel>? dataModel;
  final ErrorHandler? error;
  final int? trackedClientIndex;

  const BillingFeatureState({
    required this.threadHashID,
    required this.isLoading,
    this.dataModel,
    this.error,
    this.trackedClientIndex,
  });

  const BillingFeatureState.initial()
      : threadHashID = '',
        isLoading = true,
        dataModel = null,
        error = null,
        trackedClientIndex = null;

  bool get hasError => error != null;

  bool get isReady => !isLoading && error == null && dataModel != null;

  BillingFeatureState copyWith({
    String? threadHashID,
    bool? isLoading,
    GenericDataModel<TableComprobantesVTModel>? dataModel,
    bool clearDataModel = false,
    ErrorHandler? error,
    bool clearError = false,
    int? trackedClientIndex,
    bool clearTrackedClientIndex = false,
  }) {
    return BillingFeatureState(
      threadHashID: threadHashID ?? this.threadHashID,
      isLoading: isLoading ?? this.isLoading,
      dataModel: clearDataModel ? null : (dataModel ?? this.dataModel),
      error: clearError ? null : (error ?? this.error),
      trackedClientIndex: clearTrackedClientIndex
          ? null
          : (trackedClientIndex ?? this.trackedClientIndex),
    );
  }
}

class BillingLoadResult {
  final bool success;
  final String threadHashID;
  final GenericDataModel<TableComprobantesVTModel>? dataModel;
  final ErrorHandler? error;

  const BillingLoadResult({
    required this.success,
    required this.threadHashID,
    this.dataModel,
    this.error,
  });
}

class BillingController {
  static const String _className = 'BillingController';
  static const String _logClassName = '.::$_className::.';

  BillingFeatureState buildInitialState() {
    return const BillingFeatureState.initial();
  }

  int? resolveCurrentClientIndex({
    required WidgetRef ref,
  }) {
    return ref.read(notifierServiceProvider).loggedUser?.cCliente;
  }

  bool shouldBootstrap({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex == null && currentClientIndex != null;
  }

  bool shouldReloadForClientChange({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex != null &&
        state.trackedClientIndex != currentClientIndex;
  }

  BillingFeatureState buildLoadingState({
    required BillingFeatureState currentState,
    required int? trackedClientIndex,
  }) {
    return currentState.copyWith(
      isLoading: true,
      clearError: true,
      trackedClientIndex: trackedClientIndex,
    );
  }

  BillingFeatureState buildSuccessState({
    required BillingFeatureState currentState,
    required String threadHashID,
    required GenericDataModel<TableComprobantesVTModel> dataModel,
    required int? trackedClientIndex,
  }) {
    return currentState.copyWith(
      threadHashID: threadHashID,
      isLoading: false,
      dataModel: dataModel,
      clearError: true,
      trackedClientIndex: trackedClientIndex,
    );
  }

  BillingFeatureState buildFailureState({
    required BillingFeatureState currentState,
    required String threadHashID,
    required ErrorHandler? error,
    required int? trackedClientIndex,
  }) {
    return currentState.copyWith(
      threadHashID: threadHashID,
      isLoading: false,
      error: error,
      clearDataModel: true,
      trackedClientIndex: trackedClientIndex,
    );
  }

  Future<BillingFeatureState> reloadBillingState({
    required WidgetRef ref,
    required BillingFeatureState currentState,
    required String billingType,
    required ConstRequests globalRequest,
    required ConstRequests localRequest,
    required bool debug,
  }) async {
    final currentClientIndex = resolveCurrentClientIndex(ref: ref);

    final result = await loadBillingData(
      ref: ref,
      threadHashID: currentState.threadHashID,
      billingType: billingType,
      globalRequest: globalRequest,
      localRequest: localRequest,
      debug: debug,
    );

    if (!result.success) {
      return buildFailureState(
        currentState: currentState,
        threadHashID: result.threadHashID,
        error: result.error,
        trackedClientIndex: currentClientIndex,
      );
    }

    return buildSuccessState(
      currentState: currentState,
      threadHashID: result.threadHashID,
      dataModel: result.dataModel!,
      trackedClientIndex: currentClientIndex,
    );
  }

  Future<BillingLoadResult> loadBillingData({
    required WidgetRef ref,
    required String threadHashID,
    required String billingType,
    required ConstRequests globalRequest,
    required ConstRequests localRequest,
    required bool debug,
  }) async {
    const String functionName = 'loadBillingData';
    final String logFunctionName = '$_logClassName.$functionName';

    try {
      final serviceProvider = ref.read(notifierServiceProvider);
      final resolvedThreadHashID =
          threadHashID.isEmpty ? generateRandomUniqueHash() : threadHashID;

      if (serviceProvider.loggedUser == null ||
          serviceProvider.loggedUser!.clientes.isEmpty) {
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: ErrorHandler(
            errorCode: 99999,
            errorDsc:
                'No se encontró un usuario logueado válido para cargar comprobantes.',
            className: _className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          ),
        );
      }

      await serviceProvider.mapThreadsToDataModels.set(
        key: resolvedThreadHashID,
        value: GenericDataModel<TableComprobantesVTModel>(
          wRef: ref,
          debug: debug,
          threadID: resolvedThreadHashID,
        ),
      );

      final tEnteDataModel =
          serviceProvider.mapThreadsToDataModels.get(resolvedThreadHashID)
              as GenericDataModel<TableComprobantesVTModel>;

      final pHeaderParamsRequests = HeaderParamsRequest();

      tEnteDataModel.pGlobalRequest = globalRequest;
      tEnteDataModel.pLocalRequest = localRequest;
      tEnteDataModel.cEmpresa = serviceProvider.cEmpresa;
      tEnteDataModel.cEncRecord = TableComprobantesVTModel.fromDefault(
        pEmpresa: tEnteDataModel.cEmpresa,
      );
      tEnteDataModel.fromJsonFunction = TableComprobantesVTModel.fromJson;

      pHeaderParamsRequests.realGlobalRequest = globalRequest.typeId;
      pHeaderParamsRequests.realLocalRequest = localRequest.typeId;
      pHeaderParamsRequests.globalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.localRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.offset = 0;
      pHeaderParamsRequests.pageSize = 0;
      pHeaderParamsRequests.sortField = 'FechaCpbte';
      pHeaderParamsRequests.sortIndex = 0;
      pHeaderParamsRequests.sortAsc = false;
      pHeaderParamsRequests.search = "";
      pHeaderParamsRequests.table = tEnteDataModel.cEncRecord.iDefaultTable();

      final currentClient = serviceProvider
          .loggedUser!.clientes[serviceProvider.loggedUser!.cCliente];

      tEnteDataModel.threadParams = {
        'DBVersion': 2,
        'SelectBy': 'KeyCliente',
        'CodEmp': tEnteDataModel.cEmpresa.codEmp,
        'TipoCliente': currentClient.tipoCliente,
        'CodClie': currentClient.codClie,
        'ClaseCpbte': billingType,
        'ClaseCpbteVT': billingType,
        'IsEmpresaAggregated': true,
      };

      developer.log(
        'threadParams: ${tEnteDataModel.threadParams}',
        name: logFunctionName,
      );

      final Map<String, dynamic> pLocalParams =
          Map<String, dynamic>.from(tEnteDataModel.threadParams);
      pLocalParams['ActionRequest'] = 'ViewRecord';
      pLocalParams['Table'] = tEnteDataModel.cEncRecord.iDefaultTable();

      final pGenericParams = GenericModel.fromDefault();
      pGenericParams.pTable = tEnteDataModel.cEncRecord.iDefaultTable();
      pGenericParams.pLocalParamsRequest = pLocalParams;

      pHeaderParamsRequests.localParams = pLocalParams;

      final rFilteredRecords = await tEnteDataModel.filterSearchFromDropDown(
        pParams: pGenericParams,
        pEnte: tEnteDataModel.cEncRecord,
        pHeaderParamsRequest: pHeaderParamsRequests,
      );

      if (rFilteredRecords.errorCode != 0) {
        developer.log(
          'Error al obtener comprobantes: ${rFilteredRecords.errorDsc}',
          name: logFunctionName,
        );
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: rFilteredRecords,
        );
      }

      if (rFilteredRecords.rawData
          is! CommonDataModelWholeMessage<TableComprobantesVTModel>) {
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: ErrorHandler(
            errorCode: 99999,
            errorDsc: '''Error al obtener los datos de los comprobantes
Esperado un CommonDataModelWholeMessage<TableComprobantesVTModel>
pero se obtuvo: ${rFilteredRecords.rawData.runtimeType}
''',
            className: _className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          ),
        );
      }

      final rReturnedRawData = rFilteredRecords.rawData
          as CommonDataModelWholeMessage<TableComprobantesVTModel>;

      if (rReturnedRawData.data
          is! CommonDataModelWholeDataMessage<TableComprobantesVTModel>) {
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: ErrorHandler(
            errorCode: 99999,
            errorDsc: '''Error al obtener los datos de los comprobantes
Esperado un CommonDataModelWholeDataMessage<TableComprobantesVTModel>
pero se obtuvo: ${rReturnedRawData.data.runtimeType}
''',
            className: _className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          ),
        );
      }

      final rReturnedRawDataData = rReturnedRawData.data
          as CommonDataModelWholeDataMessage<TableComprobantesVTModel>;

      tEnteDataModel.cData = rReturnedRawDataData.data.records;
      tEnteDataModel.totalRecords = rReturnedRawDataData.data.totalRecords;
      tEnteDataModel.totalFilteredRecords =
          rReturnedRawDataData.data.totalFilteredRecords;

      developer.log(
        'Datos cargados correctamente: ${tEnteDataModel.cData.length} registros',
        name: logFunctionName,
      );

      return BillingLoadResult(
        success: true,
        threadHashID: resolvedThreadHashID,
        dataModel: tEnteDataModel,
      );
    } catch (e, stacktrace) {
      developer.log(
        'CATCHED: $e',
        name: logFunctionName,
      );
      return BillingLoadResult(
        success: false,
        threadHashID: threadHashID,
        error: ErrorHandler(
          errorCode: 99999,
          errorDsc: '''Se produjo un error al cargar comprobantes.
Error: ${e.toString()}
''',
          className: _className,
          functionName: functionName,
          stacktrace: stacktrace,
        ),
      );
    }
  }

  List<Map<String, dynamic>> buildTableRows({
    required GenericDataModel<TableComprobantesVTModel> dataModel,
  }) {
    return dataModel.cData
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
}
