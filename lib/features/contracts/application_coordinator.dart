import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/features/billing/controllers/billing_controller.dart';

class ApplicationCoordinator {
  static bool shouldBootstrapBilling({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex == null && currentClientIndex != null;
  }

  static bool shouldReloadBillingForActiveClientChange({
    required BillingFeatureState state,
    required int? currentClientIndex,
  }) {
    return state.trackedClientIndex != null &&
        state.trackedClientIndex != currentClientIndex;
  }

  static Future<void> performLogoutReset({
    required WidgetRef ref,
  }) async {
    await SessionStorage.removeSavedDni();
    ref.read(notifierServiceProvider).logout();
  }
}
