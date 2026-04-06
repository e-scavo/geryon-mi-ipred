import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/copyable_list_tile.dart';

class PaymentMethodsDialog extends StatelessWidget {
  final ServiceProviderLoginDataUserMessageModel userData;

  const PaymentMethodsDialog({
    super.key,
    required this.userData,
  });

  String _resolveAvailableValue(String value) {
    return value.isEmpty ? 'No disponible' : value;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return AlertDialog(
      title: const Text('Medios de pago'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CopyableListTile(
            icon: Icons.account_circle,
            label: 'Alias',
            value: _resolveAvailableValue(userData.roelaAliasCuentaBancaria),
          ),
          CopyableListTile(
            icon: Icons.account_circle,
            label: 'Pago Fácil / Pago Mis Cuentas',
            value: _resolveAvailableValue(userData.codigoPMCnPF),
          ),
          CopyableListTile(
            icon: Icons.account_circle,
            label: 'Código de barras',
            value: _resolveAvailableValue(userData.codigoBarrasPMCnPF),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text(
              'Saldo a pagar: ${userData.saldoActual.asStringWithPrecSpanish(2)}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text('Último pago: ${userData.ultFechaPago.toES()}'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              'Vencimiento: 10/${today.month.toString().padLeft(2, '0')}/${today.year}',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
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
    return Center(
      child: PaymentMethodsDialog(
        userData: userData,
      ),
    );
  }
}
