// ignore_for_file: unnecessary_cast
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
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_scope_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_state_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_recovery_expectation_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ComprobantesVT/model.dart';

class BillingFeatureState {
  final String threadHashID;
  final bool isLoading;
  final GenericDataModel<TableComprobantesVTModel>? dataModel;
  final ErrorHandler? error;
  final ServiceProviderFailureBoundaryState? failureBoundaryState;
  final int? trackedClientIndex;

  const BillingFeatureState({
    required this.threadHashID,
    required this.isLoading,
    this.dataModel,
    this.error,
    this.failureBoundaryState,
    this.trackedClientIndex,
  });

  const BillingFeatureState.initial()
      : threadHashID = '',
        isLoading = true,
        dataModel = null,
        error = null,
        failureBoundaryState = null,
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
    ServiceProviderFailureBoundaryState? failureBoundaryState,
    bool clearFailureBoundaryState = false,
    int? trackedClientIndex,
    bool clearTrackedClientIndex = false,
  }) {
    return BillingFeatureState(
      threadHashID: threadHashID ?? this.threadHashID,
      isLoading: isLoading ?? this.isLoading,
      dataModel: clearDataModel ? null : (dataModel ?? this.dataModel),
      error: clearError ? null : (error ?? this.error),
      failureBoundaryState: clearFailureBoundaryState
          ? null
          : (failureBoundaryState ?? this.failureBoundaryState),
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
  final ServiceProviderFailureBoundaryState? failureBoundaryState;

  const BillingLoadResult({
    required this.success,
    required this.threadHashID,
    this.dataModel,
    this.error,
    this.failureBoundaryState,
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
    return ref.read(notifierServiceProvider).activeClientIndex;
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
      clearFailureBoundaryState: true,
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
      clearFailureBoundaryState: true,
      trackedClientIndex: trackedClientIndex,
    );
  }

  BillingFeatureState buildFailureState({
    required BillingFeatureState currentState,
    required String threadHashID,
    required ErrorHandler? error,
    required ServiceProviderFailureBoundaryState? failureBoundaryState,
    required int? trackedClientIndex,
  }) {
    return currentState.copyWith(
      threadHashID: threadHashID,
      isLoading: false,
      error: error,
      failureBoundaryState: failureBoundaryState,
      clearDataModel: true,
      trackedClientIndex: trackedClientIndex,
    );
  }

  ServiceProviderFailureBoundaryState evaluateBillingFailureBoundaryState({
    required dynamic serviceProvider,
    ErrorHandler? error,
  }) {
    const String functionName = 'evaluateBillingFailureBoundaryState';

    if (!serviceProvider.hasAuthenticatedRuntimeContext ||
        serviceProvider.availableClients.isEmpty) {
      return ServiceProviderFailureBoundaryState.authContinuation(
        initStage: serviceProvider.initStage,
        reasonCode: 'billing_missing_authenticated_runtime_context',
        description:
            'Billing cannot continue because authenticated runtime context is not currently valid.',
        className: _className,
        functionName: functionName,
      );
    }

    if (!serviceProvider.hasActiveClientContext ||
        serviceProvider.activeClient == null) {
      return ServiceProviderFailureBoundaryState.activeOperationalContext(
        initStage: serviceProvider.initStage,
        reasonCode: 'billing_missing_active_client_context',
        description:
            'Billing cannot continue because active client context is missing or invalid.',
        recoveryExpectation:
            ServiceProviderFailureRecoveryExpectation.featureReloadAllowed,
        className: _className,
        functionName: functionName,
      );
    }

    if (error != null) {
      return ServiceProviderFailureBoundaryState.featureLocal(
        initStage: serviceProvider.initStage,
        reasonCode: 'billing_feature_load_failed',
        description:
            'Billing request failed after runtime and active client context were already available.',
        recoveryExpectation:
            ServiceProviderFailureRecoveryExpectation.featureReloadAllowed,
        className: _className,
        functionName: functionName,
      );
    }

    return ServiceProviderFailureBoundaryState.none(
      initStage: serviceProvider.initStage,
      reasonCode: 'billing_boundary_clear',
      description:
          'Billing boundary is clear because runtime and active client context are available.',
      className: _className,
      functionName: functionName,
    );
  }

  Future<BillingFeatureState> reloadBillingState({
    required WidgetRef ref,
    required BillingFeatureState currentState,
    required String billingType,
    required ConstRequests globalRequest,
    required ConstRequests localRequest,
    required bool debug,
    required int currentPage,
    required int rowsPerPage,
  }) async {
    final currentClientIndex = resolveCurrentClientIndex(ref: ref);

    final result = await loadBillingData(
      ref: ref,
      threadHashID: currentState.threadHashID,
      billingType: billingType,
      globalRequest: globalRequest,
      localRequest: localRequest,
      debug: debug,
      currentPage: currentPage,
      rowsPerPage: rowsPerPage,
    );

    if (!result.success) {
      return buildFailureState(
        currentState: currentState,
        threadHashID: result.threadHashID,
        error: result.error,
        failureBoundaryState: result.failureBoundaryState,
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

  int resolveTotalItems({
    required GenericDataModel<TableComprobantesVTModel> dataModel,
  }) {
    if (dataModel.totalFilteredRecords > 0) {
      return dataModel.totalFilteredRecords;
    }

    if (dataModel.totalRecords > 0) {
      return dataModel.totalRecords;
    }

    return dataModel.cData.length;
  }

  bool hasRows({
    required BillingFeatureState state,
  }) {
    return state.isReady &&
        state.dataModel != null &&
        state.dataModel!.cData.isNotEmpty;
  }

  bool isEmptyState({
    required BillingFeatureState state,
  }) {
    return state.isReady &&
        state.dataModel != null &&
        state.dataModel!.cData.isEmpty;
  }

  String resolveBillingCollectionLabel({
    required String billingType,
  }) {
    switch (billingType) {
      case 'FacturasVT':
        return 'facturas';
      case 'RecibosVT':
        return 'recibos';
      case 'DebitosVT':
        return 'notas de débito';
      case 'CreditosVT':
        return 'notas de crédito';
      default:
        return 'comprobantes';
    }
  }

  String resolveBillingHeaderTitle({
    required String billingType,
  }) {
    switch (billingType) {
      case 'FacturasVT':
        return 'Facturas';
      case 'RecibosVT':
        return 'Recibos';
      case 'DebitosVT':
        return 'Notas de débito';
      case 'CreditosVT':
        return 'Notas de crédito';
      default:
        return 'Comprobantes';
    }
  }

  String resolveBillingHeaderSubtitle({
    required String billingType,
  }) {
    switch (billingType) {
      case 'FacturasVT':
        return 'Consultá y descargá las facturas disponibles del cliente activo.';
      case 'RecibosVT':
        return 'Consultá y descargá los recibos disponibles del cliente activo.';
      case 'DebitosVT':
        return 'Consultá y descargá las notas de débito disponibles del cliente activo.';
      case 'CreditosVT':
        return 'Consultá y descargá las notas de crédito disponibles del cliente activo.';
      default:
        return 'Consultá y descargá los comprobantes disponibles del cliente activo.';
    }
  }

  String resolveBillingLoadingText({
    required String billingType,
  }) {
    final label = resolveBillingCollectionLabel(
      billingType: billingType,
    );
    return 'Cargando $label...';
  }

  String resolveBillingErrorTitle({
    required String billingType,
    required BillingFeatureState state,
  }) {
    final label = resolveBillingCollectionLabel(
      billingType: billingType,
    );

    switch (state.failureBoundaryState?.scope) {
      case ServiceProviderFailureBoundaryScope.authContinuation:
        return 'Necesitás volver a validar tu sesión';
      case ServiceProviderFailureBoundaryScope.activeOperationalContext:
        return 'No pudimos resolver el cliente activo';
      case ServiceProviderFailureBoundaryScope.featureLocal:
      case ServiceProviderFailureBoundaryScope.backendRequest:
      case ServiceProviderFailureBoundaryScope.transport:
        return 'No pudimos cargar los $label';
      case ServiceProviderFailureBoundaryScope.none:
      case ServiceProviderFailureBoundaryScope.runtimeGlobal:
      case ServiceProviderFailureBoundaryScope.startupBoundary:
      case null:
        return 'No pudimos cargar los $label';
    }
  }

  String resolveBillingErrorMessage({
    required String billingType,
    required BillingFeatureState state,
  }) {
    final rawMessage = state.error?.errorDsc?.trim();
    if (rawMessage != null && rawMessage.isNotEmpty) {
      return rawMessage;
    }

    switch (state.failureBoundaryState?.scope) {
      case ServiceProviderFailureBoundaryScope.authContinuation:
        return 'La sesión actual no está lista para consultar esta sección. Intentá nuevamente.';
      case ServiceProviderFailureBoundaryScope.activeOperationalContext:
        return 'No se encontró un cliente activo válido para consultar esta sección. Probá actualizar nuevamente.';
      case ServiceProviderFailureBoundaryScope.featureLocal:
      case ServiceProviderFailureBoundaryScope.backendRequest:
      case ServiceProviderFailureBoundaryScope.transport:
      case ServiceProviderFailureBoundaryScope.none:
      case ServiceProviderFailureBoundaryScope.runtimeGlobal:
      case ServiceProviderFailureBoundaryScope.startupBoundary:
      case null:
        final label = resolveBillingCollectionLabel(
          billingType: billingType,
        );
        return 'Ocurrió un problema al cargar los $label. Probá nuevamente.';
    }
  }

  String resolveBillingEmptyTitle({
    required String billingType,
  }) {
    final label = resolveBillingCollectionLabel(
      billingType: billingType,
    );
    return 'No hay $label disponibles';
  }

  String resolveBillingEmptyMessage({
    required String billingType,
  }) {
    switch (billingType) {
      case 'FacturasVT':
        return 'No encontramos facturas para el cliente activo en este momento.';
      case 'RecibosVT':
        return 'No encontramos recibos para el cliente activo en este momento.';
      case 'DebitosVT':
        return 'No encontramos notas de débito para el cliente activo en este momento.';
      case 'CreditosVT':
        return 'No encontramos notas de crédito para el cliente activo en este momento.';
      default:
        return 'No encontramos comprobantes para el cliente activo en este momento.';
    }
  }

  Future<BillingLoadResult> loadBillingData({
    required WidgetRef ref,
    required String threadHashID,
    required String billingType,
    required ConstRequests globalRequest,
    required ConstRequests localRequest,
    required bool debug,
    required int currentPage,
    required int rowsPerPage,
  }) async {
    const String functionName = 'loadBillingData';
    final String logFunctionName = '$_logClassName.$functionName';

    try {
      final serviceProvider = ref.read(notifierServiceProvider);
      final resolvedThreadHashID =
          threadHashID.isEmpty ? generateRandomUniqueHash() : threadHashID;

      if (!serviceProvider.hasAuthenticatedRuntimeContext ||
          serviceProvider.availableClients.isEmpty) {
        final error = ErrorHandler(
          errorCode: 99999,
          errorDsc:
              'No se encontró un usuario logueado válido para cargar comprobantes.',
          className: _className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );

        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: error,
          failureBoundaryState: evaluateBillingFailureBoundaryState(
            serviceProvider: serviceProvider,
            error: error,
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
      tEnteDataModel.cEmpresa =
          serviceProvider.activeCompany ?? serviceProvider.cEmpresa;
      tEnteDataModel.cEncRecord = TableComprobantesVTModel.fromDefault(
        pEmpresa: tEnteDataModel.cEmpresa,
      );
      tEnteDataModel.fromJsonFunction = TableComprobantesVTModel.fromJson;

      final int safeCurrentPage = currentPage < 1 ? 1 : currentPage;
      final int safeRowsPerPage = rowsPerPage < 1 ? 10 : rowsPerPage;
      final int resolvedOffset = (safeCurrentPage - 1) * safeRowsPerPage;

      pHeaderParamsRequests.realGlobalRequest = globalRequest.typeId;
      pHeaderParamsRequests.realLocalRequest = localRequest.typeId;
      pHeaderParamsRequests.globalRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.localRequest = ConstRequests.viewRequest.typeId;
      pHeaderParamsRequests.offset = resolvedOffset;
      pHeaderParamsRequests.pageSize = safeRowsPerPage;
      pHeaderParamsRequests.sortField = 'FechaCpbte';
      pHeaderParamsRequests.sortIndex = 0;
      pHeaderParamsRequests.sortAsc = false;
      pHeaderParamsRequests.search = "";
      pHeaderParamsRequests.table = tEnteDataModel.cEncRecord.iDefaultTable();

      final currentClient = serviceProvider.activeClient;

      if (currentClient == null) {
        final error = ErrorHandler(
          errorCode: 99999,
          errorDsc:
              'No se encontró un cliente activo válido para cargar comprobantes.',
          className: _className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );

        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: error,
          failureBoundaryState: evaluateBillingFailureBoundaryState(
            serviceProvider: serviceProvider,
            error: error,
          ),
        );
      }

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
          failureBoundaryState: evaluateBillingFailureBoundaryState(
            serviceProvider: serviceProvider,
            error: rFilteredRecords,
          ),
        );
      }

      if (rFilteredRecords.rawData
          is! CommonDataModelWholeMessage<TableComprobantesVTModel>) {
        final error = ErrorHandler(
          errorCode: 99999,
          errorDsc: '''Error al obtener los datos de los comprobantes
Esperado un CommonDataModelWholeMessage<TableComprobantesVTModel>
pero se obtuvo: ${rFilteredRecords.rawData.runtimeType}
''',
          className: _className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: error,
          failureBoundaryState: evaluateBillingFailureBoundaryState(
            serviceProvider: serviceProvider,
            error: error,
          ),
        );
      }

      final rReturnedRawData = rFilteredRecords.rawData
          as CommonDataModelWholeMessage<TableComprobantesVTModel>;

      if (rReturnedRawData.data
          is! CommonDataModelWholeDataMessage<TableComprobantesVTModel>) {
        final error = ErrorHandler(
          errorCode: 99999,
          errorDsc: '''Error al obtener los datos de los comprobantes
Esperado un CommonDataModelWholeDataMessage<TableComprobantesVTModel>
pero se obtuvo: ${rReturnedRawData.data.runtimeType}
''',
          className: _className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
        return BillingLoadResult(
          success: false,
          threadHashID: resolvedThreadHashID,
          error: error,
          failureBoundaryState: evaluateBillingFailureBoundaryState(
            serviceProvider: serviceProvider,
            error: error,
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
      final normalizedError = e is ErrorHandler
          ? e
          : ErrorHandler(
              errorCode: 99999,
              errorDsc: '''Se produjo un error al cargar comprobantes.
Error: ${e.toString()}
''',
              className: _className,
              functionName: functionName,
              stacktrace: stacktrace,
            );
      return BillingLoadResult(
        success: false,
        threadHashID:
            threadHashID.isEmpty ? generateRandomUniqueHash() : threadHashID,
        error: normalizedError,
        failureBoundaryState: evaluateBillingFailureBoundaryState(
          serviceProvider: ref.read(notifierServiceProvider),
          error: normalizedError,
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
