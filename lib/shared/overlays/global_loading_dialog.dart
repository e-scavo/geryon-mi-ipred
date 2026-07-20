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
  static const String _className = '_ModelGeneralLoadingProgressState';
  static const String logClassName = '.::$_className::.';
  static const double _maxContentWidth = 420;
  static const double _logoWidth = 190;

  bool _initializationRequested = false;
  bool _closeScheduled = false;

  late final ProviderSubscription<ServiceProvider> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ref.listenManual<ServiceProvider>(
      notifierServiceProvider,
      (prev, next) {
        const String functionName = 'LISTEN';
        const String logLocalFunc = '.::$functionName::.';
        final today = CommonDateTimeModel.fromNow();
        final dataPrev =
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

  bool _isConnectionStage(ServiceProvider appStatus) {
    return appStatus.initStage == ServiceProviderInitStages.connecting ||
        appStatus.initStage == ServiceProviderInitStages.reConnecting ||
        appStatus.initStage == ServiceProviderInitStages.errorConnecting ||
        appStatus.initStage == ServiceProviderInitStages.errorReConnecting;
  }

  bool _isErrorStage(ServiceProvider appStatus) {
    return appStatus.initStage == ServiceProviderInitStages.errorConnecting ||
        appStatus.initStage == ServiceProviderInitStages.errorReConnecting;
  }

  String _resolveTitle(ServiceProvider appStatus) {
    if (_isErrorStage(appStatus) || appStatus.canRetry) {
      return 'No pudimos conectar con el servicio';
    }
    if (appStatus.initStage == ServiceProviderInitStages.reConnecting) {
      return 'Restableciendo conexión';
    }
    return 'Conectando con el servicio';
  }

  String _resolveMessage(ServiceProvider appStatus) {
    final additionalMessage = appStatus.initStageAdditionalMsg?.trim();
    if (additionalMessage != null &&
        additionalMessage.isNotEmpty &&
        !_isErrorStage(appStatus)) {
      return additionalMessage;
    }

    if (_isErrorStage(appStatus) || appStatus.canRetry) {
      return 'Verificá tu conexión. La aplicación seguirá intentando y también podés reintentar ahora.';
    }

    if (appStatus.connRetry > 0 && _isConnectionStage(appStatus)) {
      return 'Intento de conexión ${appStatus.connRetry}.';
    }

    return 'Aguardá unos instantes mientras preparamos tu panel.';
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStatus = ref.watch(notifierServiceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isError = _isErrorStage(appStatus) || appStatus.canRetry;

    const String functionName = 'build';
    const String logLocalFunc = '.::$functionName::.';

    if (debug) {
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: ${appStatus.isReady} / progressLoading: ${appStatus.isProgress}',
      );
      developer.log(
        '$logClassName - $logLocalFunc - ServiceStatus: PROGRESS progressLoading: ${appStatus.initStage}-${appStatus.initStageError}',
      );
    }

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Card(
              elevation: 6,
              color: colorScheme.surface,
              surfaceTintColor: colorScheme.surfaceTint,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/full_logo.png',
                      fit: BoxFit.contain,
                      width: _logoWidth,
                      semanticLabel: 'IP·RED',
                    ),
                    const SizedBox(height: 22),
                    Text(
                      _resolveTitle(appStatus),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            isError ? colorScheme.error : colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _resolveMessage(appStatus),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (appStatus.isProgress || _isConnectionStage(appStatus))
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color:
                              isError ? colorScheme.error : colorScheme.primary,
                          strokeWidth: 2.6,
                        ),
                      ),
                    if (appStatus.connRetry > 0 &&
                        _isConnectionStage(appStatus)) ...[
                      const SizedBox(height: 12),
                      Text(
                        appStatus.maxConnRetry > 0
                            ? 'Intento ${appStatus.connRetry} de ${appStatus.maxConnRetry}'
                            : 'Intento ${appStatus.connRetry}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (isError) ...[
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: appStatus.isProgress
                              ? null
                              : appStatus.requestManualRecovery,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
