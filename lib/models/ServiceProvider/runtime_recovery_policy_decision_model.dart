import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_state_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_recovery_trigger_model.dart';

class ServiceProviderRuntimeRecoveryPolicyDecision {
  final ServiceProviderRuntimeRecoveryTrigger trigger;
  final ServiceProviderFailureBoundaryState failureBoundaryState;
  final bool shouldAttemptRecovery;
  final bool shouldOpenLoadingPopup;
  final bool shouldResetRetryCounter;
  final bool shouldResetSessionToken;
  final bool allowIfRecoveryAlreadyRunning;
  final String reasonCode;
  final String description;

  const ServiceProviderRuntimeRecoveryPolicyDecision({
    required this.trigger,
    required this.failureBoundaryState,
    required this.shouldAttemptRecovery,
    required this.shouldOpenLoadingPopup,
    required this.shouldResetRetryCounter,
    required this.shouldResetSessionToken,
    required this.allowIfRecoveryAlreadyRunning,
    required this.reasonCode,
    required this.description,
  });

  factory ServiceProviderRuntimeRecoveryPolicyDecision.blocked({
    required ServiceProviderRuntimeRecoveryTrigger trigger,
    required ServiceProviderFailureBoundaryState failureBoundaryState,
    required String reasonCode,
    required String description,
    bool allowIfRecoveryAlreadyRunning = false,
  }) {
    return ServiceProviderRuntimeRecoveryPolicyDecision(
      trigger: trigger,
      failureBoundaryState: failureBoundaryState,
      shouldAttemptRecovery: false,
      shouldOpenLoadingPopup: false,
      shouldResetRetryCounter: false,
      shouldResetSessionToken: false,
      allowIfRecoveryAlreadyRunning: allowIfRecoveryAlreadyRunning,
      reasonCode: reasonCode,
      description: description,
    );
  }

  factory ServiceProviderRuntimeRecoveryPolicyDecision.allow({
    required ServiceProviderRuntimeRecoveryTrigger trigger,
    required ServiceProviderFailureBoundaryState failureBoundaryState,
    required String reasonCode,
    required String description,
    bool shouldOpenLoadingPopup = true,
    bool shouldResetRetryCounter = false,
    bool shouldResetSessionToken = true,
    bool allowIfRecoveryAlreadyRunning = false,
  }) {
    return ServiceProviderRuntimeRecoveryPolicyDecision(
      trigger: trigger,
      failureBoundaryState: failureBoundaryState,
      shouldAttemptRecovery: true,
      shouldOpenLoadingPopup: shouldOpenLoadingPopup,
      shouldResetRetryCounter: shouldResetRetryCounter,
      shouldResetSessionToken: shouldResetSessionToken,
      allowIfRecoveryAlreadyRunning: allowIfRecoveryAlreadyRunning,
      reasonCode: reasonCode,
      description: description,
    );
  }

  @override
  String toString() {
    return {
      'trigger': trigger.name,
      'failureBoundaryState': failureBoundaryState.toString(),
      'shouldAttemptRecovery': shouldAttemptRecovery,
      'shouldOpenLoadingPopup': shouldOpenLoadingPopup,
      'shouldResetRetryCounter': shouldResetRetryCounter,
      'shouldResetSessionToken': shouldResetSessionToken,
      'allowIfRecoveryAlreadyRunning': allowIfRecoveryAlreadyRunning,
      'reasonCode': reasonCode,
      'description': description,
    }.toString();
  }
}
