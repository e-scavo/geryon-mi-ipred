import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';

class ModelGeneralLoadingProgress extends ConsumerStatefulWidget {
  const ModelGeneralLoadingProgress({
    super.key,
  });

  @override
  ConsumerState<ModelGeneralLoadingProgress> createState() =>
      _ModelGeneralLoadingProgressState();
}

class _ModelGeneralLoadingProgressState
    extends ConsumerState<ModelGeneralLoadingProgress> {
  static final String _className = '_ModelGeneralLoadingProgressState';
  static final String logClassName = '.::$_className::.';
  bool? isProcessRunning;

// Dentro de tu State:
  late final ProviderSubscription<ServiceProvider> _subscription;

  @override
  void initState() {
    super.initState();

// Escuchar cambios de estado y actuar cuando esté listo
    // ref.listen(notifierServiceProvider, (previous, next) {
    //   if (next.isReady && !next.isProgress && next.isUserLoggedIn && mounted) {
    //     Navigator.of(context).pop(true);
    //   }
    // });

    _subscription = ref.listenManual<ServiceProvider>(
      notifierServiceProvider,
      (prev, next) {
        final String functionName = 'LISTEN';
        final String logLocalFunc = '.::$functionName::.';
        var today = CommonDateTimeModel.fromNow();
        var dataPrev =
            'Prev:[IsReady:${prev?.isReady}, IsProgress:${prev?.isProgress}, IsUserLoggedIn:${prev?.isUserLoggedIn}]';
        var dataNext =
            'Next:[IsReady:${next.isReady}, IsProgress:${next.isProgress}, IsUserLoggedIn:${next.isUserLoggedIn}]';
        if (debug) {
          developer.log(
            'ServiceProviderNotifier: [1] - ${today.toES()} Cambios detectados - $dataPrev -> $dataNext',
            name: '$logClassName - $logLocalFunc',
          );
        }
        if (next.isReady &&
            !next.isProgress &&
            next.isUserLoggedIn &&
            mounted) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(true);
          } else {
            if (debug) {
              developer.log(
                'ServiceProviderNotifier: [4] - Navigator cannot pop, staying on the current page.',
                name: '$logClassName - $logLocalFunc',
              );
            }
            // Si no se puede hacer pop, quizás quieras navegar a otra página
            // Navigator.of(context).pushReplacementNamed('/home');
          }
          //Navigator.of(context).pop(true);
        } else {
          /// Evalúo la mejor forma para REINICIAR la conexión al websocket
          ///
          /// Versión 1:
          if (debug) {
            developer.log(
              'ServiceProviderNotifier: [2] - ${today.toES()} Reiniciando conexión al WebSocket de ${prev?.wssURI} a ${next.wssURI}',
              name: '$logClassName - $logLocalFunc',
            );
          }
          if (next.wssURI != prev?.wssURI ||
              next.isProgress != prev?.isProgress ||
              next.initStage != prev?.initStage) {
            // Reiniciar la conexión al WebSocket
            if (debug) {
              developer.log(
                '=> ServiceProviderNotifier: [3] - ${today.toES()} Reiniciando conexión al WebSocket de ${prev?.wssURI} a ${next.wssURI}',
                name: '$logClassName - $logLocalFunc',
              );
            }
            next.reboot();
          }

//           if (!next.isReady) {
//             // Arrancar la carga
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               final appStatus = ref.read(notifierServiceProvider);
//               isProcessRunning = true;
//               if (!appStatus.isReady) {
// //                appStatus.init();
//               }
//             });
//           }
        }
      },
    );
    // Arrancar la carga
    if (Utils.isPlatform == "Web") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appStatus = ref.read(notifierServiceProvider);
        isProcessRunning = true;
        if (!appStatus.isReady) {
          appStatus.init();
        }
      });
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final appStatus = ref.read(notifierServiceProvider);
    //   isProcessRunning = true;
    //   if (!appStatus.isReady) {
    //     appStatus.init();
    //   }
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   isProcessRunning = true;
    //   _initWork();
    // });
  }

  // Future<Object?> _initWork() async {
  //   final String functionName = '_initWork';
  //   final String logLocalFunc = '.::$functionName::.';

  //   developer.log(
  //       'ServiceStatus: PROGRESS NotifyListener:New Progress ${ref.read(notifierServiceProvider).isReady} ${ref.read(notifierServiceProvider).isProgress}',
  //       name: '$logClassName - $logLocalFunc');
  //   final appStatus = ref.read(notifierServiceProvider);
  //   if (!appStatus.isReady) {
  //     appStatus.init();
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String functioName = 'BUILD';
    final String logLocalFunc = '.::$functioName::.';
    if (debug) {
      developer.log(
        'ServiceStatus: PROGRESS NotifyListener:New Progress build',
        name: '$logClassName - $logLocalFunc',
      );
    }

    /// I rebuilt the widget everytime its status changes
    ///
    final appStatus = ref.watch(notifierServiceProvider);
    // if (appStatus.isReady && !appStatus.isProgress) {
    //   Future.delayed(const Duration(seconds: 0), () {
    //     if (!mounted) return;

    //     developer.log(
    //       'ServiceStatus: PROGRESS progressLoading: isReady: ${appStatus.isReady}',
    //       name: '$logClassName - $logLocalFunc',
    //     );
    //     if (appStatus.isUserLoggedIn) {
    //       Navigator.of(context).pop(appStatus.isReady);
    //     }
    //   });
    // }

    ///
    ///
    if (debug) {
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: PROGRESS progressLoading: errorRequestingBackend ${appStatus.initStage}-${appStatus.initStageError}',
      );
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: PROGRESS progressLoading: checkBool: ${appStatus.initStageAdditionalMsg != null && appStatus.initStage != ServiceProviderInitStages.errorConnecting && appStatus.initStage != ServiceProviderInitStages.errorReConnecting}',
      );
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: PROGRESS progressLoading: checkBool2: ${appStatus.initStageAdditionalMsg}-${appStatus.initStage}',
      );
    }
    return Visibility(
      visible: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 4,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.00, 5.00, 0.00, 5.00),
              child: Text(appStatus.initStage.typeDsc),
            ),
            if (appStatus.initStageAdditionalMsg != null &&
                appStatus.initStage !=
                    ServiceProviderInitStages.errorConnecting &&
                appStatus.initStage !=
                    ServiceProviderInitStages.errorReConnecting)
              Padding(
                padding: const EdgeInsets.fromLTRB(0.00, 2.00, 0.00, 0.00),
                child: Column(
                  children: [
                    Text(appStatus.initStageAdditionalMsg!),
                    if (appStatus.initStageError != null) ...[
                      Text('Code: ${appStatus.initStageError!.errorCode}'),
                      if (appStatus.initStageError!.propertyName != null)
                        Text(
                            'Property: ${appStatus.initStageError!.propertyName}'),
                      Text('Message: ${appStatus.initStageError!.errorDsc}'),
                    ]
                  ],
                ),
              ),
            if (appStatus.connRetry > 0 &&
                appStatus.connRetry <= 5 &&
                (appStatus.initStage == ServiceProviderInitStages.connecting ||
                    appStatus.initStage ==
                        ServiceProviderInitStages.reConnecting))
              Padding(
                padding: const EdgeInsets.fromLTRB(0.00, 2.00, 0.00, 5.00),
                child: Text('Retry #${appStatus.connRetry}'),
              ),
            if (appStatus.initStage ==
                    ServiceProviderInitStages.errorConnecting ||
                appStatus.initStage ==
                    ServiceProviderInitStages.errorReConnecting ||
                appStatus.canRetry)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white38,
                      //side: BorderSide(
                      //                            color: bottonColor.buttonBorderColor,
                      //),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                    ),
                    onPressed: () {
                      setState(() {
                        appStatus.connRetry = 0;
                        appStatus.initStageAdditionalMsg = null;
                        appStatus.initStage =
                            ServiceProviderInitStages.connecting;
                        appStatus.init();
                      });
                    },
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Retry',
                            style: TextStyle(
                              //color: bottonColor.buttonTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              fontFamily: 'Scavium',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white38,
                      //side: BorderSide(
                      //                            color: bottonColor.buttonBorderColor,
                      //),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                    ),
                    onPressed: () async {
                      // await Navigator.of(context).push(
                      //   PopUpServiceProviderConfigUpdateScreen(),
                      // );
                    },
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Configuration',
                            style: TextStyle(
                              //color: bottonColor.buttonTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              fontFamily: 'Scavium',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            //if (defaultTargetPlatform == TargetPlatform.windows)
            if (appStatus.initStage !=
                    ServiceProviderInitStages.errorConnecting &&
                appStatus.initStage !=
                    ServiceProviderInitStages.errorReConnecting &&
                !appStatus.canRetry)
              const Padding(
                padding: EdgeInsets.fromLTRB(0.00, 5.00, 0.00, 5.00),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
