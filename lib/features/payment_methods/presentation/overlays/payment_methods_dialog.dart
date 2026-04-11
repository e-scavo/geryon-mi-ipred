import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/shared/actions/copy_action.dart';
import 'package:geryon_web_app_ws_v2/shared/actions/external_action.dart';
import 'package:geryon_web_app_ws_v2/shared/formatters/app_formatters.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/app_overlay_panel.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/copyable_list_tile.dart';

class PaymentMethodsDialog extends StatelessWidget {
  final ServiceProviderLoginDataUserMessageModel userData;

  const PaymentMethodsDialog({
    super.key,
    required this.userData,
  });

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final normalized = value?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
  }

  String? _readString(String fieldName) {
    try {
      final dynamic raw =
          (userData as dynamic).toJson().cast<String, dynamic>()[fieldName];
      if (raw == null) {
        return null;
      }

      final value = raw.toString().trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  String? _resolveExternalUrl() {
    return _firstNonEmpty([
      _readString('paymentUrl'),
      _readString('externalUrl'),
      _readString('redirectUrl'),
      _readString('link'),
      _readString('url'),
    ]);
  }

  String _buildPaymentSummary(DateTime today) {
    return '''
Alias: ${AppFormatters.visibleText(userData.roelaAliasCuentaBancaria)}
Pago Fácil / Pago Mis Cuentas: ${AppFormatters.visibleText(userData.codigoPMCnPF)}
Código de barras: ${AppFormatters.visibleText(userData.codigoBarrasPMCnPF)}
Saldo actual: ${AppFormatters.currency(userData.saldoActual)}
Último pago: ${AppFormatters.date(userData.ultFechaPago.toDateModel())}
Vencimiento: ${AppFormatters.dueDateFromReference(today)}
'''
        .trim();
  }

  Future<void> _copyPaymentSummary(
    BuildContext context,
    DateTime today,
  ) async {
    await CopyAction.copy(
      context: context,
      value: _buildPaymentSummary(today),
      successMessage: 'Resumen de medios de pago copiado',
    );
  }

  Future<void> _openExternalPayment(BuildContext context) async {
    final String? externalUrl = _resolveExternalUrl();

    if (externalUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este método no tiene enlace disponible'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await ExternalAction.open(
      context: context,
      url: externalUrl,
    );
  }

  Widget _buildQuickActionsCard(
    BuildContext context,
    ThemeData theme,
    DateTime today,
    String? externalUrl,
  ) {
    final bool hasExternalUrl = externalUrl != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones rápidas',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasExternalUrl
                ? 'Podés copiar un resumen o abrir el enlace externo disponible para este medio.'
                : 'Podés copiar un resumen completo. Este medio no expone un enlace externo por el momento.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => _copyPaymentSummary(context, today),
                icon: const Icon(Icons.copy_all_outlined),
                label: const Text('Copiar resumen'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openExternalPayment(context),
                icon: Icon(
                  hasExternalUrl ? Icons.open_in_new : Icons.link_off,
                ),
                label: Text(
                  hasExternalUrl ? 'Abrir enlace' : 'Sin enlace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final ThemeData theme = Theme.of(context);
    final String? externalUrl = _resolveExternalUrl();

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
                  _buildQuickActionsCard(
                    context,
                    theme,
                    today,
                    externalUrl,
                  ),
                  const SizedBox(height: 16),
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
