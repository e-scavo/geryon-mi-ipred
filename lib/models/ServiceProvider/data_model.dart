import 'dart:convert';
import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_continuation_result_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/auth_requirement_model.dart';
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/features/auth/presentation/login_widget.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/GeneralLoadingProgress/popup_model.dart';
import 'package:geryon_web_app_ws_v2/core/transport/geryonsocket_model.dart';
import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';
import 'package:geryon_web_app_ws_v2/models/Login/model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/channel_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/whole_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/StandarizeErrors/model.dart';
import 'package:geryon_web_app_ws_v2/models/SynchronizedMapThreadsToDataModelCRUD/model.dart';
import 'package:geryon_web_app_ws_v2/models/SynchronizedMapV2CRUD/model.dart';
import 'package:geryon_web_app_ws_v2/models/app_version_model.dart';
import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
//import 'package:geryon_web_app_ws_v2/services/websocket_client.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';
import 'package:geryon_web_app_ws_v2/core/files/file_saver.dart';

class _PreparedTrackedMessageResult {
  final CommonRPCMessageResponse? messageResponse;
  final ErrorHandler? error;

  const _PreparedTrackedMessageResult._({
    required this.messageResponse,
    required this.error,
  });

  factory _PreparedTrackedMessageResult.success(
    CommonRPCMessageResponse messageResponse,
  ) {
    return _PreparedTrackedMessageResult._(
      messageResponse: messageResponse,
      error: null,
    );
  }

  factory _PreparedTrackedMessageResult.failure(
    ErrorHandler error,
  ) {
    return _PreparedTrackedMessageResult._(
      messageResponse: null,
      error: error,
    );
  }

  bool get hasError => error != null;
}

class ServiceProvider extends ChangeNotifier {
  static final String className = "ServiceProvider";
  static final String logClassName = '.::$className::.';

  final String wssURI;
  final bool debug;
  final int connMaxRetry = 5;
  TableEmpresaModel cEmpresa = TableEmpresaModel.fromDefault();

  final wssMessagesTrackingV2 =
      SynchronizedMapV2CRUD<String, CommonRPCMessageResponse>();
  final mapThreadsToDataModels =
      SynchronizedMapThreadsToDataModelCRUD<String, dynamic>();

  int connRetry = 0;
  bool isUserLoggedIn = false;
  bool isProgress = false;
  ErrorHandler? lastError;
  late WebSocketClient wssClient;
  late bool isNew;
  late String sessionTokenID;
  late bool isReady;
  late int maxConnRetry;
  late ServiceProviderInitStages initStage;
  late String? initStageAdditionalMsg;
  late ErrorHandler? initStageError;
  late bool canRetry;
  late List<ServiceProviderChannel> channels;

  late ServiceProviderLoginDataUserMessageModel? loggedUser;

  ServiceProvider({
    required this.wssURI,
    this.debug = false,
  }) {
    // Initialize the WebSocket client
    wssClient = WebSocketClient(
      wssURI: wssURI,
      listenCallbackOnData: _onData,
      listenCallbackOnError: _onError,
      listenCallbackOnDone: _onDone,
      debug: debug,
    );
    isNew = true;
    sessionTokenID = '';
    isReady = false;
    maxConnRetry = 5;
    initStage = ServiceProviderInitStages.init;
    initStageAdditionalMsg = '';
    initStageError = ErrorHandler(byDefault: true);
    canRetry = false;
    channels = [
      ServiceProviderChannel(name: 'GERYON_General'),
      ServiceProviderChannel(name: 'GERYON_General_SCRUD'),
      //ServiceProviderChannel(name: 'GERYON_Customers'),
    ];
    loggedUser = null;
    cEmpresa = TableEmpresaModel.fromDefault();
    developer.log(
      '=> Creando un nuevo PROVEEDOR con wssURI $wssURI',
      name: logClassName,
    );
    updateListeners(
      calledFrom: 'Constructor',
    );
  }
  void _resetAuthenticatedRuntimeState({
    bool clearLoggedUser = true,
    bool notify = false,
    String calledFrom = '',
  }) {
    isUserLoggedIn = false;
    if (clearLoggedUser) {
      loggedUser = null;
    }
    cEmpresa = TableEmpresaModel.fromDefault();

    if (notify) {
      updateListeners(calledFrom: calledFrom);
    }
  }

  void _applyAuthenticatedUserContext({
    required ServiceProviderLoginDataUserMessageModel user,
    bool notify = false,
    String calledFrom = '',
  }) {
    loggedUser = user;
    cEmpresa = TableEmpresaModel.fromKey(
      pCodEmp: loggedUser!.codEmp,
      pRazonSocial: loggedUser!.razonSocial,
      pEnvironment: "Unknown",
    );
    isUserLoggedIn = true;

    if (notify) {
      updateListeners(calledFrom: calledFrom);
    }
  }

  bool get hasAuthenticatedRuntimeContext => loggedUser != null;

  ServiceProviderLoginDataUserMessageModel? get authenticatedUser => loggedUser;

  ServiceProviderAuthRequirement evaluateAuthRequirement() {
    if (loggedUser == null) {
      return ServiceProviderAuthRequirement.loginRequiredNoRememberedUser(
        className: className,
        functionName: 'evaluateAuthRequirement',
      );
    }

    return ServiceProviderAuthRequirement.loginRequiredFromRememberedUser(
      className: className,
      functionName: 'evaluateAuthRequirement',
    );
  }

  ErrorHandler _toLegacyAuthRequirementError(
    ServiceProviderAuthRequirement requirement,
  ) {
    return requirement.toLegacyErrorHandler();
  }

  ServiceProviderStartupAuthContinuationCoordinatorState
      evaluateStartupAuthContinuationCoordinatorState({
    ServiceProvider? previousState,
  }) {
    if (isReady && !isProgress && isUserLoggedIn) {
      return ServiceProviderStartupAuthContinuationCoordinatorState
          .authenticatedContinuationResolved(
        initStage: initStage,
      );
    }

    if (initStage == ServiceProviderInitStages.checkingLoginStatus ||
        initStage == ServiceProviderInitStages.userIsNotloggedIn) {
      return ServiceProviderStartupAuthContinuationCoordinatorState
          .waitingForInteractiveLogin(
        initStage: initStage,
      );
    }

    if (initStage == ServiceProviderInitStages.errorConnecting ||
        initStage == ServiceProviderInitStages.errorReConnecting ||
        initStage == ServiceProviderInitStages.errorCheckingStatus ||
        initStage == ServiceProviderInitStages.errorCheckingLoginStatus ||
        initStage == ServiceProviderInitStages.errorRequestingBackend ||
        initStage == ServiceProviderInitStages.errorOnHighSeverity ||
        canRetry) {
      return ServiceProviderStartupAuthContinuationCoordinatorState
          .blockedByError(
        initStage: initStage,
        description:
            'Startup/auth continuation is blocked by the current runtime error state.',
      );
    }

    final bool websocketEndpointChanged =
        previousState != null && wssURI != previousState.wssURI;
    final bool connectionDroppedOutsideExplicitError = previousState != null &&
        previousState.initStage != ServiceProviderInitStages.disconnected &&
        initStage == ServiceProviderInitStages.disconnected;

    if (!isReady &&
        (websocketEndpointChanged || connectionDroppedOutsideExplicitError)) {
      return ServiceProviderStartupAuthContinuationCoordinatorState
          .retryRequired(
        initStage: initStage,
      );
    }

    return ServiceProviderStartupAuthContinuationCoordinatorState
        .waitingForInitialization(
      initStage: initStage,
    );
  }

  int? get activeClientIndex {
    if (loggedUser == null) {
      return null;
    }

    return loggedUser!.cCliente;
  }

  List<ServiceProviderLoginDataUserMessageModel> get availableClients {
    if (loggedUser == null) {
      return const <ServiceProviderLoginDataUserMessageModel>[];
    }

    return List<ServiceProviderLoginDataUserMessageModel>.unmodifiable(
      loggedUser!.clientes,
    );
  }

  bool get hasActiveClientContext {
    final index = activeClientIndex;

    return index != null && index >= 0 && index < availableClients.length;
  }

  ServiceProviderLoginDataUserMessageModel? get activeClient {
    final index = activeClientIndex;

    if (index == null) {
      return null;
    }

    if (index < 0 || index >= availableClients.length) {
      return null;
    }

    return availableClients[index];
  }

  TableEmpresaModel? get activeCompany {
    if (cEmpresa.codEmp <= 0) {
      return null;
    }

    return cEmpresa;
  }

  bool _isHandshakeMessage(ServiceProviderWholeMessageModel message) {
    return message.data.isNew;
  }

  ErrorHandler? _validateHandshakeToken({
    required String tokenID,
    required String functionName,
  }) {
    if (tokenID.isEmpty) {
      return ErrorHandler(
        errorCode: 10002,
        errorDsc: '''Error #10001. 
              Couldn't get communication private id from backend. 
              Please try again later or contact support is the issue continues.
              ''',
        propertyName: 'TokenID',
        propertyValue: '',
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    return null;
  }

  void _applySessionToken({
    required String tokenID,
  }) {
    sessionTokenID = tokenID;
    isNew = false;
  }

  Future<ErrorHandler?> _continueInitializationAfterHandshake({
    required String functionName,
  }) async {
    ErrorHandler rSubscribe = await subscribeChannel();
    if (rSubscribe.errorCode != 0) {
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageError = rSubscribe;
      isReady = false;
      isProgress = false;
      updateListeners(calledFrom: functionName);
      return rSubscribe;
    }

    return await init();
  }

  ErrorHandler _buildTrackedMessageNotFoundError({
    required String messageID,
    required String functionName,
  }) {
    return ErrorHandler(
      errorCode: 400000,
      errorDsc:
          'No pudimos encontrar la referencia al mensaje enviado al backend',
      messageID: messageID,
      className: className,
      functionName: functionName,
      propertyName: 'MessageID',
      propertyValue: null,
      stacktrace: StackTrace.current,
    );
  }

  void _prepareTrackedMessageForWaiting(
    CommonRPCMessageResponse messageResponse,
  ) {
    messageResponse.replyWithError = false;
    messageResponse.localError = null;
  }

  Future<ErrorHandler?> _waitForTrackedMessageCompletion({
    required CommonRPCMessageResponse messageResponse,
    required String functionName,
    required String logFunctionName,
    bool inclusiveTimeout = true,
  }) async {
    whileLoop:
    while (true) {
      if (messageResponse.recordOldHash != messageResponse.recordNew.hashCode) {
        break;
      } else {
        switch (messageResponse.status) {
          case "init":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${messageResponse.messageID} is initialized but not sent yet to backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "sent":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${messageResponse.messageID} sent to backend. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "queued":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${messageResponse.messageID} queued for processing. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "processing":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${messageResponse.messageID} replied from backend. Processing reply received',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "ok":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${messageResponse.messageID} processed from backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400001,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: messageResponse.messageID,
              className: className,
              functionName: functionName,
              propertyName: 'Status',
              propertyValue: messageResponse.status,
              stacktrace: StackTrace.current,
            );
        }
      }

      await Future.delayed(const Duration(milliseconds: 100));
      messageResponse.timeElapsed += const Duration(milliseconds: 100);
      final Duration pRealTimeout = messageResponse.timeOut;

      final bool didTimeout = inclusiveTimeout
          ? messageResponse.timeElapsed >= pRealTimeout
          : messageResponse.timeElapsed > pRealTimeout;

      if (didTimeout) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowLeft} Message ${messageResponse.messageID} timed out after ${pRealTimeout.inSeconds} seconds.',
            name: '$logClassName - $logFunctionName',
          );
        }

        switch (messageResponse.status) {
          case "init":
          case "sent":
          case "queued":
            if (debug) {
              developer.log(
                'Message ${messageResponse.messageID} is [${messageResponse.status}] but a timeout occured',
                name: '$logClassName - $logFunctionName',
              );
            }
            messageResponse.localError = ErrorHandler(
              errorCode: 4000029999,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${messageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: messageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "processing":
            if (debug) {
              developer.log(
                'Message ${messageResponse.messageID} is [${messageResponse.status}] but a timeout occured',
                name: '$logClassName - $logFunctionName',
              );
            }
            messageResponse.localError = ErrorHandler(
              errorCode: 400009,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${messageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: messageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "ok":
            if (debug) {
              developer.log(
                'Message ${messageResponse.messageID} proccessed from backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400010,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: messageResponse.messageID,
              propertyName: 'Status',
              propertyValue: messageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
        }
      }
    }

    return null;
  }

  Future<void> _waitUntilTrackedWorkIsDone(
    CommonRPCMessageResponse messageResponse,
  ) async {
    if (messageResponse.isWorkInProgress) {
      while (true) {
        if (!messageResponse.isWorkInProgress) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  ErrorHandler _buildTrackedCallbackMessageNotFoundError({
    required String messageID,
    required String functionName,
  }) {
    return ErrorHandler(
      errorCode: 400003,
      errorDsc:
          'No pudimos encontrar la referencia al mensaje enviado al backend',
      messageID: messageID,
      className: className,
      functionName: functionName,
      propertyName: 'MessageID',
      propertyValue: null,
      stacktrace: StackTrace.current,
    );
  }

  ErrorHandler _buildNoError({
    required String functionName,
    String errorDsc = 'No error',
  }) {
    return ErrorHandler(
      errorCode: 0,
      errorDsc: errorDsc,
      className: className,
      functionName: functionName,
    );
  }

  CommonRPCMessageResponse? _getTrackedMessageResponse(
    String messageID,
  ) {
    return wssMessagesTrackingV2.get(messageID);
  }

  ServiceProviderWholeMessageModel _parseWholeMessageFromCallback(
    dynamic pParams,
  ) {
    return ServiceProviderWholeMessageModel.fromJson(pParams);
  }

  ErrorHandler? _handleQueuedCallbackMessage({
    required ServiceProviderWholeMessageModel message,
    required String logFunctionName,
    required String queuedLogMessage,
    required String functionName,
  }) {
    if (message.data.status == "queued") {
      if (debug) {
        developer.log(
          queuedLogMessage,
          name: '$logClassName - $logFunctionName',
        );
      }
      return _buildNoError(functionName: functionName);
    }
    return null;
  }

  void _finalizeTrackedCallbackResponse({
    required CommonRPCMessageResponse messageResponse,
    required ErrorHandler response,
  }) {
    messageResponse.finalResponse = response;
    messageResponse.status = "ok";
  }

  ServiceProviderLoginDataUserMessageModel _extractLoginUserFromWholeMessage({
    required ServiceProviderWholeMessageModel message,
    required String functionName,
  }) {
    if (message.data.data is! Map<String, dynamic>) {
      throw ErrorHandler(
        errorCode: 10002,
        errorDsc: 'Invalid data format received from backend.',
        className: className,
        functionName: functionName,
      );
    }

    final Map<String, dynamic> m1 = message.data.data as Map<String, dynamic>;

    if (m1["Records"] is! List<dynamic>) {
      throw ErrorHandler(
        errorCode: 10002,
        errorDsc: 'Invalid data format received from backend.',
        className: className,
        functionName: functionName,
      );
    }

    final List<dynamic> m2 = m1["Records"] as List<dynamic>;
    if (m2.isEmpty) {
      throw ErrorHandler(
        errorCode: 10001,
        errorDsc: 'No records found in response data.',
        className: className,
        functionName: functionName,
      );
    }

    return ServiceProviderLoginDataUserMessageModel.fromJson(m2.first);
  }

  Map<String, dynamic> _buildBackendStatusRequest() {
    return {
      'ChannelName': 'GERYON_General',
      'Action': 'Get:Status',
      'pParams': <String, dynamic>{},
    };
  }

  Map<String, dynamic> _buildSubscribeChannelRequest() {
    final List<String> sChannels = [];
    for (final ServiceProviderChannel channel in channels) {
      sChannels.add(channel.name);
    }

    return {
      'Action': 'Subscribe_Channel',
      'ChannelsName': sChannels,
      'pParams': <String, dynamic>{},
    };
  }

  Map<String, dynamic> _buildLoginRequest({
    required LoginModel login,
  }) {
    return {
      'ChannelName': 'GERYON_General',
      'Action': 'CustomRequest',
      'pParams': <String, dynamic>{
        'JSON_Data': true,
        'UserRememberMe': login.rememberMe,
        'UserDNI': login.dni,
        'UserEmail': "",
        'UserPassword': "",
        'UserPreferredLanguage': "es-AR",
        'ActionRequest': 'Auth:Login',
        'FormAction': '',
        'GRecaptchaResponse': '',
        'Lang': "es-AR",
        'Location': '',
        'LocalParams': {
          'Target': "customers",
        },
      },
    };
  }

  _PreparedTrackedMessageResult _prepareTrackedMessageAfterSend({
    required ErrorHandler sendMessageResult,
    required String functionName,
    bool setInitStageErrorOnNotFound = false,
    bool updateListenersOnNotFound = false,
  }) {
    final CommonRPCMessageResponse? rMessageResponse =
        _getTrackedMessageResponse(sendMessageResult.messageID);

    if (rMessageResponse == null) {
      final ErrorHandler rSendMessageReturn = _buildTrackedMessageNotFoundError(
        messageID: sendMessageResult.messageID,
        functionName: functionName,
      );

      if (setInitStageErrorOnNotFound) {
        initStage = ServiceProviderInitStages.errorRequestingBackend;
        initStageError = rSendMessageReturn;
      }

      if (updateListenersOnNotFound) {
        updateListeners(calledFrom: functionName);
      }

      return _PreparedTrackedMessageResult.failure(
        rSendMessageReturn,
      );
    }

    _prepareTrackedMessageForWaiting(rMessageResponse);

    return _PreparedTrackedMessageResult.success(
      rMessageResponse,
    );
  }

  Future<ErrorHandler?> _handleTrackedCallbackOrCleanup({
    required ServiceProviderWholeMessageModel message,
    required Map<String, dynamic> rawData,
    required String functionName,
    required String logFunctionName,
  }) async {
    if (wssMessagesTrackingV2.hasCallback(message.data.messageID)) {
      if (debug) {
        developer.log(
          '$logClassName - $logFunctionName - Calling CallBack function for MessageID: ${message.data.messageID}',
        );
      }

      bool rCall = await wssMessagesTrackingV2.execute(
        key: message.data.messageID,
        pMessageID: message.data.messageID,
        paramCallBack: rawData,
      );

      if (rCall) {
        return null;
      } else {
        return ErrorHandler(
          errorCode: 7890,
          errorDsc:
              "Error al ejecutar función callback.\r\nMensaje ID: ${message.data.messageID}\r\nStatus: ${message.data.status}",
          propertyName: "CallbackFunction",
          className: className,
        );
      }
    } else {
      await wssMessagesTrackingV2.remove(message.data.messageID);
      return null;
    }
  }

  Future<void> _syncTrackedIncomingStatus({
    required ServiceProviderWholeMessageModel message,
  }) async {
    CommonRPCMessageResponse? cMessageStatusV2 =
        wssMessagesTrackingV2.get(message.data.messageID);

    if (cMessageStatusV2 != null) {
      if (cMessageStatusV2.status == "local_discard") {
        await wssMessagesTrackingV2.remove(message.data.messageID);
      }
    }

    String status = message.data.status;
    if (status == "ok") {
      status = "processing";
    }

    await wssMessagesTrackingV2.status(
      message.data.messageID,
      status,
    );
  }

  Future<ErrorHandler?> _handleApiV2TrackedIncomingMessage({
    required ServiceProviderWholeMessageModel message,
    required Map<String, dynamic> rawData,
    required String functionName,
    required String logFunctionName,
  }) async {
    await _syncTrackedIncomingStatus(
      message: message,
    );

    if (_isTrackedCallbackDispatchStatus(message.data.status)) {
      return await _handleTrackedCallbackOrCleanup(
        message: message,
        rawData: rawData,
        functionName: functionName,
        logFunctionName: logFunctionName,
      );
    }

    return ErrorHandler(
      errorCode: 7891,
      errorDsc:
          "Error del estado del mensaje recibido.\r\nMensaje ID:${message.data.messageID}\r\nStatus: ${message.data.status}",
      propertyName: "Status",
      className: className,
    );
  }

  Future<ErrorHandler?> _handleTrackedIncomingMessage({
    required ServiceProviderWholeMessageModel message,
    required Map<String, dynamic> rawData,
    required String functionName,
    required String logFunctionName,
  }) async {
    if (message.data.messageID.isEmpty) {
      updateListeners(calledFrom: functionName);
      return ErrorHandler(
        errorCode: 7892,
        errorDsc: "Recibimos un ID de Mensaje vacío.",
        propertyName: 'MessageID',
        propertyValue: message.data.messageID,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }

    if (message.data.apiVersion != 2) {
      updateListeners(calledFrom: functionName);
      return ErrorHandler(
        errorCode: 7893,
        errorDsc: '''Recibimos un mensaje con una versión de API no soportada.
                Mensaje ID: ${message.data.messageID}
                API Version: ${message.data.apiVersion}
                ''',
        propertyName: 'API Version',
        propertyValue: message.data.apiVersion.toString(),
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }

    return await _handleApiV2TrackedIncomingMessage(
      message: message,
      rawData: rawData,
      functionName: functionName,
      logFunctionName: logFunctionName,
    );
  }

  Future<ErrorHandler?> _handleHandshakeIncomingMessage({
    required ServiceProviderWholeMessageModel message,
    required String functionName,
    required String logFunctionName,
  }) async {
    if (debug) {
      developer.log(
        'OnData: Received [NEW] data, processing.',
        name: '$logClassName - $logFunctionName',
      );
    }

    final String tokenID = message.data.tokenID ?? "";

    final ErrorHandler? rTokenValidation = _validateHandshakeToken(
      tokenID: tokenID,
      functionName: functionName,
    );

    if (rTokenValidation != null) {
      updateListeners(calledFrom: functionName);
      return rTokenValidation;
    }

    _applySessionToken(
      tokenID: tokenID,
    );

    final ErrorHandler? rInit = await _continueInitializationAfterHandshake(
      functionName: functionName,
    );

    if (rInit != null && rInit.errorCode != 0) {
      if (debug) {
        developer.log(
          'OnData: Error continuing initialization after handshake: ${rInit.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rInit;
    }

    if (debug) {
      developer.log(
        'OnData: Channels subscribed successfully.',
        name: '$logClassName - $logFunctionName',
      );
    }

    return rInit;
  }

  bool _isTrackedCallbackDispatchStatus(String status) {
    switch (status) {
      case "ok":
      case "queued":
        return true;
      default:
        return false;
    }
  }

  ErrorHandler _buildOnDataErrorHandler({
    required Object error,
    required StackTrace stacktrace,
  }) {
    if (error is ErrorHandler) {
      return error;
    }

    return ErrorHandler(
      errorCode: 9999,
      errorDsc: error.toString(),
      stacktrace: stacktrace,
    );
  }

  Future<void> _handleOnDataProcessingError({
    required Object error,
    required StackTrace stacktrace,
    required String functionName,
    required String logFunctionName,
  }) async {
    initStageError = _buildOnDataErrorHandler(
      error: error,
      stacktrace: stacktrace,
    );

    initStage = ServiceProviderInitStages.errorRequestingBackend;
    initStageAdditionalMsg = "Catched an error on $logFunctionName";
    isReady = false;

    if (!isProgress) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: initStageError!,
          ),
        );
      }
    }

    updateListeners(calledFrom: functionName);
  }

  Future<ErrorHandler?> _onData(Map<String, dynamic> data) async {
    const String functionName = '_onData';
    const logFunctionName = '.::$functionName::.';

    if (debug) {
      developer.log(
        'OnData: $data',
        name: '$logClassName - $logFunctionName',
      );
    }

    ServiceProviderWholeMessageModel pData;

    try {
      pData = ServiceProviderWholeMessageModel.fromJson(data);

      if (_isHandshakeMessage(pData)) {
        return await _handleHandshakeIncomingMessage(
          message: pData,
          functionName: functionName,
          logFunctionName: logFunctionName,
        );
      }

      return await _handleTrackedIncomingMessage(
        message: pData,
        rawData: data,
        functionName: functionName,
        logFunctionName: logFunctionName,
      );
    } catch (e, stacktrace) {
      await _handleOnDataProcessingError(
        error: e,
        stacktrace: stacktrace,
        functionName: functionName,
        logFunctionName: logFunctionName,
      );
      return null;
    }
  }

  dynamic _onError(dynamic error) {
    const String functionName = '_onError';
    const logFunctionName = '.::$functionName::.';

    if (debug) {
      developer.log(
        'OnError: $error',
        name: '$logClassName - $logFunctionName',
      );
    }
    if (error is ErrorHandler) {
      if (debug) {
        developer.log(
          'OnError: ErrorHandler received: ${error.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
    } else {
      if (debug) {
        developer.log(
          'OnError: Non-ErrorHandler error received: ${error.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
    }
    lastError = wssClient.errorHandler(
      error,
      // className: className,
      // functionName: functionName,
    );
    updateListeners(calledFrom: functionName);
  }

  dynamic _onDone() {
    const String functionName = '_onDone';
    const logFunctionName = '.::$functionName::.';

    if (debug) {
      developer.log(
        'OnDone => Conexión con el servidor backend perdida. Intentando reconectar...',
        name: '$logClassName - $logFunctionName',
      );
    }
    lastError = ErrorHandler(
      errorCode: 0,
      errorDsc: 'WebSocket connection closed.',
      className: className,
      functionName: functionName,
    );
    updateListeners(calledFrom: functionName);
    reboot();
  }

  Future<ErrorHandler?> init() async {
    const String functionName = 'init';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        'Initializing ServiceProvider...',
        name: '$logClassName - $logFunctionName',
      );
    }
    if (isNew) {
      if (debug) {
        developer.log(
          'ServiceProvider is new, proceeding with initialization.',
          name: '$logClassName - $logFunctionName',
        );
      }
      try {
        isProgress = true;
        initStageError = ErrorHandler(byDefault: true);
        initStage = ServiceProviderInitStages.connecting;
        updateListeners(calledFrom: functionName);
        ErrorHandler wss = await wssClient.init();
        developer.log(
          '${LogIcons.arrowLeft} WebSocketClient $wss',
          name: '$logClassName - $logFunctionName',
        );
        if (wss.errorCode != 0) {
          if (debug) {
            developer.log(
              '${LogIcons.arrowLeft} WebSocketClient initialization error: ${wss.toString()}',
              name: '$logClassName - $logFunctionName',
            );
          }
          initStageAdditionalMsg = 'Error #${wss.errorCode}. ${wss.errorDsc}';
          initStageError = wss;
          connRetry++;
          updateListeners(calledFrom: functionName);
          if (connRetry <= maxConnRetry) {
            if (debug) {
              developer.log(
                'Retrying connection... Attempt $connRetry of $maxConnRetry',
                name: '$logClassName - $logFunctionName',
              );
            }
            return await init();
          } else {
            if (debug) {
              developer.log(
                'Max connection retries reached. Giving up.',
                name: '$logClassName - $logFunctionName',
              );
            }
            initStage = ServiceProviderInitStages.errorConnecting;
            initStageError = ErrorHandler(
              errorCode: 10000,
              errorDsc:
                  'Max connection retries reached. Please check your network connection and try again later.',
              className: className,
              functionName: functionName,
            );
            isReady = false;
            isProgress = false;
            updateListeners(calledFrom: functionName);
            return initStageError;
          }
        }
        if (debug) {
          developer.log(
            '${LogIcons.check} WebSocketClient initialized successfully.',
            name: '$logClassName - $logFunctionName',
          );
        }
        return null;
      } catch (e, stacktrace) {
        if (debug) {
          developer.log(
            'Error during initialization: $e',
            name: '$logClassName - $logFunctionName',
          );
        }
        // Handle initialization error
        if (e is ErrorHandler) {
          initStageError = e;
        } else {
          // If it's not an ErrorHandler, create a new one
          initStageError = ErrorHandler(
            errorCode: 1,
            errorDsc: e.toString(),
            className: className,
            functionName: functionName,
            stacktrace: stacktrace,
          );
        }
        return initStageError;
      }
    } else {
      if (debug) {
        developer.log(
          'ServiceProvider is not new, skipping initialization.',
          name: '$logClassName - $logFunctionName',
        );
      }
      updateListeners(calledFrom: functionName);
      // return ErrorHandler(
      //   errorCode: 10001,
      //   errorDsc:
      //       'ServiceProvider is not new, skipping initialization. NO DEBERÍA ESTAR AQUÍ NUNCA',
      //   propertyName: 'isNew',
      //   propertyValue: isNew.toString(),
      //   className: className,
      //   functionName: functionName,
      //   stacktrace: StackTrace.current,
      // );
    }
    // Chequeamos el status del backend
    ErrorHandler statusCheck = await getBackendStatus();
    if (statusCheck.errorCode != 0) {
      if (debug) {
        developer.log(
          'Error checking backend status: ${statusCheck.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageError = statusCheck;
      isReady = false;
      //isProgress = false;
      isNew = true;
      updateListeners(calledFrom: functionName);
      return await init();
    }
    if (debug) {
      developer.log(
        'Backend status checked successfully.',
        name: '$logClassName - $logFunctionName',
      );
    }
    return ErrorHandler(
      errorCode: 0,
      errorDsc: 'ServiceProvider initialized successfully.',
      className: className,
      functionName: functionName,
    );
  }

  void _applyBackendStatusSuccessState({
    required String functionName,
    String? additionalMessage = 'Backend status checked successfully.',
  }) {
    initStage = ServiceProviderInitStages.connected;
    initStageAdditionalMsg = additionalMessage;
    isReady = true;
    updateListeners(calledFrom: functionName);
  }

  ErrorHandler _handleBackendStatusFinalError({
    required ErrorHandler error,
    required String functionName,
  }) {
    initStage = ServiceProviderInitStages.errorRequestingBackend;
    initStageError = error;
    updateListeners(calledFrom: functionName);
    return error;
  }

  ServiceProviderLoginContinuationResult _resolveLoginContinuationResult({
    required dynamic rawResult,
    required ServiceProviderAuthRequirement authRequirement,
  }) {
    if (rawResult == null) {
      return ServiceProviderLoginContinuationResult.cancelled(
        authRequirement: authRequirement,
        rawResult: rawResult,
        description: 'Login popup closed without a continuation result.',
        className: className,
        functionName: '_resolveLoginContinuationResult',
      );
    }

    if (rawResult is! ErrorHandler) {
      return ServiceProviderLoginContinuationResult.invalidResult(
        authRequirement: authRequirement,
        rawResult: rawResult,
        description:
            'Login popup returned an unexpected continuation result type.',
        className: className,
        functionName: '_resolveLoginContinuationResult',
      );
    }

    final ErrorHandler loginResult = rawResult;

    if (loginResult.errorCode != 0) {
      return ServiceProviderLoginContinuationResult.failed(
        authRequirement: authRequirement,
        error: loginResult,
        rawResult: rawResult,
      );
    }

    if (loginResult.data is! ServiceProviderLoginDataUserMessageModel) {
      return ServiceProviderLoginContinuationResult.invalidResult(
        authRequirement: authRequirement,
        rawResult: rawResult,
        description:
            'Login continuation succeeded but returned no valid authenticated user payload.',
        className: className,
        functionName: '_resolveLoginContinuationResult',
      );
    }

    return ServiceProviderLoginContinuationResult.success(
      authRequirement: authRequirement,
      user: loginResult.data as ServiceProviderLoginDataUserMessageModel,
      error: loginResult,
      rawResult: rawResult,
    );
  }

  Future<ErrorHandler> _handleResolvedLoginContinuation({
    required ServiceProviderLoginContinuationResult continuationResult,
    required String functionName,
    required String logFunctionName,
  }) async {
    if (continuationResult.isSuccess) {
      if (debug) {
        developer.log(
          'GetBackendStatus => Login continuation resolved successfully: ${continuationResult.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }

      _applyAuthenticatedUserContext(
        user: continuationResult.user!,
      );

      initStage = ServiceProviderInitStages.connected;
      initStageAdditionalMsg = 'User logged in successfully.';
      initStageError = continuationResult.error;
      isReady = true;
      isProgress = false;
      updateListeners(calledFrom: functionName);
      return continuationResult.toErrorHandler();
    }

    if (debug) {
      developer.log(
        'GetBackendStatus => Login continuation did not resolve authenticated runtime: ${continuationResult.toString()}',
        name: '$logClassName - $logFunctionName',
      );
    }

    final ErrorHandler error = continuationResult.toErrorHandler();
    initStageError = error;
    initStage = ServiceProviderInitStages.errorRequestingBackend;
    isReady = false;
    isProgress = false;
    updateListeners(calledFrom: functionName);
    return error;
  }

  Future<ErrorHandler> _handleBackendStatusSuccessFlow({
    required ErrorHandler finalResponse,
    required String functionName,
    required String logFunctionName,
  }) async {
    if (debug) {
      developer.log(
        '${LogIcons.arrowLeft} Backend status checked successfully: ${finalResponse.toString()}',
        name: '$logClassName - $logFunctionName',
      );
    }

    _applyBackendStatusSuccessState(
      functionName: functionName,
    );

    final authRequirement = evaluateAuthRequirement();
    ErrorHandler rCheckLoggedUser =
        _toLegacyAuthRequirementError(authRequirement);

    if (rCheckLoggedUser.errorCode != 0) {
      if (debug) {
        developer.log(
          'GetBackendStatus => Error checking logged user: ${rCheckLoggedUser.toString()} / requirement: ${authRequirement.kind.name}',
          name: '$logClassName - $logFunctionName',
        );
      }

      if (authRequirement.requiresInteractiveLogin) {
        developer.log(
          'Auth requirement 1 => ${authRequirement.kind.name} / $navigatorKey ${navigatorKey.currentState}',
          name: '$logClassName - $logFunctionName',
        );

        if (authRequirement.shouldResetAuthenticatedRuntimeState) {
          _resetAuthenticatedRuntimeState(clearLoggedUser: false);
        }

        if (navigatorKey.currentState == null) {
          final continuationResult =
              ServiceProviderLoginContinuationResult.invalidResult(
            authRequirement: authRequirement,
            rawResult: null,
            description:
                'Login continuation could not start because no navigator state was available.',
            className: className,
            functionName: '_handleBackendStatusSuccessFlow',
          );

          return await _handleResolvedLoginContinuation(
            continuationResult: continuationResult,
            functionName: functionName,
            logFunctionName: logFunctionName,
          );
        }

        developer.log(
          'Auth requirement 2 => ${authRequirement.kind.name} / $navigatorKey ${navigatorKey.currentState}',
          name: '$logClassName - $logFunctionName',
        );

        final dynamic rawLoginResult = await navigatorKey.currentState
            ?.push(PopUpLoginWidget<ErrorHandler>());

        developer.log(
          'Auth requirement 3 => ${authRequirement.kind.name} / $navigatorKey ${navigatorKey.currentState} $rawLoginResult',
          name: '$logClassName - $logFunctionName',
        );

        final continuationResult = _resolveLoginContinuationResult(
          rawResult: rawLoginResult,
          authRequirement: authRequirement,
        );

        return await _handleResolvedLoginContinuation(
          continuationResult: continuationResult,
          functionName: functionName,
          logFunctionName: logFunctionName,
        );
      } else {
        _resetAuthenticatedRuntimeState();
        initStage = ServiceProviderInitStages.errorRequestingBackend;
        initStageError = rCheckLoggedUser;
        updateListeners(calledFrom: functionName);
        return rCheckLoggedUser;
      }
    }

    if (debug) {
      developer.log(
        'GetBackendStatus => Logged user checked successfully: ${rCheckLoggedUser.toString()}',
        name: '$logClassName - $logFunctionName',
      );
    }

    isReady = true;
    isProgress = false;
    initStage = ServiceProviderInitStages.connected;
    initStageAdditionalMsg = null;
    updateListeners(calledFrom: functionName);

    return ErrorHandler(
      errorCode: 0,
      errorDsc: 'Backend status checked successfully.',
      className: className,
      functionName: functionName,
    );
  }

  Future<ErrorHandler> _executeTrackedRequestFlow({
    required Map<String, dynamic> requestData,
    required CommonRPCMessageResponseCallBack callBackFunction,
    required String functionName,
    required String logFunctionName,
    bool setInitStageErrorOnNotFound = false,
    bool updateListenersOnNotFound = false,
    bool notifyListenersOnSend = true,
    bool showWorkInProgress = false,
    bool inclusiveTimeout = true,
    bool removeOnOk = true,
    bool removeOnlyWhenCounterMatchesChannels = false,
  }) async {
    final ErrorHandler rSendMessage = await sendMessageV2(
      pData: requestData,
      isAsync: true,
      pNotifyListeners: notifyListenersOnSend,
      pShowWorkInProgress: showWorkInProgress,
      callBackFunction: callBackFunction,
    );

    if (rSendMessage.errorCode != 0) {
      if (debug) {
        developer.log(
          'Error sending tracked request: ${rSendMessage.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rSendMessage;
    }

    final _PreparedTrackedMessageResult rPrepared =
        _prepareTrackedMessageAfterSend(
      sendMessageResult: rSendMessage,
      functionName: functionName,
      setInitStageErrorOnNotFound: setInitStageErrorOnNotFound,
      updateListenersOnNotFound: updateListenersOnNotFound,
    );

    if (rPrepared.hasError) {
      return rPrepared.error!;
    }

    final CommonRPCMessageResponse rMessageResponse =
        rPrepared.messageResponse!;

    final ErrorHandler? rWaitError = await _waitForTrackedMessageCompletion(
      messageResponse: rMessageResponse,
      functionName: functionName,
      logFunctionName: logFunctionName,
      inclusiveTimeout: inclusiveTimeout,
    );

    if (rWaitError != null) {
      return rWaitError;
    }

    final ErrorHandler rFinalResponse = rMessageResponse.finalResponse;

    if (rMessageResponse.status == "ok") {
      await _waitUntilTrackedWorkIsDone(rMessageResponse);

      if (removeOnOk) {
        if (removeOnlyWhenCounterMatchesChannels) {
          if (rMessageResponse.counter == channels.length) {
            await wssMessagesTrackingV2.remove(rSendMessage.messageID);
          }
        } else {
          await wssMessagesTrackingV2.remove(rSendMessage.messageID);
        }
      }
    }

    return rFinalResponse;
  }

  Future<ErrorHandler> getBackendStatus() async {
    const String functionName = 'getBackendStatus';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Checking backend status...',
        name: '$logClassName - $logFunctionName',
      );
    }
    initStageAdditionalMsg = initStage.typeDsc;
    updateListeners(calledFrom: functionName);
    final Map<String, dynamic> pRequest = _buildBackendStatusRequest();
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Requesting backend status...',
        name: '$logClassName - $logFunctionName',
      );
    }
    final ErrorHandler rFinalResponse = await _executeTrackedRequestFlow(
      requestData: pRequest,
      callBackFunction: getBackendStatusCallback,
      functionName: functionName,
      logFunctionName: logFunctionName,
      setInitStageErrorOnNotFound: true,
      updateListenersOnNotFound: true,
      notifyListenersOnSend: true,
      showWorkInProgress: false,
      inclusiveTimeout: true,
      removeOnOk: true,
      removeOnlyWhenCounterMatchesChannels: false,
    );
    if (rFinalResponse.errorCode != 0) {
      if (debug) {
        developer.log(
          '${LogIcons.arrowLeft} Error received from backend: ${rFinalResponse.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return _handleBackendStatusFinalError(
        error: rFinalResponse,
        functionName: functionName,
      );
    } else {
      return await _handleBackendStatusSuccessFlow(
        finalResponse: rFinalResponse,
        functionName: functionName,
        logFunctionName: logFunctionName,
      );
    }
  }

  /// Callback function for getBackendStatus
  Future<ErrorHandler> getBackendStatusCallback({
    required bool pFromCallback,
    required String pMessageID,
    required dynamic pParams,
  }) async {
    const String functionName = 'getBackendStatusCallback';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '${LogIcons.arrowLeft} Callback called with pFromCallback: $pFromCallback, pMessageID: $pMessageID, pParams: $pParams',
        name: '$logClassName - $logFunctionName',
      );
    }
    CommonRPCMessageResponse? rMessageResponse;
    try {
      rMessageResponse = _getTrackedMessageResponse(pMessageID);
      if (rMessageResponse == null) {
        return _buildTrackedCallbackMessageNotFoundError(
          messageID: pMessageID,
          functionName: functionName,
        );
      }
      final ServiceProviderWholeMessageModel pData =
          _parseWholeMessageFromCallback(pParams);
      final ErrorHandler? rQueued = _handleQueuedCallbackMessage(
        message: pData,
        logFunctionName: logFunctionName,
        queuedLogMessage:
            'GetBackendStatusCallback => Message is queued, waiting for processing.',
        functionName: functionName,
      );
      if (rQueued != null) {
        return rQueued;
      }
      if (pData.errorCode != 0) {
        switch (pData.data.severity) {
          case "high":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "medium":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "low":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "none":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;

            /// If severity is [none] then, it should be check by the widget itself instad of being a general issue.-
            break;
          default:
            break;
        }
        ErrorHandler stdError = StandarizeErrors.standarizeErrors(pData);
        initStageError = ErrorHandler(
          errorCode: pData.errorCode,
          errorDsc: '${pData.errorDsc}\r\n${stdError.errorDsc}',
        );
        initStage = ServiceProviderInitStages.errorCheckingStatus;
        initStageAdditionalMsg = "";
        if (!isProgress) {
          /// If this is not main framework (already inside the app)
          /// I SHOW a PopUp Message, ALSO.
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState?.push(
                ModelGeneralPoPUpErrorMessageDialog(error: initStageError!));
            //return initSta
          }
        }
        updateListeners(calledFrom: functionName);
        if (debug) {
          developer.log(
            'GetBackendStatusCallback => Error received: ${initStageError.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        return initStageError!;
      }
      if (pData.data.status == "ok") {
        //
      }
      isReady = true;
      //isProgress = false;
      initStage = ServiceProviderInitStages.connected;
      initStageAdditionalMsg = "";
      initStageError = ErrorHandler(
        errorCode: 0,
        errorDsc: 'Backend status checked successfully.',
        className: className,
        functionName: functionName,
      );
      updateListeners(calledFrom: functionName);
      rMessageResponse.finalResponse = initStageError!;
      rMessageResponse.status = "ok";
      if (debug) {
        developer.log(
          'GetBackendStatusCallback => Backend status checked successfully.',
          name: '$logClassName - $logFunctionName',
        );
      }
      return initStageError!;
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'GetBackendStatusCallback => Error processing callback: $e',
          name: '$logClassName - $logFunctionName',
        );
      }

      /// Ocurrió un error (fue throw)
      ///
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        initStageError = e;
      } else {
        initStageError = ErrorHandler(
          errorCode: 9999,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
          propertyName: 'paramCallBack',
        );
      }
      initStage = ServiceProviderInitStages.errorCheckingStatus;
      initStageAdditionalMsg = "";
      isReady = false;
      if (!isProgress) {
        /// If this is not main framework (already inside the app)
        /// I SHOW a PopUp Message, ALSO.
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.push(
              ModelGeneralPoPUpErrorMessageDialog(error: initStageError!));
          //return initSta
        }
      }
      updateListeners(calledFrom: functionName);
      // rMessageResponse.finalResponse = initStageError!;
      // rMessageResponse.status = "ok";
      return initStageError!;
    }
  }

  Future<ErrorHandler> doCheckLogin() async {
    const String functionName = 'doCheckLogin';
    const logFunctionName = '.::$functionName::.';

    if (debug) {
      developer.log(
        'DoCheckLogin => Checking logged user...',
        name: '$logClassName - $logFunctionName',
      );
    }

    /// Legacy compatibility wrapper.
    ///
    /// Real auth requirement meaning is now produced by
    /// [evaluateAuthRequirement] and then mapped back to the previous
    /// ErrorHandler-based contract while the rest of the runtime keeps
    /// using the old shape.
    ///
    /// Error Codes:
    /// -1000: user is not logged-in. MUST FORCE login
    /// -1001: user is logged-in locally. MUST FORCE login continuation.
    /// -1002: user validation has failed. MUST FORCE login again.
    /// 0: user is logged (no matter what)
    initStage = ServiceProviderInitStages.checkingLoginStatus;
    initStageAdditionalMsg = "";
    updateListeners(calledFrom: functionName);

    final authRequirement = evaluateAuthRequirement();

    if (authRequirement.kind == ServiceProviderAuthRequirementKind.none) {
      return _toLegacyAuthRequirementError(authRequirement);
    }

    if (authRequirement.kind ==
        ServiceProviderAuthRequirementKind.loginRequiredNoRememberedUser) {
      initStage = ServiceProviderInitStages.userIsNotloggedIn;
      initStageAdditionalMsg = "";
      updateListeners(calledFrom: functionName);
    }

    if (authRequirement.shouldResetAuthenticatedRuntimeState) {
      _resetAuthenticatedRuntimeState(clearLoggedUser: false);
    }

    return _toLegacyAuthRequirementError(authRequirement);

    // Map<String, dynamic> pRequest = {};
    // pRequest['ChannelName'] = 'GERYON_General';
    // pRequest['Action'] = 'Get:LoggedUser';
    // Map<String, dynamic> pParams = {};
    // pParams['JSON_Data'] = true;
    // pParams['UserRememberMe'] = true;
    // pParams['UserEmail'] = loggedUser!.userEMail;
  }

  /// Callback function for doCheckLogin
  Future<ErrorHandler> doCheckLoginCallback({
    required bool pFromCallback,
    required String pMessageID,
    required dynamic pParams,
  }) async {
    const String functionName = 'doCheckLoginCallback';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        'DoCheckLoginCallback => Callback called with pFromCallback: $pFromCallback, pMessageID: $pMessageID, pParams: $pParams',
        name: '$logClassName - $logFunctionName',
      );
    }
    CommonRPCMessageResponse? rMessageResponse;
    try {
      ErrorHandler noError = ErrorHandler(
        errorCode: 0,
        errorDsc: 'No error',
        className: className,
        functionName: functionName,
      );
      rMessageResponse = wssMessagesTrackingV2.get(pMessageID);
      if (rMessageResponse == null) {
        return ErrorHandler(
          errorCode: 400003,
          errorDsc:
              'No pudimos encontrar la referencia al mensaje enviado al backend',
          messageID: pMessageID,
          className: className,
          functionName: functionName,
          propertyName: 'MessageID',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      ServiceProviderWholeMessageModel pData;
      pData = ServiceProviderWholeMessageModel.fromJson(pParams);
      if (pData.data.status == "queued") {
        if (debug) {
          developer.log(
            'DoCheckLoginCallback => Message is queued, waiting for processing.',
            name: '$logClassName - $logFunctionName',
          );
        }
        return noError;
      }
      if (pData.errorCode != 0) {
        switch (pData.data.severity) {
          case "high":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "medium":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "low":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "none":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;

            /// If severity is [none] then, it should be check by the widget itself instad of being a general issue.-
            break;
          default:
            break;
        }
        ErrorHandler stdError = StandarizeErrors.standarizeErrors(pData);
        if (debug) {
          developer.log(
            'DoCheckLoginCallback => standarizeErrors => Error received: ${stdError.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        initStageError = ErrorHandler(
          errorCode: pData.errorCode,
          errorDsc: '${pData.errorDsc}\r\n${stdError.errorDsc}',
        );
        initStage = ServiceProviderInitStages.errorCheckingStatus;
        initStageAdditionalMsg = "";
        if (!isProgress) {
          /// If this is not main framework (already inside the app)
          /// I SHOW a PopUp Message, ALSO.
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState?.push(
                ModelGeneralPoPUpErrorMessageDialog(error: initStageError!));
            //return initSta
          }
        }
        updateListeners(calledFrom: functionName);
        if (debug) {
          developer.log(
            'DoCheckLoginCallback => Error received: ${initStageError.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        return initStageError!;
      }
      //loginError = null;
      final ServiceProviderLoginDataUserMessageModel rDataData =
          _extractLoginUserFromWholeMessage(
        message: pData,
        functionName: functionName,
      );

      _applyAuthenticatedUserContext(
        user: rDataData,
      );
      updateListeners(calledFrom: functionName);
      if (debug) {
        developer.log(
          'DoCheckLoginCallback => Logged user checked successfully: ${loggedUser.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      final ErrorHandler rSuccess = ErrorHandler(
        errorCode: 0,
        errorDsc: 'Logged user checked successfully.',
        className: className,
        functionName: functionName,
        data: loggedUser,
      );

      _finalizeTrackedCallbackResponse(
        messageResponse: rMessageResponse,
        response: rSuccess,
      );

      return rSuccess;
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'GetBackendStatusCallback => Error processing callback: $e',
          name: '$logClassName - $logFunctionName',
        );
      }

      /// Ocurrió un error (fue throw)
      ///
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        initStageError = e;
      } else {
        initStageError = ErrorHandler(
          errorCode: 9999,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
          propertyName: 'paramCallBack',
        );
      }
      return initStageError!;
    }
  }

  void reboot() {
    const String functionName = 'reboot';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        'Reboot => Rebooting ServiceProvider...',
        name: '$logClassName - $logFunctionName',
      );
    }
    isNew = true;
    sessionTokenID = '';
    isReady = false;
    if (!isProgress) {
      isProgress = true;
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.push(ModelGeneralPoPUpLoadingProgress());
      }
    }
    updateListeners(calledFrom: functionName);
    init();
  }

  Future<ErrorHandler> subscribeChannel() async {
    const String functionName = 'subscribeChannel';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Subscribing to channels...',
        name: '$logClassName - $logFunctionName',
      );
    }
    try {
      initStageAdditionalMsg = initStage.typeDsc;
      updateListeners(calledFrom: functionName);

      for (final ServiceProviderChannel channel in channels) {
        if (debug) {
          developer.log(
            'Adding ${channel.name} to subscription list',
            name: '$logClassName - $logFunctionName',
          );
        }
      }

      final Map<String, dynamic> pRequest = _buildSubscribeChannelRequest();
      final List<String> sChannels =
          (pRequest['ChannelsName'] as List<dynamic>).cast<String>();
      if (debug) {
        developer.log(
          'SubscribeChannel => Requesting subscription to channels: $sChannels',
          name: '$logClassName - $logFunctionName',
        );
      }
      final ErrorHandler rFinalResponse = await _executeTrackedRequestFlow(
        requestData: pRequest,
        callBackFunction: subscribeChannelCallback,
        functionName: functionName,
        logFunctionName: logFunctionName,
        setInitStageErrorOnNotFound: true,
        updateListenersOnNotFound: true,
        notifyListenersOnSend: true,
        showWorkInProgress: false,
        inclusiveTimeout: false,
        removeOnOk: true,
        removeOnlyWhenCounterMatchesChannels: true,
      );
      if (rFinalResponse.errorCode != 0) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowLeft} Error received from backend: ${rFinalResponse.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        initStage = ServiceProviderInitStages.errorSubscribingChannels;
        initStageError = rFinalResponse;
        updateListeners(calledFrom: functionName);
        return rFinalResponse;
      }
      bool allSubscribed = true;
      for (var element in channels) {
        if (!element.isSubscribed) {
          allSubscribed = false;
        }
      }
      // No se subscribió a todos los canales
      if (!allSubscribed) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowLeft} Not all channels are subscribed: $sChannels',
            name: '$logClassName - $logFunctionName',
          );
        }
        initStage = ServiceProviderInitStages.errorSubscribingChannels;
        initStageError = ErrorHandler(
          errorCode: 10003,
          errorDsc:
              'Not all channels could be subscribed. Please check your network connection and try again later.',
          className: className,
          functionName: functionName,
        );
        updateListeners(calledFrom: functionName);
        return initStageError!;
      }
      if (debug) {
        developer.log(
          'SubscribeChannel => Successfully subscribed to channels: $sChannels',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rFinalResponse;
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'SubscribeChannel => Error subscribing to channel: $e',
          name: '$logClassName - $logFunctionName',
        );
      }
      return ErrorHandler(
        errorCode: 10004,
        errorDsc: e.toString(),
        className: className,
        functionName: functionName,
        stacktrace: stacktrace,
      );
    }
  }

  /// Callback function for subscribeChannel
  Future<ErrorHandler> subscribeChannelCallback({
    required bool pFromCallback,
    required String pMessageID,
    required dynamic pParams,
  }) async {
    const String functionName = 'subscribeChannelCallback';
    const logFunctionName = '.::$functionName::.';
    CommonRPCMessageResponse? rMessageResponse;
    if (debug) {
      developer.log(
        '${LogIcons.arrowLeft} Callback called with fromCallback: $pFromCallback, paramCallBack: $pParams',
        name: '$logClassName - $logFunctionName',
      );
    }
    try {
      rMessageResponse = _getTrackedMessageResponse(pMessageID);
      if (rMessageResponse == null) {
        return _buildTrackedCallbackMessageNotFoundError(
          messageID: pMessageID,
          functionName: functionName,
        );
      }
      final ServiceProviderWholeMessageModel pData =
          _parseWholeMessageFromCallback(pParams);
      final ErrorHandler? rQueued = _handleQueuedCallbackMessage(
        message: pData,
        logFunctionName: logFunctionName,
        queuedLogMessage:
            'SubscribeChannelCallback => Message is queued, waiting for processing.',
        functionName: functionName,
      );
      if (rQueued != null) {
        return rQueued;
      }
      if (pData.errorCode != 0) {
        switch (pData.data.severity) {
          case "high":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "medium":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "low":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "none":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;

            /// If severity is [none] then, it should be check by the widget itself instad of being a general issue.-
            break;
          default:
            break;
        }
        ErrorHandler stdError = StandarizeErrors.standarizeErrors(pData);
        initStageError = ErrorHandler(
          errorCode: pData.errorCode,
          errorDsc: '${pData.errorDsc}\r\n${stdError.errorDsc}',
        );
        initStage = ServiceProviderInitStages.errorSubscribingChannels;
        initStageAdditionalMsg = "";
        if (!isProgress) {
          /// If this is not main framework (already inside the app)
          /// I SHOW a PopUp Message, ALSO.
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState?.push(
                ModelGeneralPoPUpErrorMessageDialog(error: initStageError!));
            //return initSta
          }
        }
        updateListeners(calledFrom: functionName);
        if (debug) {
          developer.log(
            'SubscribeChannelCallback => Error received: ${initStageError.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        _finalizeTrackedCallbackResponse(
          messageResponse: rMessageResponse,
          response: initStageError!,
        );
        return initStageError!;
      }
      int channelIndex = channels
          .indexWhere((element) => element.name == pData.data.channelName);
      if (channelIndex == -1) {
        if (debug) {
          developer.log(
            'SubscribeChannelCallback => Channel ${pData.data.channelName} not found in channels list.',
            name: '$logClassName - $logFunctionName',
          );
        }
        initStage = ServiceProviderInitStages.errorSubscribingChannels;
        initStageAdditionalMsg = "";
        initStageError = ErrorHandler(
          errorCode: 10005,
          errorDsc:
              'Channel ${pData.data.channelName} not found in channels list. Please check your configuration.',
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
        updateListeners(calledFrom: functionName);
        _finalizeTrackedCallbackResponse(
          messageResponse: rMessageResponse,
          response: initStageError!,
        );
        return initStageError!;
      } else {
        if (debug) {
          developer.log(
            'SubscribeChannelCallback => Channel ${pData.data.channelName} found at index $channelIndex.',
            name: '$logClassName - $logFunctionName',
          );
        }
        channels[channelIndex].status = ErrorHandler(
          errorCode: pData.errorCode,
          errorDsc: pData.errorDsc,
        );
        channels[channelIndex].isSubscribed =
            pData.errorCode == 0 ? true : false;
        rMessageResponse.counter++;
        if (rMessageResponse.counter == channels.length) {
          if (debug) {
            developer.log(
              'SubscribeChannelCallback => All channels processed successfully.',
              name: '$logClassName - $logFunctionName',
            );
          }

          initStage = ServiceProviderInitStages.subscribed;
          initStageAdditionalMsg =
              "Suscritos a ${rMessageResponse.counter} de ${channels.length} canales.";
          initStageError = ErrorHandler(
            errorCode: 0,
            errorDsc:
                "Suscritos a ${rMessageResponse.counter} de ${channels.length} canales.",
            className: className,
            functionName: functionName,
          );
          updateListeners(calledFrom: functionName);

          _finalizeTrackedCallbackResponse(
            messageResponse: rMessageResponse,
            response: initStageError!,
          );
          return initStageError!;
        } else {
          if (debug) {
            developer.log(
              'SubscribeChannelCallback => Channel ${pData.data.channelName} subscribed successfully, waiting remaining channels.',
              name: '$logClassName - $logFunctionName',
            );
          }

          initStage = ServiceProviderInitStages.subscribing;
          initStageAdditionalMsg =
              "Suscritos a ${rMessageResponse.counter} de ${channels.length} canales.";
          initStageError = ErrorHandler(
            errorCode: 0,
            errorDsc:
                "Suscritos a ${rMessageResponse.counter} de ${channels.length} canales.",
            className: className,
            functionName: functionName,
          );
          updateListeners(calledFrom: functionName);

          _finalizeTrackedCallbackResponse(
            messageResponse: rMessageResponse,
            response: initStageError!,
          );
          return initStageError!;
        }
      } // if (channelIndex == -1)
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'SubscribeChannelCallback => Error processing callback: $e',
          name: '$logClassName - $logFunctionName',
        );
      }

      /// Ocurrió un error (fue throw)
      ///
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        initStageError = e;
      } else {
        initStageError = ErrorHandler(
          errorCode: 9999,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
          propertyName: 'paramCallBack',
        );
      }
      initStage = ServiceProviderInitStages.errorSubscribingChannels;
      initStageAdditionalMsg = "";
      isReady = false;
      if (!isProgress) {
        /// If this is not main framework (already inside the app)
        /// I SHOW a PopUp Message, ALSO.
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.push(
              ModelGeneralPoPUpErrorMessageDialog(error: initStageError!));
          //return initSta
        }
      }
      updateListeners(calledFrom: functionName);
      return initStageError!;
    }
  }

  Future<ErrorHandler> doLogin({
    required LoginModel pLogin,
  }) async {
    const String functionName = 'doLogin';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Building login request for backend...',
        name: '$logClassName - $logFunctionName',
      );
    }
    final Map<String, dynamic> pRequest = _buildLoginRequest(
      login: pLogin,
    );
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Requesting login to backend...',
        name: '$logClassName - $logFunctionName',
      );
    }
    final ErrorHandler rFinalResponse = await _executeTrackedRequestFlow(
      requestData: pRequest,
      callBackFunction: doLoginCallback,
      functionName: functionName,
      logFunctionName: logFunctionName,
      setInitStageErrorOnNotFound: false,
      updateListenersOnNotFound: false,
      notifyListenersOnSend: true,
      showWorkInProgress: false,
      inclusiveTimeout: true,
      removeOnOk: true,
      removeOnlyWhenCounterMatchesChannels: false,
    );
    if (rFinalResponse.errorCode != 0 && debug) {
      developer.log(
        '${LogIcons.arrowLeft} Error received from backend: ${rFinalResponse.toString()}',
        name: '$logClassName - $logFunctionName',
      );
    }
    return rFinalResponse;
  }

  Future<ErrorHandler> doLoginCallback({
    required bool pFromCallback,
    required String pMessageID,
    required dynamic pParams,
  }) async {
    const String functionName = 'doLoginCallback';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        '${LogIcons.arrowLeft} Callback called with pFromCallback: $pFromCallback, pMessageID: $pMessageID, pParams: $pParams',
        name: '$logClassName - $logFunctionName',
      );
    }
    CommonRPCMessageResponse? rMessageResponse;
    try {
      rMessageResponse = _getTrackedMessageResponse(pMessageID);
      if (rMessageResponse == null) {
        return _buildTrackedCallbackMessageNotFoundError(
          messageID: pMessageID,
          functionName: functionName,
        );
      }
      final ServiceProviderWholeMessageModel pData =
          _parseWholeMessageFromCallback(pParams);
      final ErrorHandler? rQueued = _handleQueuedCallbackMessage(
        message: pData,
        logFunctionName: logFunctionName,
        queuedLogMessage:
            'DoLoginCallback => Message is queued, waiting for processing.',
        functionName: functionName,
      );
      if (rQueued != null) {
        return rQueued;
      }
      if (pData.errorCode != 0) {
        switch (pData.data.severity) {
          case "high":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "medium":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "low":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;
            break;
          case "none":
            isReady = false;
            initStage = ServiceProviderInitStages.errorOnHighSeverity;

            /// If severity is [none] then, it should be check by the widget itself instad of being a general issue.-
            break;
          default:
            break;
        }
        ErrorHandler stdError = StandarizeErrors.standarizeErrors(pData);
        var rError = ErrorHandler(
          errorCode: pData.errorCode,
          errorDsc: '${pData.errorDsc}\r\n${stdError.errorDsc}',
        );
        updateListeners(calledFrom: functionName);
        if (debug) {
          developer.log(
            'DoLoginCallback => Error received: ${rError.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        rMessageResponse.finalResponse = rError;
        rMessageResponse.status = "ok";
        return rError;
      }
      if (pData.data.status == "ok") {
        //
      }
      final ServiceProviderLoginDataUserMessageModel rDataData =
          _extractLoginUserFromWholeMessage(
        message: pData,
        functionName: functionName,
      );

      _applyAuthenticatedUserContext(
        user: rDataData,
      );

      var rError = ErrorHandler(
        errorCode: 0,
        errorDsc: 'Login successful.',
        className: className,
        functionName: functionName,
        data: rDataData,
      );
      // isUserLoggedIn = true;
      // loggedUser = pData.data.data.records.first;
      updateListeners(calledFrom: functionName);
      _finalizeTrackedCallbackResponse(
        messageResponse: rMessageResponse,
        response: rError,
      );
      if (debug) {
        developer.log(
          'DoLoginCallback => Backend status checked successfully.',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rError;
    } catch (e, stacktrace) {
      if (debug) {
        developer.log(
          'DoLoginCallback => Error processing callback: $e',
          name: '$logClassName - $logFunctionName',
        );
      }

      /// Ocurrió un error (fue throw)
      ///
      var rError = ErrorHandler(byDefault: true);
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rError = e;
      } else {
        rError = ErrorHandler(
          errorCode: 9999,
          errorDsc: e.toString(),
          className: className,
          functionName: functionName,
          stacktrace: stacktrace,
          propertyName: 'paramCallBack',
        );
      }
      updateListeners(calledFrom: functionName);
      // rMessageResponse.finalResponse = initStageError!;
      // rMessageResponse.status = "ok";
      return rError;
    }
  }

  /// This function allows to send message from client to server using websocket
  ///
  ///
  Future<ErrorHandler> sendMessageV2({
    required Map<String, dynamic> pData,
    bool isAsync = true,
    bool pNotifyListeners = true,
    bool pShowWorkInProgress = false,
    CommonRPCMessageResponseCallBack? callBackFunction,
    Duration? pTimeOut,
  }) async {
    const String functionName = 'sendMessageV2';
    const String logClassName = '.::$functionName::';
    const int apiVersion = 2;
    if (!isNew) {
      if (pData['Action'] != "Subscribe_Channel") {
        if (!pData.containsKey('ChannelName')) {
          return ErrorHandler(
            errorCode: 20000,
            errorDsc: 'You must specify a valid channel name.',
            propertyName: "ChannelName",
            propertyValue: pData['ChannelName'] ?? 'Desconocido',
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
      }
    }

    Map<String, dynamic> pRequest = {};
    var messageID = Utils.generateRandomString(128);
    pRequest['AppVersion'] = gAppVersion;
    pRequest['Platform'] = Utils.isPlatform;
    pRequest['TokenID'] = sessionTokenID;
    pRequest['Action'] = pData['Action'];
    if (!isNew && pData['Action'] != "Subscribe_Channel") {
      pRequest['ChannelName'] = pData['ChannelName'];
    }
    if (pData['ChannelsName'] != null) {
      pRequest['ChannelsName'] = pData['ChannelsName'];
    }
    pRequest['MessageID'] = messageID;
    pRequest['APIVersion'] = apiVersion;
    pRequest['ParamRequest'] = pData['pParams'];
    if (debug) {
      developer.log(
        'Sending message with ID: $messageID, Action: ${pData['Action']}, Channels: ${pData['ChannelsName'] ?? 'N/A'}',
        name: '$logClassName - $functionName',
      );
    }

    /// Save the message to INIT so it is in memory before sending
    ///
    await wssMessagesTrackingV2.set(
        messageID,
        CommonRPCMessageResponse.fromRPCCall(
          messageID: messageID,
          status: 'init',
          pParamsRequest: pRequest,
          pShowWorkInPgress: pShowWorkInProgress,
          pTimeOut: pTimeOut,
          callbackFunction: callBackFunction,
        ));

    /// Encode to JSON format
    ///
    String jsonMessage = json.encode(pRequest);

    /// Send the message to backend
    ///
    var rResult = await wssClient.sendMessageV2(
      jsonMessage: jsonMessage,
      messageID: messageID,
      apiVersion: apiVersion,
    );
    if (rResult.errorCode != 0) {
      if (pNotifyListeners) {
        updateListeners(calledFrom: functionName);
      }
      return rResult;
    }
    await wssMessagesTrackingV2.status(messageID, 'sent');
    if (pNotifyListeners) {
      updateListeners(calledFrom: functionName);
    }
    return rResult;
  }

  void logout() {
    _resetAuthenticatedRuntimeState();
    getBackendStatus();
  }

  void setCurrentCliente(int clientID) {
    const String functionName = 'setCurrentCliente';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        'Setting current client to $clientID - ${loggedUser?.clientes.length}',
        name: '$className - $logFunctionName',
      );
    }
    if (loggedUser != null && loggedUser!.clientes.length >= clientID) {
      var nClient = loggedUser!.clientes[clientID];

      if (debug) {
        developer.log(
          'Setting current client to $clientID - ${nClient.codClie} ${nClient.razonSocial}',
          name: '$className - $logFunctionName',
        );
      }
      loggedUser!.cCliente = clientID;
      updateListeners(calledFrom: 'setCurrentCliente');
    }
  }

  updateListeners({
    String calledFrom = '',
  }) {
    const String functionName = 'updateListeners';
    const logFunctionName = '.::$functionName::.';
    if (debug) {
      developer.log(
        'UpdateListeners=> from:$calledFrom',
        name: '$logClassName - $logFunctionName',
      );
    }
    notifyListeners();
  }

  Future<ErrorHandler> saveFileOnLocalDisk({
    required CommonFileDescriptorModel pFile,
    String pSubFolder = "",
  }) async {
    const String functionName = 'saveFileOnLocalDisk';
    const logFunctionName = '.::$functionName::.';
    try {
      final saver = FileSaver();
      var rResult = await saver.saveFileOnLocalDisk(pFile: pFile);
      if (debug) {
        developer.log(
          '${LogIcons.arrowLeft} Error saving file on local disk: ${rResult.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rResult;
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        e.stacktrace ?? stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 8888,
          errorDsc: '''Error desconocido.
          Error: ${e.toString()}
          ''',
          stacktrace: stacktrace,
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'wssURI': wssURI,
      'debug': debug,
      'connMaxRetry': connMaxRetry,
      'connRetry': connRetry,
      'isUserLoggedIn': isUserLoggedIn,
      'isProgress': isProgress,
      'lastError': lastError,
      'wssMessagesTrackingV2': wssMessagesTrackingV2,
      'isNew': isNew,
      'sessionTokenID': sessionTokenID,
      'isReady': isReady,
      'maxConnRetry': maxConnRetry,
      'initStage': initStage,
      'initStageAdditionalMsg': initStageAdditionalMsg,
      'initStageError': initStageError,
      'canRetry': canRetry,
      'channels': channels,
      'loggedUser': loggedUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'wssURI': wssURI,
      'debug': debug,
      'connMaxRetry': connMaxRetry,
      'connRetry': connRetry,
      'isUserLoggedIn': isUserLoggedIn,
      'isProgress': isProgress,
      'lastError': lastError,
      'wssMessagesTrackingV2': wssMessagesTrackingV2,
      'isNew': isNew,
      'sessionTokenID': sessionTokenID,
      'isReady': isReady,
      'maxConnRetry': maxConnRetry,
      'initStage': initStage,
      'initStageAdditionalMsg': initStageAdditionalMsg,
      'initStageError': initStageError,
      'canRetry': canRetry,
      'channels': channels,
      'loggedUser': loggedUser,
    };
  }

  @override
  String toString() {
    return toJson.toString();
  }
}
