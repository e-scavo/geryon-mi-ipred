import 'package:geryon_web_app_ws_v2/models/ServiceProvider/failure_boundary_state_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/init_stages_enum_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_diagnostic_event_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_recovery_policy_decision_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/runtime_recovery_trigger_model.dart';

class ServiceProviderRuntimeDiagnosticSnapshot {
  final ServiceProviderFailureBoundaryState currentFailureBoundaryState;
  final ServiceProviderFailureBoundaryState? lastFailureBoundaryState;
  final ServiceProviderRuntimeRecoveryPolicyDecision?
      lastRecoveryPolicyDecision;
  final ServiceProviderRuntimeRecoveryTrigger? lastRecoveryTrigger;
  final ServiceProviderRuntimeDiagnosticEvent? lastDiagnosticEvent;
  final bool isRecoveryInProgress;
  final ServiceProviderRuntimeRecoveryTrigger? activeRecoveryTrigger;
  final ServiceProviderInitStages initStage;
  final int diagnosticEventCount;

  const ServiceProviderRuntimeDiagnosticSnapshot({
    required this.currentFailureBoundaryState,
    required this.lastFailureBoundaryState,
    required this.lastRecoveryPolicyDecision,
    required this.lastRecoveryTrigger,
    required this.lastDiagnosticEvent,
    required this.isRecoveryInProgress,
    required this.activeRecoveryTrigger,
    required this.initStage,
    required this.diagnosticEventCount,
  });

  @override
  String toString() {
    return {
      'currentFailureBoundaryState': currentFailureBoundaryState.toString(),
      'lastFailureBoundaryState': lastFailureBoundaryState?.toString(),
      'lastRecoveryPolicyDecision': lastRecoveryPolicyDecision?.toString(),
      'lastRecoveryTrigger': lastRecoveryTrigger?.name,
      'lastDiagnosticEvent': lastDiagnosticEvent?.toString(),
      'isRecoveryInProgress': isRecoveryInProgress,
      'activeRecoveryTrigger': activeRecoveryTrigger?.name,
      'initStage': initStage.name,
      'diagnosticEventCount': diagnosticEventCount,
    }.toString();
  }
}
