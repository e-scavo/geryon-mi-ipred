import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';

class DashboardClientOption {
  final int index;
  final String label;

  const DashboardClientOption({
    required this.index,
    required this.label,
  });
}

class DashboardSourceState {
  final ServiceProviderLoginDataUserMessageModel? loggedUser;
  final int? selectedClientIndex;

  const DashboardSourceState({
    required this.loggedUser,
    required this.selectedClientIndex,
  });
}

class DashboardResolvedState {
  final ServiceProviderLoginDataUserMessageModel? activeClient;
  final int? activeClientIndex;
  final String activeClientDisplayName;
  final List<DashboardClientOption> clientOptions;

  const DashboardResolvedState({
    required this.activeClient,
    required this.activeClientIndex,
    required this.activeClientDisplayName,
    required this.clientOptions,
  });

  bool get hasActiveClient => activeClient != null;
}

class DashboardController {
  DashboardSourceState buildSourceState({
    required ServiceProvider serviceProvider,
  }) {
    final loggedUser = serviceProvider.loggedUser;

    return DashboardSourceState(
      loggedUser: loggedUser,
      selectedClientIndex: loggedUser?.cCliente,
    );
  }

  DashboardResolvedState resolveStateFromSource({
    required DashboardSourceState source,
  }) {
    final activeClientIndex = _resolveActiveClientIndex(source);
    final activeClient = _resolveActiveClient(
      source: source,
      activeClientIndex: activeClientIndex,
    );
    final clientOptions = _buildClientOptions(source);
    final activeClientDisplayName = _resolveDisplayName(activeClient);

    return DashboardResolvedState(
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
    await SessionStorage.clear();
    ref.read(notifierServiceProvider).logout();
  }

  int? _resolveActiveClientIndex(
    DashboardSourceState source,
  ) {
    final loggedUser = source.loggedUser;

    if (loggedUser == null) {
      return null;
    }

    if (loggedUser.clientes.isEmpty) {
      return null;
    }

    final selectedClientIndex = source.selectedClientIndex ?? 0;

    if (selectedClientIndex < 0 ||
        selectedClientIndex >= loggedUser.clientes.length) {
      return 0;
    }

    return selectedClientIndex;
  }

  ServiceProviderLoginDataUserMessageModel? _resolveActiveClient({
    required DashboardSourceState source,
    required int? activeClientIndex,
  }) {
    final loggedUser = source.loggedUser;

    if (loggedUser == null) {
      return null;
    }

    if (loggedUser.clientes.isEmpty) {
      return null;
    }

    if (activeClientIndex == null) {
      return null;
    }

    return loggedUser.clientes[activeClientIndex];
  }

  List<DashboardClientOption> _buildClientOptions(
    DashboardSourceState source,
  ) {
    final loggedUser = source.loggedUser;

    if (loggedUser == null) {
      return const <DashboardClientOption>[];
    }

    if (loggedUser.clientes.isEmpty) {
      return const <DashboardClientOption>[];
    }

    return loggedUser.clientes
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
