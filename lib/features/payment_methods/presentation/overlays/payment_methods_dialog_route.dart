import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/payment_methods/presentation/overlays/payment_methods_dialog.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';

Future<T?> showPaymentMethodsDialog<T>(
  BuildContext context, {
  required ServiceProviderLoginDataUserMessageModel userData,
}) {
  return Navigator.of(context).push<T>(
    ScreenPoPUpPaymentMethodsDialog<T>(
      userData: userData,
    ),
  );
}
