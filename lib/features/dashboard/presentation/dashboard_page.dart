import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/billing_widget.dart';
import 'package:geryon_web_app_ws_v2/features/dashboard/controllers/dashboard_controller.dart';
import 'package:geryon_web_app_ws_v2/features/payment_methods/presentation/overlays/payment_methods_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/loading_generic.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/shared/layouts/frame_with_scroll.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_empty_state.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_error_state.dart';
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompactSurface = screenWidth < 700;
    final bool useCompactHeader = Utils.isPlatform != 'Web' || isCompactSurface;

    final dashboardTitle = useCompactHeader
        ? _buildDashboardCompactTitle(
            context: context,
            ref: ref,
            dashboardState: dashboardState,
          )
        : _buildDashboardWebTitle();

    final dashboardActions = useCompactHeader
        ? _buildDashboardCompactActions(
            context: context,
            ref: ref,
          )
        : _buildDashboardWebActions(
            context: context,
            ref: ref,
            dashboardState: dashboardState,
          );

    Widget body;

    if (dashboardState.isLoadingSurface) {
      body = LoadingGeneric(
        loadingText: dashboardState.loadingTitle,
      );
    } else if (dashboardState.isEmptySurface) {
      body = FeatureEmptyState(
        title: dashboardState.emptyTitle,
        message: dashboardState.emptyMessage,
        icon: Icons.groups_2_outlined,
      );
    } else if (dashboardState.isOperationalContextInvalid) {
      body = FeatureErrorState(
        title: dashboardState.invalidContextTitle,
        message: dashboardState.invalidContextMessage,
        icon: Icons.person_search_outlined,
      );
    } else {
      body = _DashboardContent(data: userData!);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            useCompactHeader ? kToolbarHeight : kToolbarHeight * 1.25,
        title: dashboardTitle,
        actions: dashboardActions,
      ),
      body: body,
    );
  }

  Widget _buildDashboardWebTitle() {
    return Row(
      children: [
        Flexible(
          child: Image.asset(
            'assets/logo-white.png',
            fit: BoxFit.contain,
            height: kToolbarHeight * 0.8,
          ),
        ),
        const SizedBox(width: 8),
        const Text("Panel de cliente"),
      ],
    );
  }

  Widget _buildDashboardCompactTitle({
    required BuildContext context,
    required WidgetRef ref,
    required DashboardResolvedState dashboardState,
  }) {
    final bool selectorEnabled = dashboardState.canSelectClient;

    return Row(
      children: [
        Flexible(
          child: Image.asset(
            'assets/logo-white.png',
            fit: BoxFit.contain,
            height: kToolbarHeight * 0.7,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Panel de cliente",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<int>(
          enabled: selectorEnabled,
          tooltip: selectorEnabled
              ? "Cambiar cliente"
              : "No hay otros clientes disponibles",
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
          icon: Icon(
            Icons.person,
            color: selectorEnabled
                ? Colors.white
                : Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDashboardWebActions({
    required BuildContext context,
    required WidgetRef ref,
    required DashboardResolvedState dashboardState,
  }) {
    final bool selectorEnabled = dashboardState.canSelectClient;

    return [
      PopupMenuButton<int>(
        enabled: selectorEnabled,
        tooltip: selectorEnabled
            ? "Cambiar cliente"
            : "No hay otros clientes disponibles",
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Text(
                _controller.resolveSelectorLabel(
                  state: dashboardState,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
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

  List<Widget> _buildDashboardCompactActions({
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

  // Phase 10.2:
  // Surface oficial de comprobantes visibles en dashboard.
  // La exposición se apoya en capabilities ya soportadas por BillingWidget.
  static const List<String> _visibleBillingTypes = [
    "FacturasVT",
    "RecibosVT",
    "DebitosVT",
    "CreditosVT",
  ];

  Widget _buildBillingSection({
    required BoxConstraints constraints,
    required String type,
  }) {
    return SizedBox(
      width: double.infinity,
      child: BillingWidget(
        constraints: constraints,
        pType: type,
      ),
    );
  }

  List<Widget> _buildBillingSections({
    required BoxConstraints constraints,
  }) {
    final List<Widget> widgets = [];

    for (int i = 0; i < _visibleBillingTypes.length; i++) {
      widgets.add(
        _buildBillingSection(
          constraints: constraints,
          type: _visibleBillingTypes[i],
        ),
      );

      if (i < _visibleBillingTypes.length - 1) {
        widgets.add(const SizedBox(height: 22));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    String functionName = '_DashboardContent.build';
    String logFunctionName = '.::$functionName::.';
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (debug) {
          developer.log(
            'logFunctionName: $logFunctionName, constraints: $constraints '
            'maxWidth: ${constraints.maxWidth}, maxHeight: ${constraints.maxHeight}',
          );
        }

        final bool isCompact = constraints.maxWidth < 700;
        final double contentMaxWidth = isCompact ? 640 : 1080;
        final double horizontalPadding = isCompact ? 16 : 24;
        final double verticalPadding = isCompact ? 16 : 24;
        final double contentInsetX = isCompact ? 0 : 8;
        final double contentInsetY = isCompact ? 0 : 4;

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

        final Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenido, ${data.razonSocial}",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                InfoCard(title: "Documento", value: myDNI),
                InfoCard(
                  title: "Saldo",
                  value: data.saldoActual.asStringWithPrecSpanish(2),
                  actionLabel: "Ver medios de pago",
                  onAction: () => showPaymentMethodsDialog(
                    context,
                    userData: data,
                  ),
                ),
                InfoCard(
                  title: "Último pago",
                  value: data.ultFechaPago.toES(),
                ),
                InfoCard(title: "Estado", value: data.estado),
              ],
            ),
            const SizedBox(height: 28),
            ..._buildBillingSections(
              constraints: constraints,
            ),
            const SizedBox(height: 12),
          ],
        );

        final Widget rbody = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: contentInsetX,
                  vertical: contentInsetY,
                ),
                child: content,
              ),
            ),
          ),
        );

        return FrameWithScroll(
          pBody: rbody,
        );
      },
    );
  }
}
