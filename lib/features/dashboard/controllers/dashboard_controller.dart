import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/features/contracts/application_coordinator.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';

enum DashboardSurfaceStateType {
  loading,
  empty,
  invalidOperationalContext,
  ready,
}

class DashboardClientOption {
  final int index;
  final String label;

  const DashboardClientOption({
    required this.index,
    required this.label,
  });
}

class DashboardSourceState {
  final ServiceProviderLoginDataUserMessageModel? authenticatedUser;
  final List<ServiceProviderLoginDataUserMessageModel> availableClients;
  final int? selectedClientIndex;

  const DashboardSourceState({
    required this.authenticatedUser,
    required this.availableClients,
    required this.selectedClientIndex,
  });
}

class DashboardResolvedState {
  final DashboardSurfaceStateType surfaceStateType;
  final ServiceProviderLoginDataUserMessageModel? activeClient;
  final int? activeClientIndex;
  final String activeClientDisplayName;
  final List<DashboardClientOption> clientOptions;

  const DashboardResolvedState({
    required this.surfaceStateType,
    required this.activeClient,
    required this.activeClientIndex,
    required this.activeClientDisplayName,
    required this.clientOptions,
  });

  bool get hasActiveClient => activeClient != null;
  bool get hasClientOptions => clientOptions.isNotEmpty;
  bool get canSelectClient => clientOptions.length > 1;

  bool get isLoadingSurface =>
      surfaceStateType == DashboardSurfaceStateType.loading;

  bool get isEmptySurface =>
      surfaceStateType == DashboardSurfaceStateType.empty;

  bool get isOperationalContextInvalid =>
      surfaceStateType == DashboardSurfaceStateType.invalidOperationalContext;

  bool get isReadySurface =>
      surfaceStateType == DashboardSurfaceStateType.ready;

  String get loadingTitle => 'Preparando tu panel...';

  String get emptyTitle => 'No encontramos clientes disponibles';

  String get emptyMessage =>
      'Tu sesión está iniciada, pero no encontramos clientes disponibles para mostrar en este momento. Volvé a intentarlo en unos instantes.';

  String get invalidContextTitle => 'No pudimos resolver el cliente activo';

  String get invalidContextMessage =>
      'La sesión está iniciada, pero no pudimos determinar un cliente activo válido para mostrar el panel. Volvé a intentarlo.';
}

class DashboardController {
  DashboardSourceState buildSourceState({
    required ServiceProvider serviceProvider,
  }) {
    return DashboardSourceState(
      authenticatedUser: serviceProvider.authenticatedUser,
      availableClients: serviceProvider.availableClients,
      selectedClientIndex: serviceProvider.activeClientIndex,
    );
  }

  DashboardResolvedState resolveStateFromSource({
    required DashboardSourceState source,
  }) {
    final clientOptions = _buildClientOptions(source);

    if (source.authenticatedUser == null) {
      return DashboardResolvedState(
        surfaceStateType: DashboardSurfaceStateType.loading,
        activeClient: null,
        activeClientIndex: null,
        activeClientDisplayName: 'Cargando...',
        clientOptions: clientOptions,
      );
    }

    if (source.availableClients.isEmpty) {
      return const DashboardResolvedState(
        surfaceStateType: DashboardSurfaceStateType.empty,
        activeClient: null,
        activeClientIndex: null,
        activeClientDisplayName: 'SIN CLIENTES',
        clientOptions: <DashboardClientOption>[],
      );
    }

    final activeClientIndex = _resolveActiveClientIndex(source);
    final activeClient = _resolveActiveClient(
      source: source,
      activeClientIndex: activeClientIndex,
    );

    if (activeClient == null) {
      return DashboardResolvedState(
        surfaceStateType: DashboardSurfaceStateType.invalidOperationalContext,
        activeClient: null,
        activeClientIndex: activeClientIndex,
        activeClientDisplayName: 'CLIENTE NO RESUELTO',
        clientOptions: clientOptions,
      );
    }

    final activeClientDisplayName = _resolveDisplayName(activeClient);

    return DashboardResolvedState(
      surfaceStateType: DashboardSurfaceStateType.ready,
      activeClient: activeClient,
      activeClientIndex: activeClientIndex,
      activeClientDisplayName: activeClientDisplayName,
      clientOptions: clientOptions,
    );
  }

  Future<void> selectClient({
    required WidgetRef ref,
    required int clientIndex,
  }) async {
    ref.read(notifierServiceProvider).setCurrentCliente(clientIndex);
  }

  Future<void> logout({
    required WidgetRef ref,
  }) async {
    await ApplicationCoordinator.performLogoutReset(ref: ref);
  }

  String resolveSelectorLabel({
    required DashboardResolvedState state,
  }) {
    if (state.isLoadingSurface) {
      return 'Resolviendo cliente...';
    }

    if (state.isEmptySurface) {
      return 'Sin clientes';
    }

    if (state.isOperationalContextInvalid) {
      return 'Cliente no disponible';
    }

    final displayName = state.activeClientDisplayName.trim();
    if (displayName.isNotEmpty) {
      return displayName;
    }

    return 'Cliente activo';
  }

  int? _resolveActiveClientIndex(
    DashboardSourceState source,
  ) {
    if (source.availableClients.isEmpty) {
      return null;
    }

    final selectedClientIndex = source.selectedClientIndex ?? 0;

    if (selectedClientIndex < 0 ||
        selectedClientIndex >= source.availableClients.length) {
      return 0;
    }

    return selectedClientIndex;
  }

  ServiceProviderLoginDataUserMessageModel? _resolveActiveClient({
    required DashboardSourceState source,
    required int? activeClientIndex,
  }) {
    if (source.availableClients.isEmpty) {
      return null;
    }

    if (activeClientIndex == null) {
      return null;
    }

    return source.availableClients[activeClientIndex];
  }

  List<DashboardClientOption> _buildClientOptions(
    DashboardSourceState source,
  ) {
    if (source.availableClients.isEmpty) {
      return const <DashboardClientOption>[];
    }

    return source.availableClients
        .asMap()
        .entries
        .map<DashboardClientOption>((entry) {
      final client = entry.value;
      final label =
          client.razonSocial.isEmpty ? 'NO ESPECIFICADA' : client.razonSocial;

      return DashboardClientOption(
        index: entry.key,
        label: label,
      );
    }).toList(growable: false);
  }

  String _resolveDisplayName(
    ServiceProviderLoginDataUserMessageModel? activeClient,
  ) {
    if (activeClient == null) {
      return 'NO ESPECIFICADA';
    }

    return activeClient.razonSocial.isEmpty
        ? 'NO ESPECIFICADA'
        : activeClient.razonSocial;
  }
}
