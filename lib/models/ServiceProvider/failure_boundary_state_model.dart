import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_scope_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_recovery_expectation_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';

class ServiceProviderFailureBoundaryState {
  final ServiceProviderFailureBoundaryScope scope;
  final ServiceProviderFailureRecoveryExpectation recoveryExpectation;
  final ServiceProviderInitStages initStage;
  final String reasonCode;
  final String description;
  final bool blocksStartupBoundary;
  final bool invalidatesAuthenticatedRuntimeContext;
  final bool invalidatesActiveOperationalContext;
  final bool canFeatureContinue;
  final String? className;
  final String? functionName;

  const ServiceProviderFailureBoundaryState._({
    required this.scope,
    required this.recoveryExpectation,
    required this.initStage,
    required this.reasonCode,
    required this.description,
    required this.blocksStartupBoundary,
    required this.invalidatesAuthenticatedRuntimeContext,
    required this.invalidatesActiveOperationalContext,
    required this.canFeatureContinue,
    this.className,
    this.functionName,
  });

  factory ServiceProviderFailureBoundaryState.none({
    required ServiceProviderInitStages initStage,
    String reasonCode = 'none',
    String description = 'No explicit failure boundary is currently active.',
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.none,
      recoveryExpectation: ServiceProviderFailureRecoveryExpectation.none,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: false,
      invalidatesAuthenticatedRuntimeContext: false,
      invalidatesActiveOperationalContext: false,
      canFeatureContinue: true,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.waiting({
    required ServiceProviderInitStages initStage,
    String reasonCode = 'waiting',
    String description = 'Runtime initialization is still in progress.',
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.startupBoundary,
      recoveryExpectation:
          ServiceProviderFailureRecoveryExpectation.stayWaiting,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: true,
      invalidatesAuthenticatedRuntimeContext: false,
      invalidatesActiveOperationalContext: false,
      canFeatureContinue: false,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.authContinuation({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    bool invalidatesAuthenticatedRuntimeContext = true,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.authContinuation,
      recoveryExpectation:
          ServiceProviderFailureRecoveryExpectation.interactiveLoginRequired,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: true,
      invalidatesAuthenticatedRuntimeContext:
          invalidatesAuthenticatedRuntimeContext,
      invalidatesActiveOperationalContext: true,
      canFeatureContinue: false,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.startupBlocked({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    required ServiceProviderFailureRecoveryExpectation recoveryExpectation,
    bool invalidatesAuthenticatedRuntimeContext = false,
    bool invalidatesActiveOperationalContext = false,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.startupBoundary,
      recoveryExpectation: recoveryExpectation,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: true,
      invalidatesAuthenticatedRuntimeContext:
          invalidatesAuthenticatedRuntimeContext,
      invalidatesActiveOperationalContext: invalidatesActiveOperationalContext,
      canFeatureContinue: false,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.transport({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    required ServiceProviderFailureRecoveryExpectation recoveryExpectation,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.transport,
      recoveryExpectation: recoveryExpectation,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: !initStage.name.contains('loggedIn'),
      invalidatesAuthenticatedRuntimeContext: false,
      invalidatesActiveOperationalContext: false,
      canFeatureContinue: false,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.activeOperationalContext({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    ServiceProviderFailureRecoveryExpectation recoveryExpectation =
        ServiceProviderFailureRecoveryExpectation.featureReloadAllowed,
    bool canFeatureContinue = false,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.activeOperationalContext,
      recoveryExpectation: recoveryExpectation,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: false,
      invalidatesAuthenticatedRuntimeContext: false,
      invalidatesActiveOperationalContext: true,
      canFeatureContinue: canFeatureContinue,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.featureLocal({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    ServiceProviderFailureRecoveryExpectation recoveryExpectation =
        ServiceProviderFailureRecoveryExpectation.featureReloadAllowed,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.featureLocal,
      recoveryExpectation: recoveryExpectation,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: false,
      invalidatesAuthenticatedRuntimeContext: false,
      invalidatesActiveOperationalContext: false,
      canFeatureContinue: false,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderFailureBoundaryState.runtimeGlobal({
    required ServiceProviderInitStages initStage,
    required String reasonCode,
    required String description,
    required ServiceProviderFailureRecoveryExpectation recoveryExpectation,
    bool blocksStartupBoundary = false,
    bool invalidatesAuthenticatedRuntimeContext = false,
    bool invalidatesActiveOperationalContext = false,
    bool canFeatureContinue = false,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderFailureBoundaryState._(
      scope: ServiceProviderFailureBoundaryScope.runtimeGlobal,
      recoveryExpectation: recoveryExpectation,
      initStage: initStage,
      reasonCode: reasonCode,
      description: description,
      blocksStartupBoundary: blocksStartupBoundary,
      invalidatesAuthenticatedRuntimeContext:
          invalidatesAuthenticatedRuntimeContext,
      invalidatesActiveOperationalContext: invalidatesActiveOperationalContext,
      canFeatureContinue: canFeatureContinue,
      className: className,
      functionName: functionName,
    );
  }

  bool get hasFailureBoundary =>
      scope != ServiceProviderFailureBoundaryScope.none ||
      recoveryExpectation != ServiceProviderFailureRecoveryExpectation.none;

  @override
  String toString() {
    return {
      'scope': scope.name,
      'recoveryExpectation': recoveryExpectation.name,
      'initStage': initStage.name,
      'reasonCode': reasonCode,
      'description': description,
      'blocksStartupBoundary': blocksStartupBoundary,
      'invalidatesAuthenticatedRuntimeContext':
          invalidatesAuthenticatedRuntimeContext,
      'invalidatesActiveOperationalContext':
          invalidatesActiveOperationalContext,
      'canFeatureContinue': canFeatureContinue,
      'className': className,
      'functionName': functionName,
    }.toString();
  }
}
