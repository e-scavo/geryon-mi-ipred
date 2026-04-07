import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/shared/formatters/app_formatters.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/app_overlay_panel.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/copyable_list_tile.dart';

class PaymentMethodsDialog extends StatelessWidget {
  final ServiceProviderLoginDataUserMessageModel userData;

  const PaymentMethodsDialog({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double dialogWidth = constraints.maxWidth.clamp(320.0, 520.0);
        final double dialogHeight = constraints.maxHeight.clamp(320.0, 460.0);

        return Center(
          child: AppOverlayPanel(
            title: 'MEDIOS DE PAGO',
            constraints: BoxConstraints.tightFor(
              width: dialogWidth,
              height: dialogHeight,
            ),
            titleColorBackground: theme.colorScheme.primary,
            onClose: () => Navigator.of(context).pop(),
            headerWidget: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos para pagar por fuera de la plataforma',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Podés copiar alias, códigos y referencias antes de cerrar esta ventana.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.78,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bodyWidget: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CopyableListTile(
                    icon: Icons.account_circle,
                    label: 'Alias',
                    value: AppFormatters.visibleText(
                      userData.roelaAliasCuentaBancaria,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CopyableListTile(
                    icon: Icons.account_circle,
                    label: 'Pago Fácil / Pago Mis Cuentas',
                    value: AppFormatters.visibleText(userData.codigoPMCnPF),
                  ),
                  const SizedBox(height: 12),
                  CopyableListTile(
                    icon: Icons.account_circle,
                    label: 'Código de barras',
                    value: AppFormatters.visibleText(
                      userData.codigoBarrasPMCnPF,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CopyableListTile(
                    icon: Icons.credit_card,
                    label: 'Saldo actual',
                    value: AppFormatters.currency(userData.saldoActual),
                  ),
                  const SizedBox(height: 12),
                  CopyableListTile(
                    icon: Icons.calendar_today,
                    label: 'Último pago',
                    value: AppFormatters.date(
                      userData.ultFechaPago.toDateModel(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CopyableListTile(
                    icon: Icons.calendar_today,
                    label: 'Vencimiento',
                    value: AppFormatters.dueDateFromReference(today),
                  ),
                ],
              ),
            ),
            footerWidget: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScreenPoPUpPaymentMethodsDialog<T> extends PopupRoute<T> {
  final ServiceProviderLoginDataUserMessageModel userData;

  ScreenPoPUpPaymentMethodsDialog({
    required this.userData,
  });

  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Medios de pago';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PaymentMethodsDialog(
          userData: userData,
        ),
      ),
    );
  }
}
