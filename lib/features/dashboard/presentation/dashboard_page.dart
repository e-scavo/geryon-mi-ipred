import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/billing_widget.dart';
import 'package:geryon_web_app_ws_v2/features/dashboard/controllers/dashboard_controller.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/shared/layouts/frame_with_scroll.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/copyable_list_tile.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/info_card.dart';

class DashboardPage extends ConsumerWidget {
  final int clientID;
  final DashboardController _controller = DashboardController();

  DashboardPage({super.key, required this.clientID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceProvider = ref.watch(notifierServiceProvider);
    final dashboardSourceState = _controller.buildSourceState(
      serviceProvider: serviceProvider,
    );
    final dashboardState = _controller.resolveStateFromSource(
      source: dashboardSourceState,
    );
    final userData = dashboardState.activeClient;

    final dashboardTitle = Utils.isPlatform == 'Web'
        ? _buildDashboardWebTitle()
        : _buildDashboardMobileTitle(
            context: context,
            ref: ref,
            dashboardState: dashboardState,
          );

    final dashboardActions = Utils.isPlatform == 'Web'
        ? _buildDashboardWebActions(
            context: context,
            ref: ref,
            dashboardState: dashboardState,
          )
        : _buildDashboardMobileActions(
            context: context,
            ref: ref,
          );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.25,
        title: dashboardTitle,
        actions: dashboardActions,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : _DashboardContent(data: userData),
    );
  }

  Widget _buildDashboardWebTitle() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Image.asset(
                'assets/logo-white.png',
                fit: BoxFit.contain,
                height: kToolbarHeight * 0.8,
              ),
            ),
            SizedBox(width: 8),
            const Text("Panel de Usuario"),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardMobileTitle({
    required BuildContext context,
    required WidgetRef ref,
    required DashboardResolvedState dashboardState,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Image.asset(
                'assets/logo-white.png',
                fit: BoxFit.contain,
                height: kToolbarHeight * 0.8,
              ),
            ),
            SizedBox(width: 8),
            const Text("Panel de Usuario"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopupMenuButton<int>(
              tooltip: "Seleccionar Cliente",
              onSelected: (int result) async {
                await _controller.selectClient(
                  ref: ref,
                  clientIndex: result,
                );
              },
              itemBuilder: (BuildContext context) {
                return dashboardState.clientOptions
                    .map(
                      (option) => PopupMenuItem<int>(
                        value: option.index,
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              child: Row(
                children: [
                  Text(
                    dashboardState.activeClientDisplayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildDashboardWebActions({
    required BuildContext context,
    required WidgetRef ref,
    required DashboardResolvedState dashboardState,
  }) {
    return [
      PopupMenuButton<int>(
        tooltip: "Seleccionar Cliente",
        onSelected: (int result) async {
          await _controller.selectClient(
            ref: ref,
            clientIndex: result,
          );
        },
        itemBuilder: (BuildContext context) {
          return dashboardState.clientOptions
              .map(
                (option) => PopupMenuItem<int>(
                  value: option.index,
                  child: Text(option.label),
                ),
              )
              .toList();
        },
        child: Row(
          children: [
            Text(dashboardState.activeClientDisplayName),
            const Icon(Icons.person),
          ],
        ),
      ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await _controller.logout(ref: ref);
        },
      ),
    ];
  }

  List<Widget> _buildDashboardMobileActions({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await _controller.logout(ref: ref);
        },
      ),
    ];
  }
}

class _DashboardContent extends StatelessWidget {
  final ServiceProviderLoginDataUserMessageModel data;

  const _DashboardContent({required this.data});

  void _showPaymentDialog(
    BuildContext context,
    ServiceProviderLoginDataUserMessageModel userData,
  ) {
    var today = DateTime.now();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Métodos de pago"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CopyableListTile(
                icon: Icons.account_circle,
                label: "Alias",
                value: userData.roelaAliasCuentaBancaria.isEmpty
                    ? 'No disponible'
                    : userData.roelaAliasCuentaBancaria,
              ),
              CopyableListTile(
                icon: Icons.account_circle,
                label: "Pago Fácil / Pago Mis Cuentas",
                value: userData.codigoPMCnPF.isEmpty
                    ? 'No disponible'
                    : userData.codigoPMCnPF,
              ),
              CopyableListTile(
                icon: Icons.account_circle,
                label: "Código de barras",
                value: userData.codigoBarrasPMCnPF.isEmpty
                    ? 'No disponible'
                    : userData.codigoBarrasPMCnPF,
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(
                  "Saldo a pagar: ${userData.saldoActual.asStringWithPrecSpanish(2)}",
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text("Último pago: ${userData.ultFechaPago.toES()}"),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  "Vencimiento: 10/${today.month.toString().padLeft(2, "0")}/${today.year}",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String functionName = '_DashboardContent.build';
    String logFunctionName = '.::$functionName::.';

    return LayoutBuilder(
      builder: (context, constraints) {
        if (debug) {
          developer.log(
            'logFunctionName: $logFunctionName, constraints: $constraints '
            'maxWidth: ${constraints.maxWidth}, maxHeight: ${constraints.maxHeight}',
          );
        }

        String myDNI = "-";
        switch (data.codCatIVA) {
          case 'I':
          case 'E':
          case 'M':
            myDNI = data.cuit.isEmpty ? '-' : data.cuit;
            break;
          default:
            myDNI = data.dni.isEmpty ? '-' : data.dni;
            break;
        }

        var rbody = Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bienvenido, ${data.razonSocial}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  InfoCard(title: "Documento", value: myDNI),
                  InfoCard(
                    title: "Saldo",
                    value: data.saldoActual.asStringWithPrecSpanish(2),
                    actionLabel: "Mostrar cómo pagar",
                    onAction: () => _showPaymentDialog(context, data),
                  ),
                  InfoCard(
                    title: "Último pago",
                    value: data.ultFechaPago.toES(),
                  ),
                  InfoCard(title: "Estado", value: data.estado),
                  const SizedBox(height: 5),
                ],
              ),
              SizedBox(
                width: constraints.maxWidth != double.infinity
                    ? constraints.maxWidth - 32
                    : constraints.maxWidth,
                height: 400,
                child: BillingWidget(
                  constraints: constraints,
                  pType: "FacturasVT",
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: constraints.maxWidth != double.infinity
                    ? constraints.maxWidth - 32
                    : constraints.maxWidth,
                height: 400,
                child: BillingWidget(
                  constraints: constraints,
                  pType: "RecibosVT",
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        );

        return FrameWithScroll(
          pBody: rbody,
        );
      },
    );
  }
}
