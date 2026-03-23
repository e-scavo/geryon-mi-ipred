import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/pages/Billing/widget.dart';
import 'package:geryon_web_app_ws_v2/pages/FrameWithScroll/widget.dart';
// import 'package:geryon_web_app_ws_v2/models/_pruebas/them1.dart';
import 'package:geryon_web_app_ws_v2/pages/copyable_list_tile_page.dart';
import 'package:geryon_web_app_ws_v2/pages/infocard_page.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/utils/utils.dart';
//import 'package:geryon_web_app_ws_v2/providers/user_provider.dart';

class DashboardPage extends ConsumerWidget {
  final int clientID;

  const DashboardPage({super.key, required this.clientID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final userData = ref.watch(userDataProvider(dni));
    final wUserData = ref.watch(notifierServiceProvider).loggedUser;
    final ServiceProviderLoginDataUserMessageModel? userData;
    if (wUserData != null) {
      if (wUserData.cCliente <= 0) {
        userData = wUserData.clientes.first;
      } else {
        userData = wUserData.clientes[wUserData.cCliente];
      }
      //userData = wUserData;
    } else {
      userData = null;
    }

    //return StyledComponentsDemo();
    String cRazonSocial = "NO ESPECIFICADA";
    if (userData != null) {
      cRazonSocial = userData.razonSocial.isEmpty
          ? "NO ESPECIFICADA"
          : userData.razonSocial;
    }

    var dashboardWebTitle = Column(
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
    var dashboardMobileTitle = Column(
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
              onSelected: (int result) {
                // Maneja la opción seleccionada
                ref.read(notifierServiceProvider).setCurrentCliente(result);
              },
              itemBuilder: (BuildContext context) {
                var items = <PopupMenuEntry<int>>[];
                wUserData!.clientes.asMap().forEach((index, client) {
                  items.add(
                    PopupMenuItem<int>(
                      value: index,
                      child: Text(
                        client.razonSocial,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                });
                return items;
              },
              child: Row(
                children: [
                  Text(
                    cRazonSocial,
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
              ), // Aquí va el ícono
            ),
          ],
        ),
      ],
    );
    var dashboardWebActions = [
      PopupMenuButton<int>(
        tooltip: "Seleccionar Cliente",
        onSelected: (int result) {
          // Maneja la opción seleccionada
          ref.read(notifierServiceProvider).setCurrentCliente(result);
        },
        itemBuilder: (BuildContext context) {
          var items = <PopupMenuEntry<int>>[];
          wUserData!.clientes.asMap().forEach((index, client) {
            items.add(
              PopupMenuItem<int>(
                value: index,
                child: Text(client.razonSocial),
              ),
            );
          });
          return items;
        },
        child: Row(
          children: [
            Text(cRazonSocial),
            const Icon(Icons.person),
          ],
        ), // Aquí va el ícono
      ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await SessionStorage.clear();
          ref.read(notifierServiceProvider).logout();
        },
      ),
    ];
    var dashboardMobileActions = [
      // PopupMenuButton<int>(
      //   tooltip: "Seleccionar Cliente",
      //   onSelected: (int result) {
      //     // Maneja la opción seleccionada
      //     ref.read(notifierServiceProvider).setCurrentCliente(result);
      //   },
      //   itemBuilder: (BuildContext context) {
      //     var items = <PopupMenuEntry<int>>[];
      //     wUserData!.clientes.asMap().forEach((index, client) {
      //       items.add(
      //         PopupMenuItem<int>(
      //           value: index,
      //           child: Text(client.razonSocial),
      //         ),
      //       );
      //     });
      //     return items;
      //   },
      //   child: Row(
      //     children: [
      //       Text(cRazonSocial),
      //       const Icon(Icons.person),
      //     ],
      //   ), // Aquí va el ícono
      // ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await SessionStorage.clear();
          ref.read(notifierServiceProvider).logout();
        },
      ),
    ];

    var dashboardTitle =
        Utils.isPlatform == 'Web' ? dashboardWebTitle : dashboardMobileTitle;
    var dashboardActions = Utils.isPlatform == 'Web'
        ? dashboardWebActions
        : dashboardMobileActions;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.25,
        title: dashboardTitle,
        actions: dashboardActions,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : _DashboardContent(data: userData),
      //body: _DashboardContent(data: userData!.toJson()),
      // body: userData.when(
      //   data: (data) => _DashboardContent(data: data),
      //   loading: () => const Center(child: CircularProgressIndicator()),
      //   error: (e, _) => Center(child: Text('Error: $e')),
      // ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  //final Map<String, dynamic> data;
  final ServiceProviderLoginDataUserMessageModel data;

  const _DashboardContent({required this.data});
  void _showPaymentDialog(
      BuildContext context, ServiceProviderLoginDataUserMessageModel userData) {
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
              // CopyableListTile(
              //   icon: Icons.account_circle,
              //   label: "CBU",
              //   value: userData['RoelaCBUCuentaBancaria'] ?? 'No disponible',
              // ),
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
                    "Saldo a pagar: ${userData.saldoActual.asStringWithPrecSpanish(2)}"),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text("Último pago: ${userData.ultFechaPago.toES()}"),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                    "Vencimiento: 10/${today.month.toString().padLeft(2, "0")}/${today.year}"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Acá podrías iniciar el flujo real de pago
            //     Navigator.pop(context);
            //   },
            //   icon: const Icon(Icons.check),
            //   label: const Text("Pagar ahora"),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String functionName = '_DashboardContent.build';
    String logFunctionName = '.::$functionName::.';
    return LayoutBuilder(builder: (context, constraints) {
      if (debug) {
        developer.log(
            'logFunctionName: $logFunctionName, constraints: $constraints '
            'maxWidth: ${constraints.maxWidth}, maxHeight: ${constraints.maxHeight}');
      }
      //final isWide = constraints.maxWidth > 600;
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
                InfoCard(title: "Último pago", value: data.ultFechaPago.toES()),
                InfoCard(title: "Estado", value: data.estado),
                const SizedBox(height: 5),
                //FrameWithScroll(),
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
            // SizedBox(
            //   width: constraints.maxWidth != double.infinity
            //       ? constraints.maxWidth - 32
            //       : constraints.maxWidth,
            //   height: 400,
            //   child: BillingWidget(
            //     constraints: constraints,
            //     pType: "CreditosVT",
            //   ),
            // ),
            // SizedBox(height: 5),
            // SizedBox(
            //   width: constraints.maxWidth != double.infinity
            //       ? constraints.maxWidth - 32
            //       : constraints.maxWidth,
            //   height: 400,
            //   child: BillingWidget(
            //     constraints: constraints,
            //     pType: "DebitosVT",
            //   ),
            // ),
            // SizedBox(height: 5),
          ],
        ),
      );

      return FrameWithScroll(
        pBody: rbody,
      );
      return Padding(
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
                InfoCard(title: "Último pago", value: data.ultFechaPago.toES()),
                InfoCard(title: "Estado", value: data.estado),
                const SizedBox(height: 5),
                //FrameWithScroll(),
                if (1 == 2)
                  Container(
                    height: 400,
                    child: BillingWidget(
                      constraints: constraints,
                      pType: "FacturasVT",
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
