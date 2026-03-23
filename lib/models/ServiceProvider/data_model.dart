import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/GeneralLoadingProgress/popup_model.dart';
import 'package:geryon_web_app_ws_v2/core/transport/geryonsocket_model.dart';
import 'package:geryon_web_app_ws_v2/models/LogIcons/model.dart';
import 'package:geryon_web_app_ws_v2/models/Login/model.dart';
import 'package:geryon_web_app_ws_v2/models/Login/widget.dart';
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
        if (debug) {
          developer.log(
            'OnData: Received [NEW] data, processing.',
            name: '$logClassName - $logFunctionName',
          );
        }

        final String tokenID = pData.data.tokenID ?? "";
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
      } else {
        if (debug) {
          developer.log(
            'OnData: Received data is [NOT NEW], processing normally.',
            name: '$logClassName - $logFunctionName',
          );
        }
        if (pData.data.messageID.isNotEmpty) {
          // APIVersion 2
          if (pData.data.apiVersion == 2) {
            CommonRPCMessageResponse? cMessageStatusV2 =
                wssMessagesTrackingV2.get(pData.data.messageID);
            if (cMessageStatusV2 != null) {
              if (cMessageStatusV2.status == "local_discard") {
                await wssMessagesTrackingV2.remove(pData.data.messageID);
              }
            }
            String status = pData.data.status;
            if (status == "ok") {
              status = "processing";
            }
            await wssMessagesTrackingV2.status(
              pData.data.messageID,
              status,
            );
            switch (pData.data.status) {
              case "ok":
                if (wssMessagesTrackingV2.hasCallback(pData.data.messageID)) {
                  // Si tiene Callback function, la remoción del mensaje debe ser llevada adelante por ldicha función
                  if (debug) {
                    developer.log(
                        '$logClassName - $logFunctionName - Calling CallBack function for MessageID: ${pData.data.messageID}');
                  }
                  bool rCall = await wssMessagesTrackingV2.execute(
                    key: pData.data.messageID,
                    pMessageID: pData.data.messageID,
                    paramCallBack: data,
                  );
                  if (rCall) {
                    return null;
                  } else {
                    return ErrorHandler(
                      errorCode: 7890,
                      errorDsc:
                          "Error al ejecutar función callback.\r\nMensaje ID: ${pData.data.messageID}\r\nStatus: ${pData.data.status}",
                      propertyName: "CallbackFunction",
                      className: className,
                    );
                  }
                } else {
                  await wssMessagesTrackingV2.remove(pData.data.messageID);
                  return null;
                }
              case "queued":
                if (wssMessagesTrackingV2.hasCallback(pData.data.messageID)) {
                  // Si tiene Callback function, la remoción del mensaje debe ser llevada adelante por ldicha función
                  if (debug) {
                    developer.log(
                        '$logClassName - $logFunctionName - Calling CallBack function for MessageID: ${pData.data.messageID}');
                  }
                  bool rCall = await wssMessagesTrackingV2.execute(
                    key: pData.data.messageID,
                    pMessageID: pData.data.messageID,
                    paramCallBack: data,
                  );
                  if (rCall) {
                    return null;
                  } else {
                    return ErrorHandler(
                      errorCode: 7890,
                      errorDsc:
                          "Error al ejecutar función callback.\r\nMensaje ID: ${pData.data.messageID}\r\nStatus: ${pData.data.status}",
                      propertyName: "CallbackFunction",
                      className: className,
                    );
                  }
                } else {
                  await wssMessagesTrackingV2.remove(pData.data.messageID);
                  return null;
                }
              default:
                return ErrorHandler(
                  errorCode: 7891,
                  errorDsc:
                      "Error del estado del mensaje recibido.\r\nMensaje ID:${pData.data.messageID}\r\nStatus: ${pData.data.status}",
                  propertyName: "Status",
                  className: className,
                );
            }
          } else {
            updateListeners(calledFrom: functionName);
            return ErrorHandler(
              errorCode: 7893,
              errorDsc:
                  '''Recibimos un mensaje con una versión de API no soportada.
                Mensaje ID: ${pData.data.messageID}
                API Version: ${pData.data.apiVersion}
                ''',
              propertyName: 'API Version',
              propertyValue: pData.data.apiVersion.toString(),
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
          }
        } else {
          updateListeners(calledFrom: functionName);
          return ErrorHandler(
            errorCode: 7892,
            errorDsc: "Recibimos un ID de Mensaje vacío.",
            propertyName: 'MessageID',
            propertyValue: pData.data.messageID,
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
      }
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        initStageError = e;
      } else {
        initStageError = ErrorHandler(
          errorCode: 9999,
          errorDsc: e.toString(),
          stacktrace: stacktrace,
        );
      }
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageAdditionalMsg = "Catched an error on $logFunctionName";
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

    Map<String, dynamic> pRequest = {};
    pRequest['ChannelName'] = 'GERYON_General';
    pRequest['Action'] = 'Get:Status';
    Map<String, dynamic> pParams = {};
    pRequest['pParams'] = pParams;
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Requesting backend status...',
        name: '$logClassName - $logFunctionName',
      );
    }
    ErrorHandler rSendMessage = await sendMessageV2(
      pData: pRequest,
      isAsync: true,
      pNotifyListeners: true,
      pShowWorkInProgress: false,
      callBackFunction: getBackendStatusCallback,
    );
    if (rSendMessage.errorCode != 0) {
      if (debug) {
        developer.log(
          '${LogIcons.arrowRight} Error sending status request: ${rSendMessage.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageError = rSendMessage;
      updateListeners(calledFrom: functionName);
      return rSendMessage;
    }
    CommonRPCMessageResponse? rMessageResponse =
        wssMessagesTrackingV2.get(rSendMessage.messageID);
    if (rMessageResponse == null) {
      var rSendMessageReturn = ErrorHandler(
        errorCode: 400000,
        errorDsc:
            'No pudimos encontrar la referencia al mensaje enviado al backend',
        messageID: rSendMessage.messageID,
        className: className,
        functionName: functionName,
        propertyName: 'MessageID',
        propertyValue: null,
        stacktrace: StackTrace.current,
      );
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageError = rSendMessageReturn;
      updateListeners(calledFrom: functionName);
      return rSendMessageReturn;
    }
    rMessageResponse.replyWithError = false;
    rMessageResponse.localError = null;
    whileLoop:
    while (true) {
      if (rMessageResponse.recordOldHash !=
          rMessageResponse.recordNew.hashCode) {
        break;
      } else {
        switch (rMessageResponse.status) {
          case "init":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} is initialized but not sent yet to backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "sent":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} sent to backend. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "queued":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} queued for processing. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "processing":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} replied from backend. Processing reply received',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "ok":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} processed from backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400001,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: rMessageResponse.messageID,
              className: className,
              functionName: functionName,
              propertyName: 'Status',
              propertyValue: rMessageResponse.status,
              stacktrace: StackTrace.current,
            );
        } // switch (rMessageResponse.status)
      } // if (rMessageResponse.recordOldHash != rMessageResponse.recordNew.hashCode)
      /// Wait for [data] to be updated
      ///
      await Future.delayed(const Duration(milliseconds: 100));
      rMessageResponse.timeElapsed += const Duration(milliseconds: 100);
      Duration pRealTimeout = rMessageResponse.timeOut;
      if (rMessageResponse.timeElapsed >= pRealTimeout) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} timed out after ${pRealTimeout.inSeconds} seconds.',
            name: '$logClassName - $logFunctionName',
          );
        }
        switch (rMessageResponse.status) {
          case "init":
          case "sent":
          case "queued":
            if (debug) {
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                  name: '$logClassName - $logFunctionName',
                );
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 4000029999,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "processing":
            if (debug) {
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                  name: '$logClassName - $logFunctionName',
                );
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 400009,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "ok":
            if (debug) {
              developer.log(
                'Message ${rMessageResponse.messageID} proccessed from backend.',
                name: '$logClassName - $logFunctionName',
              );
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
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
        } // switch (rMessageResponse.status)
      } // Wait for [data] to be updated
    } // while (true)
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
      await wssMessagesTrackingV2.remove(rSendMessage.messageID);
    }
    if (rFinalResponse.errorCode != 0) {
      if (debug) {
        developer.log(
          '${LogIcons.arrowLeft} Error received from backend: ${rFinalResponse.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      initStage = ServiceProviderInitStages.errorRequestingBackend;
      initStageError = rFinalResponse;
      updateListeners(calledFrom: functionName);
      return rFinalResponse;
    } else {
      if (debug) {
        developer.log(
          '${LogIcons.arrowLeft} Backend status checked successfully: ${rFinalResponse.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      initStage = ServiceProviderInitStages.connected;
      initStageAdditionalMsg = 'Backend status checked successfully.';
      isReady = true;
      //isProgress = false;
      updateListeners(calledFrom: functionName);
      // Backend status is OK, we can proceed
      // Check if we have a logged user
      ErrorHandler rCheckLoggedUser = await doCheckLogin();
      if (rCheckLoggedUser.errorCode != 0) {
        if (debug) {
          developer.log(
            'GetBackendStatus => Error checking logged user: ${rCheckLoggedUser.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        if (rCheckLoggedUser.errorCode == -1000 ||
            rCheckLoggedUser.errorCode == 1001 ||
            rCheckLoggedUser.errorCode == 1002) {
          developer.log(
            '-1000 1 => $navigatorKey ${navigatorKey.currentState}',
            name: '$logClassName - $logFunctionName',
          );

          /// If the error is -1000, it means that the user is not logged in
          /// and we should show the login dialog.
          if (navigatorKey.currentState != null) {
            developer.log(
              '-1000 2 => $navigatorKey ${navigatorKey.currentState}',
              name: '$logClassName - $logFunctionName',
            );
            var rLogin = await navigatorKey.currentState
                ?.push(PopUpLoginWidget<ErrorHandler>());
            developer.log(
              '-1000 3 => $navigatorKey ${navigatorKey.currentState} $rLogin',
              name: '$logClassName - $logFunctionName',
            );

            if (rLogin != null) {
              if (rLogin.errorCode != 0) {
                /// If the login failed, we should set the error and update the listeners
                if (debug) {
                  developer.log(
                    'GetBackendStatus => Login failed: ${rLogin.toString()}',
                    name: '$logClassName - $logFunctionName',
                  );
                }
                initStageError = rLogin;
                initStage = ServiceProviderInitStages.errorRequestingBackend;
                updateListeners(calledFrom: functionName);
                return rLogin;
              } else {
                /// If the login was successful, we can proceed
                if (debug) {
                  developer.log(
                    'GetBackendStatus => User logged in successfully: ${rLogin.toString()}',
                    name: '$logClassName - $logFunctionName',
                  );
                }
                _applyAuthenticatedUserContext(
                  user: rLogin.data as ServiceProviderLoginDataUserMessageModel,
                );
                initStage = ServiceProviderInitStages.connected;
                initStageAdditionalMsg = 'User logged in successfully.';
                initStageError = rLogin;
                isReady = true;
                isProgress = false;
                updateListeners(calledFrom: functionName);
                return rLogin;
              }
            }
          }
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
            'GetBackendStatusCallback => Message is queued, waiting for processing.',
            name: '$logClassName - $logFunctionName',
          );
          return noError;
        }
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

    /// Error Codes:
    /// -1000: user is not logged-in. MUST FORCE login
    /// -1001: user is logged-in. I MUST validate against backend.
    /// -1002: user validation (from -1001) has failed. MUST FORCE login again.
    /// 0: user is logged (no matter what)
    initStage = ServiceProviderInitStages.checkingLoginStatus;
    initStageAdditionalMsg = "";
    updateListeners(calledFrom: functionName);
    if (loggedUser == null) {
      /// User is not logged at all. Not even once.
      initStage = ServiceProviderInitStages.userIsNotloggedIn;
      initStageAdditionalMsg = "";
      updateListeners(calledFrom: functionName);
      return ErrorHandler(
        errorCode: -1000,
        errorDsc: 'User is not logged in.',
        className: className,
        functionName: functionName,
      );
    }
    _resetAuthenticatedRuntimeState(clearLoggedUser: false);
    return ErrorHandler(
      errorCode: -1001,
      errorDsc: 'User is not logged in. <<FORCED>>',
      className: className,
      functionName: functionName,
    );

    // Map<String, dynamic> pRequest = {};
    // pRequest['ChannelName'] = 'GERYON_General';
    // pRequest['Action'] = 'Get:LoggedUser';
    // Map<String, dynamic> pParams = {};
    // pParams['JSON_Data'] = true;
    // pParams['UserRememberMe'] = true;
    // pParams['UserEmail'] = loggedUser!.userEMail;
    // pParams['UserPassword'] = 'password';
    // pParams['UserHashConfirm'] = loggedUser!.userHashConfirm;
    // pParams['UserPreferredLanguage'] = 'es-AR';
    // pParams['ActionRequest'] = 'Auth:ValidateSessionLogin';
    // pParams['FormAction'] = '';
    // pParams['GRecaptchaResponse'] = '';
    // pParams['Lang'] = 'es-AR';
    // pParams['Location'] = '';
    // pRequest['pParams'] = pParams;
    // ErrorHandler rSendMessage = await sendMessageV2(
    //   pData: pRequest,
    //   isAsync: true,
    //   pNotifyListeners: true,
    //   pShowWorkInProgress: false,
    //   callBackFunction: doCheckLoginCallback,
    // );
    // if (rSendMessage.errorCode != 0) {
    //   if (debug) {
    //     developer.log(
    //       'DoCheckLogin => Error sending check login request: ${rSendMessage.toString()}',
    //       name: '$logClassName - $logFunctionName',
    //     );
    //   }
    //   return rSendMessage;
    // }
    // CommonRPCMessageResponse? rMessageResponse =
    //     wssMessagesTrackingV2.get(rSendMessage.messageID);
    // if (rMessageResponse == null) {
    //   var rSendMessageReturn = ErrorHandler(
    //     errorCode: 400000,
    //     errorDsc:
    //         'No pudimos encontrar la referencia al mensaje enviado al backend',
    //     messageID: rSendMessage.messageID,
    //     className: className,
    //     functionName: functionName,
    //     propertyName: 'MessageID',
    //     propertyValue: null,
    //     stacktrace: StackTrace.current,
    //   );
    //   return rSendMessageReturn;
    // }
    // rMessageResponse.replyWithError = false;
    // rMessageResponse.localError = null;
    // whileLoop:
    // while (true) {
    //   if (rMessageResponse.recordOldHash !=
    //       rMessageResponse.recordNew.hashCode) {
    //     break;
    //   } else {
    //     switch (rMessageResponse.status) {
    //       case "init":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} is initialized but not sent yet to backend.',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break;
    //       case "sent":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} sent to backend. Waiting response from server',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break;
    //       case "queued":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} queued for processing. Waiting response from server',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break;
    //       case "processing":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} replied from backend. Processing reply received',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break;
    //       case "ok":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} proccessed from backend.',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break whileLoop;
    //       default:
    //         return ErrorHandler(
    //           errorCode: 400001,
    //           errorDsc:
    //               'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
    //           messageID: rMessageResponse.messageID,
    //           className: className,
    //           functionName: functionName,
    //           propertyName: 'Status',
    //           propertyValue: rMessageResponse.status,
    //           stacktrace: StackTrace.current,
    //         );
    //     } // switch (rMessageResponse.status)
    //   } // if (rMessageResponse.recordOldHash != rMessageResponse.recordNew.hashCode)
    //   /// Wait for [data] to be updated
    //   ///
    //   await Future.delayed(const Duration(milliseconds: 100));
    //   rMessageResponse.timeElapsed += const Duration(milliseconds: 100);
    //   Duration pRealTimeout = rMessageResponse.timeOut;
    //   if (rMessageResponse.timeElapsed > pRealTimeout) {
    //     if (debug) {
    //       developer.log(
    //         'Message ${rMessageResponse.messageID} timed out after ${pRealTimeout.inSeconds} seconds.',
    //         name: '$logClassName - $logFunctionName',
    //       );
    //     }
    //     switch (rMessageResponse.status) {
    //       case "init":
    //       case "sent":
    //       case "queued":
    //         if (debug) {
    //           if (debug) {
    //             developer.log(
    //               'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
    //               name: '$logClassName - $logFunctionName',
    //             );
    //           }
    //         }
    //         rMessageResponse.localError = ErrorHandler(
    //           errorCode: 4000029999,
    //           errorDsc:
    //               'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
    //           propertyName: 'Status => timeout',
    //           propertyValue: rMessageResponse.status,
    //           className: className,
    //           functionName: functionName,
    //           stacktrace: StackTrace.current,
    //         );
    //         break whileLoop;
    //       case "processing":
    //         if (debug) {
    //           if (debug) {
    //             developer.log(
    //               'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
    //               name: '$logClassName - $logFunctionName',
    //             );
    //           }
    //         }
    //         rMessageResponse.localError = ErrorHandler(
    //           errorCode: 400009,
    //           errorDsc:
    //               'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
    //           propertyName: 'Status => timeout',
    //           propertyValue: rMessageResponse.status,
    //           className: className,
    //           functionName: functionName,
    //           stacktrace: StackTrace.current,
    //         );
    //         break whileLoop;
    //       case "ok":
    //         if (debug) {
    //           developer.log(
    //             'Message ${rMessageResponse.messageID} proccessed from backend.',
    //             name: '$logClassName - $logFunctionName',
    //           );
    //         }
    //         break whileLoop;
    //       default:
    //         return ErrorHandler(
    //           errorCode: 400010,
    //           errorDsc:
    //               'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
    //           messageID: rMessageResponse.messageID,
    //           propertyName: 'Status',
    //           propertyValue: rMessageResponse.status,
    //           className: className,
    //           functionName: functionName,
    //           stacktrace: StackTrace.current,
    //         );
    //     } // switch (rMessageResponse.status)
    //   } // Wait for [data] to be updated
    // } // while (true)
    // ErrorHandler rFinalResponse = rMessageResponse.finalResponse;
    // if (rMessageResponse.status == "ok") {
    //   if (rMessageResponse.isWorkInProgress) {
    //     while (true) {
    //       if (!rMessageResponse.isWorkInProgress) {
    //         break;
    //       }
    //       await Future.delayed(const Duration(milliseconds: 100));
    //     }
    //   }
    //   await wssMessagesTrackingV2.remove(rSendMessage.messageID);
    // }
    // if (rFinalResponse.errorCode != 0) {
    //   if (debug) {
    //     developer.log(
    //       'DoCheckLogin => Error received from backend: ${rFinalResponse.toString()}',
    //       name: '$logClassName - $logFunctionName',
    //     );
    //   }
    //   initStage = ServiceProviderInitStages.errorRequestingBackend;
    //   initStageError = rFinalResponse;
    //   updateListeners(calledFrom: functionName);
    //   return rFinalResponse;
    // } else {
    //   if (debug) {
    //     developer.log(
    //       'DoCheckLogin => Backend status checked successfully: ${rFinalResponse.toString()}',
    //       name: '$logClassName - $logFunctionName',
    //     );
    //   }
    //   initStage = ServiceProviderInitStages.userIsloggedIn;
    //   initStageAdditionalMsg = 'Backend status checked successfully.';
    //   isReady = true;
    //   isProgress = false;
    //   updateListeners(calledFrom: functionName);
    //   // Backend status is OK, we can proceed
    //   // Check if we have a logged user
    //   ErrorHandler rCheckLoggedUser = await doCheckLogin();

    //   if (rCheckLoggedUser.errorCode == 0) {
    //     isReady = true;
    //     isProgress = false;
    //     initStage = ServiceProviderInitStages.connected;
    //     initStageAdditionalMsg = "";
    //     return rCheckLoggedUser;
    //   } else if (rCheckLoggedUser.errorCode == -1000) {
    //     developer.log(
    //       'DoCheckLogin => User is not logged in, showing login popup.',
    //       name: '$logClassName - $logFunctionName',
    //     );
    //     if (navigatorKey.currentState != null) {
    //       var rLogin = await navigatorKey.currentState!
    //           .push(PopUpLoginWidget<ErrorHandler>());
    //       if (rLogin != null) {
    //         if (rLogin.errorCode != 0) {
    //           /// If the login failed, we should set the error and update the listeners
    //           if (debug) {
    //             developer.log(
    //               'DoCheckLogin => Login failed: ${rLogin.toString()}',
    //               name: '$logClassName - $logFunctionName',
    //             );
    //           }
    //           initStageError = rLogin;
    //           initStage = ServiceProviderInitStages.errorRequestingBackend;
    //           updateListeners(calledFrom: functionName);
    //           return rLogin;
    //         } else {
    //           /// If the login was successful, we can proceed
    //           initStage = ServiceProviderInitStages.userIsloggedIn;
    //           initStageAdditionalMsg = rLogin.data?.toString() ?? '';
    //           initStageError = rLogin;
    //           isUserLoggedIn = true;

    //           loggedUser =
    //               rLogin.data as ServiceProviderLoginDataUserMessageModel?;
    //           updateListeners(calledFrom: functionName);
    //           return rLogin;
    //         }
    //       }
    //     }
    //   } else if (rCheckLoggedUser.errorCode == -10010) {
    //     isReady = false;
    //     isProgress = false;
    //     initStage = ServiceProviderInitStages.userIsloggedIn;
    //     initStageAdditionalMsg = "";
    //     updateListeners(calledFrom: functionName);
    //     return rCheckLoggedUser;
    //   }

    //   if (rCheckLoggedUser.errorCode != 0) {
    //     if (debug) {
    //       developer.log(
    //         'DoCheckLogin => Error checking logged user: ${rCheckLoggedUser.toString()}',
    //         name: '$logClassName - $logFunctionName',
    //       );
    //     }
    //     initStage = ServiceProviderInitStages.errorRequestingBackend;
    //     initStageError = rCheckLoggedUser;
    //     updateListeners(calledFrom: functionName);
    //     return rCheckLoggedUser;
    //   }
    //   if (debug) {
    //     developer.log(
    //       'DoCheckLogin => Logged user checked successfully: ${rCheckLoggedUser.toString()}',
    //       name: '$logClassName - $logFunctionName',
    //     );
    //   }
    //   isReady = true;
    //   isProgress = false;
    //   initStage = ServiceProviderInitStages.connected;
    //   initStageAdditionalMsg = null;
    //   updateListeners(calledFrom: functionName);
    //   return ErrorHandler(
    //     errorCode: 0,
    //     errorDsc: 'Backend status checked successfully.',
    //     className: className,
    //     functionName: functionName,
    //   );
    // }
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
      ServiceProviderLoginDataUserMessageModel? rDataData;
      if (pData.data.data is Map<String, dynamic>) {
        var m1 = pData.data.data as Map<String, dynamic>;
        if (m1["Records"] is List<dynamic>) {
          var m2 = m1["Records"] as List<dynamic>;
          if (m2.isNotEmpty) {
            rDataData =
                ServiceProviderLoginDataUserMessageModel.fromJson(m2.first);
          } else {
            return ErrorHandler(
              errorCode: 10001,
              errorDsc: 'No records found in response data.',
              className: className,
              functionName: functionName,
            );
          }
        } else {
          return ErrorHandler(
            errorCode: 10002,
            errorDsc: 'Invalid data format received from backend.',
            className: className,
            functionName: functionName,
          );
        }
      }

      _applyAuthenticatedUserContext(
        user: rDataData!,
      );
      updateListeners(calledFrom: functionName);
      if (debug) {
        developer.log(
          'DoCheckLoginCallback => Logged user checked successfully: ${loggedUser.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'Logged user checked successfully.',
        className: className,
        functionName: functionName,
        data: loggedUser,
      );
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

      Map<String, dynamic> pRequest = {};
      pRequest['Action'] = 'Subscribe_Channel';
      List<String> sChannels = [];
      for (ServiceProviderChannel channel in channels) {
        //if (channel.isSubscribed) continue;
        sChannels.add(channel.name);
        if (debug) {
          developer.log(
            'Adding ${channel.name} to subscription list',
            name: '$logClassName - $logFunctionName',
          );
        }
      }
      pRequest['ChannelsName'] = sChannels;
      Map<String, dynamic> pParams = {};
      pRequest['pParams'] = pParams;
      if (debug) {
        developer.log(
          'SubscribeChannel => Requesting subscription to channels: $sChannels',
          name: '$logClassName - $logFunctionName',
        );
      }
      ErrorHandler rSendMessage = await sendMessageV2(
        pData: pRequest,
        isAsync: true,
        pNotifyListeners: true,
        pShowWorkInProgress: false,
        callBackFunction: subscribeChannelCallback,
      );
      if (rSendMessage.errorCode != 0) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowRight} Error sending subscription request: ${rSendMessage.toString()}',
            name: '$logClassName - $logFunctionName',
          );
        }
        initStage = ServiceProviderInitStages.errorRequestingBackend;
        initStageError = rSendMessage;
        updateListeners(calledFrom: functionName);
        return rSendMessage;
      }
      CommonRPCMessageResponse? rMessageResponse =
          wssMessagesTrackingV2.get(rSendMessage.messageID);
      if (rMessageResponse == null) {
        var rSendMessageReturn = ErrorHandler(
          errorCode: 400000,
          errorDsc:
              'No pudimos encontrar la referencia al mensaje enviado al backend',
          messageID: rSendMessage.messageID,
          className: className,
          functionName: functionName,
          propertyName: 'MessageID',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
        initStage = ServiceProviderInitStages.errorRequestingBackend;
        initStageError = rSendMessageReturn;
        updateListeners(calledFrom: functionName);
        return rSendMessageReturn;
      }
      rMessageResponse.replyWithError = false;
      rMessageResponse.localError = null;
      whileLoop:
      while (true) {
        if (rMessageResponse.recordOldHash !=
            rMessageResponse.recordNew.hashCode) {
          break;
        } else {
          switch (rMessageResponse.status) {
            case "init":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} is initialized but not sent yet to backend.',
                  name: '$logClassName - $logFunctionName',
                );
              }
              break;
            case "sent":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} sent to backend. Waiting response from server',
                  name: '$logClassName - $logFunctionName',
                );
              }
              break;
            case "queued":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} queued for processing. Waiting response from server',
                  name: '$logClassName - $logFunctionName',
                );
              }
              break;
            case "processing":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} replied from backend. Processing reply received',
                  name: '$logClassName - $logFunctionName',
                );
              }
              break;
            case "ok":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} proccessed from backend.',
                  name: '$logClassName - $logFunctionName',
                );
              }
              break whileLoop;
            default:
              return ErrorHandler(
                errorCode: 400001,
                errorDsc:
                    'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
                messageID: rMessageResponse.messageID,
                className: className,
                functionName: functionName,
                propertyName: 'Status',
                propertyValue: rMessageResponse.status,
                stacktrace: StackTrace.current,
              );
          } // switch (rMessageResponse.status)
        } // if (rMessageResponse.recordOldHash != rMessageResponse.recordNew.hashCode)
        /// Wait for [data] to be updated
        ///
        await Future.delayed(const Duration(milliseconds: 100));
        rMessageResponse.timeElapsed += const Duration(milliseconds: 100);
        Duration pRealTimeout = rMessageResponse.timeOut;
        if (rMessageResponse.timeElapsed > pRealTimeout) {
          if (debug) {
            developer.log(
              'Message ${rMessageResponse.messageID} timed out after ${pRealTimeout.inSeconds} seconds.',
              name: '$logClassName - $logFunctionName',
            );
          }
          switch (rMessageResponse.status) {
            case "init":
            case "sent":
            case "queued":
              if (debug) {
                if (debug) {
                  developer.log(
                    'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                    name: '$logClassName - $logFunctionName',
                  );
                }
              }
              rMessageResponse.localError = ErrorHandler(
                errorCode: 4000029999,
                errorDsc:
                    'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
                propertyName: 'Status => timeout',
                propertyValue: rMessageResponse.status,
                className: className,
                functionName: functionName,
                stacktrace: StackTrace.current,
              );
              break whileLoop;
            case "processing":
              if (debug) {
                if (debug) {
                  developer.log(
                    'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                    name: '$logClassName - $logFunctionName',
                  );
                }
              }
              rMessageResponse.localError = ErrorHandler(
                errorCode: 400009,
                errorDsc:
                    'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
                propertyName: 'Status => timeout',
                propertyValue: rMessageResponse.status,
                className: className,
                functionName: functionName,
                stacktrace: StackTrace.current,
              );
              break whileLoop;
            case "ok":
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} proccessed from backend.',
                  name: '$logClassName - $logFunctionName',
                );
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
                className: className,
                functionName: functionName,
                stacktrace: StackTrace.current,
              );
          } // switch (rMessageResponse.status)
        } // Wait for [data] to be updated
      } // while (true)
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
        if (rMessageResponse.counter == channels.length) {
          await wssMessagesTrackingV2.remove(rSendMessage.messageID);
        }
      }
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
            'SubscribeChannelCallback => Message is queued, waiting for processing.',
            name: '$logClassName - $logFunctionName',
          );
          return noError;
        }
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
        rMessageResponse.finalResponse = initStageError!;
        rMessageResponse.status = "ok";
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
        rMessageResponse.finalResponse = initStageError!;
        rMessageResponse.status = "ok";
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
        if (channels.where((element) => element.status != null).isEmpty) {
          /// If all channels are subscribed, then we can set the initStage to subscribed
          if (debug) {
            developer.log(
              'SubscribeChannelCallback => All channels subscribed successfully.',
              name: '$logClassName - $logFunctionName',
            );
          }
          initStage = ServiceProviderInitStages.subscribed;
          initStageAdditionalMsg = "Suscritos a ${channels.length} canales.";
          initStageError = ErrorHandler(
            errorCode: 0,
            errorDsc: 'All channels subscribed successfully.',
            className: className,
            functionName: functionName,
          );
          updateListeners(calledFrom: functionName);
          rMessageResponse.finalResponse = initStageError!;
          rMessageResponse.status = "ok";
          return initStageError!;
        } else {
          if (debug) {
            developer.log(
              'SubscribeChannelCallback => Channel ${pData.data.channelName} subscribed successfully.',
              name: '$logClassName - $logFunctionName',
            );
          }
          if (rMessageResponse.counter == channels.length) {
            /// If all channels are at least proccessed, then we can set the initStage to subscribed
            if (debug) {
              developer.log(
                'SubscribeChannelCallback => All channels PROCESADOS successfully.',
                name: '$logClassName - $logFunctionName',
              );
            }
            initStage = ServiceProviderInitStages.subscribed;
            initStageAdditionalMsg = "All channels subscribed successfully.";
            initStageError = ErrorHandler(
              errorCode: 0,
              errorDsc:
                  "Suscritos a ${rMessageResponse.counter} de ${channels.length} canales.",
              className: className,
              functionName: functionName,
            );
            updateListeners(calledFrom: functionName);
            rMessageResponse.finalResponse = initStageError!;
            rMessageResponse.status = "ok";
            return initStageError!;
          } else {
            if (debug) {
              developer.log(
                'SubscribeChannelCallback => Channel ${pData.data.channelName} subscribed successfully, but not all channels are subscribed yet.',
                name: '$logClassName - $logFunctionName',
              );
            }

            /// If not all channels are subscribed, then we can set the initStage to subscribing
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
            if (debug) {
              developer.log(
                'SubscribeChannelCallback => Not all channels are subscribed yet, waiting for more responses.',
                name: '$logClassName - $logFunctionName',
              );
            }
            rMessageResponse.finalResponse = initStageError!;
            rMessageResponse.status = "ok";
            return initStageError!;
          }
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
        '${LogIcons.arrowRight} Requesting backend status...',
        name: '$logClassName - $logFunctionName',
      );
    }
    Map<String, dynamic> pRequest = {};
    pRequest['ChannelName'] = 'GERYON_General';
    pRequest['Action'] = 'CustomRequest';
    Map<String, dynamic> pParams = {};
    pParams['JSON_Data'] = true;
    pParams['UserRememberMe'] = pLogin.rememberMe;
    pParams['UserDNI'] = pLogin.dni;
    pParams['UserEmail'] = "";
    pParams['UserPassword'] = "";
    pParams['UserPreferredLanguage'] = "es-AR";
    pParams['ActionRequest'] = 'Auth:Login';
    pParams['FormAction'] = '';
    pParams['GRecaptchaResponse'] = '';
    pParams['Lang'] = "es-AR";
    pParams['Location'] = '';
    pParams['LocalParams'] = {
      'Target': "customers",
    };

    pRequest['pParams'] = pParams;
    if (debug) {
      developer.log(
        '${LogIcons.arrowRight} Requesting backend status...',
        name: '$logClassName - $logFunctionName',
      );
    }
    ErrorHandler rSendMessage = await sendMessageV2(
      pData: pRequest,
      isAsync: true,
      pNotifyListeners: true,
      pShowWorkInProgress: false,
      callBackFunction: doLoginCallback,
    );
    if (rSendMessage.errorCode != 0) {
      if (debug) {
        developer.log(
          '${LogIcons.arrowRight} Error sending status request: ${rSendMessage.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      updateListeners(calledFrom: functionName);
      return rSendMessage;
    }
    CommonRPCMessageResponse? rMessageResponse =
        wssMessagesTrackingV2.get(rSendMessage.messageID);
    if (rMessageResponse == null) {
      var rSendMessageReturn = ErrorHandler(
        errorCode: 400000,
        errorDsc:
            'No pudimos encontrar la referencia al mensaje enviado al backend',
        messageID: rSendMessage.messageID,
        className: className,
        functionName: functionName,
        propertyName: 'MessageID',
        propertyValue: null,
        stacktrace: StackTrace.current,
      );
      updateListeners(calledFrom: functionName);
      return rSendMessageReturn;
    }
    rMessageResponse.replyWithError = false;
    rMessageResponse.localError = null;
    whileLoop:
    while (true) {
      if (rMessageResponse.recordOldHash !=
          rMessageResponse.recordNew.hashCode) {
        break;
      } else {
        switch (rMessageResponse.status) {
          case "init":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} is initialized but not sent yet to backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "sent":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} sent to backend. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "queued":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} queued for processing. Waiting response from server',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "processing":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} replied from backend. Processing reply received',
                name: '$logClassName - $logFunctionName',
              );
            }
            break;
          case "ok":
            if (debug) {
              developer.log(
                '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} processed from backend.',
                name: '$logClassName - $logFunctionName',
              );
            }
            break whileLoop;
          default:
            return ErrorHandler(
              errorCode: 400001,
              errorDsc:
                  'Se produjo un error al leer el estado de respuesta del mensaje enviado al backend.',
              messageID: rMessageResponse.messageID,
              className: className,
              functionName: functionName,
              propertyName: 'Status',
              propertyValue: rMessageResponse.status,
              stacktrace: StackTrace.current,
            );
        } // switch (rMessageResponse.status)
      } // if (rMessageResponse.recordOldHash != rMessageResponse.recordNew.hashCode)
      /// Wait for [data] to be updated
      ///
      await Future.delayed(const Duration(milliseconds: 100));
      rMessageResponse.timeElapsed += const Duration(milliseconds: 100);
      Duration pRealTimeout = rMessageResponse.timeOut;
      if (rMessageResponse.timeElapsed >= pRealTimeout) {
        if (debug) {
          developer.log(
            '${LogIcons.arrowLeft} Message ${rMessageResponse.messageID} timed out after ${pRealTimeout.inSeconds} seconds.',
            name: '$logClassName - $logFunctionName',
          );
        }
        switch (rMessageResponse.status) {
          case "init":
          case "sent":
          case "queued":
            if (debug) {
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                  name: '$logClassName - $logFunctionName',
                );
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 4000029999,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "processing":
            if (debug) {
              if (debug) {
                developer.log(
                  'Message ${rMessageResponse.messageID} is [${rMessageResponse.status}] but a timeout occured',
                  name: '$logClassName - $logFunctionName',
                );
              }
            }
            rMessageResponse.localError = ErrorHandler(
              errorCode: 400009,
              errorDsc:
                  'Ocurrió un error de timeout del mensaje con estado [${rMessageResponse.status}]',
              propertyName: 'Status => timeout',
              propertyValue: rMessageResponse.status,
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
            break whileLoop;
          case "ok":
            if (debug) {
              developer.log(
                'Message ${rMessageResponse.messageID} proccessed from backend.',
                name: '$logClassName - $logFunctionName',
              );
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
              className: className,
              functionName: functionName,
              stacktrace: StackTrace.current,
            );
        } // switch (rMessageResponse.status)
      } // Wait for [data] to be updated
    } // while (true)
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
      await wssMessagesTrackingV2.remove(rSendMessage.messageID);
    }
    if (rFinalResponse.errorCode != 0) {
      if (debug) {
        developer.log(
          '${LogIcons.arrowLeft} Error received from backend: ${rFinalResponse.toString()}',
          name: '$logClassName - $logFunctionName',
        );
      }
      return rFinalResponse;
    } else {
      return rFinalResponse;
    }
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
            'DoLoginCallback => Message is queued, waiting for processing.',
            name: '$logClassName - $logFunctionName',
          );
          return noError;
        }
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
      ServiceProviderLoginDataUserMessageModel? rDataData;
      if (pData.data.data is Map<String, dynamic>) {
        var m1 = pData.data.data as Map<String, dynamic>;
        if (m1["Records"] is List<dynamic>) {
          var m2 = m1["Records"] as List<dynamic>;
          if (m2.isNotEmpty) {
            rDataData =
                ServiceProviderLoginDataUserMessageModel.fromJson(m2.first);
          } else {
            return ErrorHandler(
              errorCode: 10001,
              errorDsc: 'No records found in response data.',
              className: className,
              functionName: functionName,
            );
          }
        } else {
          return ErrorHandler(
            errorCode: 10002,
            errorDsc: 'Invalid data format received from backend.',
            className: className,
            functionName: functionName,
          );
        }
      }

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
      rMessageResponse.finalResponse = rError;
      rMessageResponse.status = "ok";
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
