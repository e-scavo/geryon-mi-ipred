import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';

enum ServiceProviderStartupAuthContinuationDisposition {
  waitingForInitialization,
  waitingForInteractiveLogin,
  authenticatedContinuationResolved,
  retryRequired,
  blockedByError,
}

class ServiceProviderStartupAuthContinuationCoordinatorState {
  final ServiceProviderStartupAuthContinuationDisposition disposition;
  final ServiceProviderInitStages initStage;
  final String description;
  final bool shouldCloseLoadingPopup;
  final bool shouldCompleteStartupBoundary;
  final bool shouldTriggerReboot;
  final bool shouldStayWaiting;

  const ServiceProviderStartupAuthContinuationCoordinatorState._({
    required this.disposition,
    required this.initStage,
    required this.description,
    required this.shouldCloseLoadingPopup,
    required this.shouldCompleteStartupBoundary,
    required this.shouldTriggerReboot,
    required this.shouldStayWaiting,
  });

  factory ServiceProviderStartupAuthContinuationCoordinatorState.waitingForInitialization({
    required ServiceProviderInitStages initStage,
    String description = 'Startup/auth continuation is still initializing.',
  }) {
    return ServiceProviderStartupAuthContinuationCoordinatorState._(
      disposition: ServiceProviderStartupAuthContinuationDisposition
          .waitingForInitialization,
      initStage: initStage,
      description: description,
      shouldCloseLoadingPopup: false,
      shouldCompleteStartupBoundary: false,
      shouldTriggerReboot: false,
      shouldStayWaiting: true,
    );
  }

  factory ServiceProviderStartupAuthContinuationCoordinatorState.waitingForInteractiveLogin({
    required ServiceProviderInitStages initStage,
    String description =
        'Startup/auth continuation is waiting for interactive login resolution.',
  }) {
    return ServiceProviderStartupAuthContinuationCoordinatorState._(
      disposition: ServiceProviderStartupAuthContinuationDisposition
          .waitingForInteractiveLogin,
      initStage: initStage,
      description: description,
      shouldCloseLoadingPopup: false,
      shouldCompleteStartupBoundary: false,
      shouldTriggerReboot: false,
      shouldStayWaiting: true,
    );
  }

  factory ServiceProviderStartupAuthContinuationCoordinatorState.authenticatedContinuationResolved({
    required ServiceProviderInitStages initStage,
    String description =
        'Startup/auth continuation resolved with authenticated runtime context.',
  }) {
    return ServiceProviderStartupAuthContinuationCoordinatorState._(
      disposition: ServiceProviderStartupAuthContinuationDisposition
          .authenticatedContinuationResolved,
      initStage: initStage,
      description: description,
      shouldCloseLoadingPopup: true,
      shouldCompleteStartupBoundary: true,
      shouldTriggerReboot: false,
      shouldStayWaiting: false,
    );
  }

  factory ServiceProviderStartupAuthContinuationCoordinatorState.retryRequired({
    required ServiceProviderInitStages initStage,
    String description =
        'Startup/auth continuation requires a controlled reboot attempt.',
  }) {
    return ServiceProviderStartupAuthContinuationCoordinatorState._(
      disposition:
          ServiceProviderStartupAuthContinuationDisposition.retryRequired,
      initStage: initStage,
      description: description,
      shouldCloseLoadingPopup: false,
      shouldCompleteStartupBoundary: false,
      shouldTriggerReboot: true,
      shouldStayWaiting: true,
    );
  }

  factory ServiceProviderStartupAuthContinuationCoordinatorState.blockedByError({
    required ServiceProviderInitStages initStage,
    String description =
        'Startup/auth continuation is blocked by an explicit runtime error state.',
  }) {
    return ServiceProviderStartupAuthContinuationCoordinatorState._(
      disposition:
          ServiceProviderStartupAuthContinuationDisposition.blockedByError,
      initStage: initStage,
      description: description,
      shouldCloseLoadingPopup: false,
      shouldCompleteStartupBoundary: false,
      shouldTriggerReboot: false,
      shouldStayWaiting: true,
    );
  }

  @override
  String toString() {
    return {
      'disposition': disposition.name,
      'initStage': initStage.name,
      'description': description,
      'shouldCloseLoadingPopup': shouldCloseLoadingPopup,
      'shouldCompleteStartupBoundary': shouldCompleteStartupBoundary,
      'shouldTriggerReboot': shouldTriggerReboot,
      'shouldStayWaiting': shouldStayWaiting,
    }.toString();
  }
}
