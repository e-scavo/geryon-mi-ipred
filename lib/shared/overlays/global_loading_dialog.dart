import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart';

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
  bool _initializationRequested = false;
  bool _closeScheduled = false;

  late final ProviderSubscription<ServiceProvider> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ref.listenManual<ServiceProvider>(
      notifierServiceProvider,
      (prev, next) {
        final String functionName = 'LISTEN';
        final String logLocalFunc = '.::$functionName::.';
        var today = CommonDateTimeModel.fromNow();
        var dataPrev =
            prev != null ? prev.runtimeType.toString() : next.runtimeType;
        if (debug) {
          developer.log(
            '=> ServiceProviderNotifier: [1] - ${today.toES()} SERVICE_PROVIDER Next=> ${next.runtimeType} / isReady:${next.isReady} isProgress:${next.isProgress} isUserLoggedIn:${next.isUserLoggedIn} prev=>$dataPrev',
            name: '$logClassName - $logLocalFunc',
          );
        }
        final ServiceProviderStartupAuthContinuationCoordinatorState
            coordinatorState =
            next.evaluateStartupAuthContinuationCoordinatorState(
          previousState: prev,
        );

        if (debug) {
          developer.log(
            'ServiceProviderNotifier: [2] - ${today.toES()} Coordinator state => ${coordinatorState.toString()}',
            name: '$logClassName - $logLocalFunc',
          );
        }

        if (coordinatorState.shouldCloseLoadingPopup && mounted) {
          _scheduleCloseLoadingPopup(
            coordinatorState.shouldCompleteStartupBoundary,
          );
        } else if (coordinatorState.shouldTriggerReboot) {
          if (debug) {
            developer.log(
              '=> ServiceProviderNotifier: [3] - ${today.toES()} Coordinator requested reboot for startup/auth continuation.',
              name: '$logClassName - $logLocalFunc',
            );
          }
          next.requestStartupRecovery();
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBootstrap();
    });
  }

  Future<void> _startBootstrap() async {
    const String functionName = '_startBootstrap';
    if (_initializationRequested) {
      return;
    }
    _initializationRequested = true;

    try {
      await ref.read(serviceProviderConfigProvider.future);
      if (!mounted) {
        return;
      }

      final appStatus = ref.read(notifierServiceProvider);
      if (!appStatus.isReady && !appStatus.isProgress) {
        await appStatus.init();
      }
    } catch (error, stacktrace) {
      developer.log(
        'Startup bootstrap failed before ServiceProvider initialization. '
        'error=$error stacktrace=$stacktrace',
        name: '$logClassName - .::$functionName::.',
        error: error,
        stackTrace: stacktrace,
      );
    }
  }

  void _scheduleCloseLoadingPopup(bool startupBoundaryCompleted) {
    if (_closeScheduled) {
      return;
    }
    _closeScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      if (ModalRoute.of(context)?.isCurrent == true && navigator.canPop()) {
        navigator.pop(startupBoundaryCompleted);
        return;
      }

      _closeScheduled = false;
      Future<void>.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _scheduleCloseLoadingPopup(startupBoundaryCompleted);
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStatus = ref.watch(notifierServiceProvider);

    const String functionName = 'build';
    const String logLocalFunc = '.::$functionName::.';

    if (debug) {
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: ${appStatus.isReady} / progressLoading: ${appStatus.isProgress}',
      );
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: PROGRESS progressLoading: ${appStatus.initStage}-${appStatus.initStageError}',
      );
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
              'assets/images/full_logo.png',
              fit: BoxFit.contain,
              width: 200,
            ),
            if (appStatus.initStageAdditionalMsg != null &&
                appStatus.initStage !=
                    ServiceProviderInitStages.errorConnecting &&
                appStatus.initStage !=
                    ServiceProviderInitStages.errorReConnecting)
              SizedBox(
                height: 10,
                width: 200,
                child: Text(
                  appStatus.initStageAdditionalMsg!,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 3),
            if (appStatus.initStage ==
                    ServiceProviderInitStages.errorConnecting ||
                appStatus.initStage ==
                    ServiceProviderInitStages.errorReConnecting)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black38),
                  backgroundColor: Colors.transparent,
                  strokeWidth: 1.5,
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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                    ),
                    onPressed: () {
                      appStatus.requestManualRecovery();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
