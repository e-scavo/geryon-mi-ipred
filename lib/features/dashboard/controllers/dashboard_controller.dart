import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';

class DashboardClientOption {
  final int index;
  final String label;

  const DashboardClientOption({
    required this.index,
    required this.label,
  });
}

class DashboardResolvedState {
  final dynamic loggedUser;
  final ServiceProviderLoginDataUserMessageModel? activeClient;
  final String activeClientDisplayName;
  final List<DashboardClientOption> clientOptions;

  const DashboardResolvedState({
    required this.loggedUser,
    required this.activeClient,
    required this.activeClientDisplayName,
    required this.clientOptions,
  });
}

class DashboardController {
  DashboardResolvedState resolveState({
    required WidgetRef ref,
  }) {
    final loggedUser = ref.watch(notifierServiceProvider).loggedUser;
    final activeClient = _resolveActiveClient(loggedUser);
    final clientOptions = _buildClientOptions(loggedUser);

    return DashboardResolvedState(
      loggedUser: loggedUser,
      activeClient: activeClient,
      activeClientDisplayName: _resolveDisplayName(activeClient),
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

  ServiceProviderLoginDataUserMessageModel? _resolveActiveClient(
    dynamic loggedUser,
  ) {
    if (loggedUser == null) {
      return null;
    }

    if (loggedUser.clientes == null || loggedUser.clientes.isEmpty) {
      return null;
    }

    final int currentIndex = (loggedUser.cCliente <= 0 ||
            loggedUser.cCliente >= loggedUser.clientes.length)
        ? 0
        : loggedUser.cCliente;

    return loggedUser.clientes[currentIndex];
  }

  List<DashboardClientOption> _buildClientOptions(dynamic loggedUser) {
    if (loggedUser == null) {
      return const <DashboardClientOption>[];
    }

    if (loggedUser.clientes == null || loggedUser.clientes.isEmpty) {
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
    }).toList();
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
