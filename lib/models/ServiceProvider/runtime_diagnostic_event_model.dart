import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_scope_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_state_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_recovery_expectation_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_diagnostic_event_type_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_recovery_policy_decision_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_recovery_trigger_model.dart';

class ServiceProviderRuntimeDiagnosticEvent {
  final DateTime timestamp;
  final ServiceProviderRuntimeDiagnosticEventType type;
  final String reasonCode;
  final String description;
  final ServiceProviderInitStages initStage;
  final ServiceProviderRuntimeRecoveryTrigger? trigger;
  final ServiceProviderFailureBoundaryScope? failureBoundaryScope;
  final ServiceProviderFailureRecoveryExpectation? recoveryExpectation;
  final ServiceProviderRuntimeRecoveryPolicyDecision? recoveryPolicyDecision;
  final String? className;
  final String? functionName;

  const ServiceProviderRuntimeDiagnosticEvent({
    required this.timestamp,
    required this.type,
    required this.reasonCode,
    required this.description,
    required this.initStage,
    this.trigger,
    this.failureBoundaryScope,
    this.recoveryExpectation,
    this.recoveryPolicyDecision,
    this.className,
    this.functionName,
  });

  factory ServiceProviderRuntimeDiagnosticEvent.now({
    required ServiceProviderRuntimeDiagnosticEventType type,
    required String reasonCode,
    required String description,
    required ServiceProviderInitStages initStage,
    ServiceProviderRuntimeRecoveryTrigger? trigger,
    ServiceProviderFailureBoundaryState? failureBoundaryState,
    ServiceProviderRuntimeRecoveryPolicyDecision? recoveryPolicyDecision,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderRuntimeDiagnosticEvent(
      timestamp: DateTime.now(),
      type: type,
      reasonCode: reasonCode,
      description: description,
      initStage: initStage,
      trigger: trigger,
      failureBoundaryScope: failureBoundaryState?.scope,
      recoveryExpectation: failureBoundaryState?.recoveryExpectation,
      recoveryPolicyDecision: recoveryPolicyDecision,
      className: className,
      functionName: functionName,
    );
  }

  @override
  String toString() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'reasonCode': reasonCode,
      'description': description,
      'initStage': initStage.name,
      'trigger': trigger?.name,
      'failureBoundaryScope': failureBoundaryScope?.name,
      'recoveryExpectation': recoveryExpectation?.name,
      'recoveryPolicyDecision': recoveryPolicyDecision?.toString(),
      'className': className,
      'functionName': functionName,
    }.toString();
  }
}
