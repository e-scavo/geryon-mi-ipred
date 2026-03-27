import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/models/Login/model.dart';

class LoginControllerInitialState {
  final String dni;
  final bool rememberMe;
  final bool shouldAutoSubmit;

  const LoginControllerInitialState({
    required this.dni,
    required this.rememberMe,
    required this.shouldAutoSubmit,
  });
}

class LoginControllerResult {
  final bool success;
  final String? errorMessage;
  final dynamic response;

  const LoginControllerResult({
    required this.success,
    this.errorMessage,
    this.response,
  });
}

class LoginController {
  static const String _logName = '.::LoginController::.';

  Future<LoginControllerInitialState> prepareInitialState() async {
    final savedDni = await SessionStorage.getSavedDni();
    final normalizedDni = (savedDni ?? '').trim();

    return LoginControllerInitialState(
      dni: normalizedDni,
      rememberMe: normalizedDni.isNotEmpty,
      shouldAutoSubmit: normalizedDni.isNotEmpty,
    );
  }

  Future<LoginControllerResult> login({
    required WidgetRef ref,
    required String dni,
    required bool rememberMe,
  }) async {
    final normalizedDni = dni.trim();

    if (normalizedDni.isEmpty) {
      return const LoginControllerResult(
        success: false,
        errorMessage: 'Por favor, ingrese un DNI/CUIT válido.',
      );
    }

    final pLogin = LoginModel(
      dni: normalizedDni,
      rememberMe: rememberMe,
    );

    final rResponse = await ref.read(notifierServiceProvider).doLogin(
          pLogin: pLogin,
        );

    if (debug) {
      developer.log(
        'login response: ${rResponse.toString()}',
        name: '$_logName.login',
      );
    }

    if (rResponse.errorCode != 0) {
      return LoginControllerResult(
        success: false,
        errorMessage: rResponse.errorDsc.toString(),
        response: rResponse,
      );
    }

    if (rememberMe) {
      await SessionStorage.saveDni(normalizedDni);
    }

    return LoginControllerResult(
      success: true,
      response: rResponse,
    );
  }
}
