import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/models/Login/model.dart';

class LoginViewState {
  final String dni;
  final bool rememberMe;
  final bool isBootstrapLoading;
  final bool isSubmitLoading;

  const LoginViewState({
    required this.dni,
    required this.rememberMe,
    required this.isBootstrapLoading,
    required this.isSubmitLoading,
  });

  const LoginViewState.initial()
      : dni = '',
        rememberMe = true,
        isBootstrapLoading = true,
        isSubmitLoading = false;

  bool get isLoading => isBootstrapLoading || isSubmitLoading;

  LoginViewState copyWith({
    String? dni,
    bool? rememberMe,
    bool? isBootstrapLoading,
    bool? isSubmitLoading,
  }) {
    return LoginViewState(
      dni: dni ?? this.dni,
      rememberMe: rememberMe ?? this.rememberMe,
      isBootstrapLoading: isBootstrapLoading ?? this.isBootstrapLoading,
      isSubmitLoading: isSubmitLoading ?? this.isSubmitLoading,
    );
  }
}

class LoginBootstrapResult {
  final LoginViewState state;
  final bool shouldAutoSubmit;

  const LoginBootstrapResult({
    required this.state,
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

  LoginViewState buildInitialViewState() {
    return const LoginViewState.initial();
  }

  Future<LoginBootstrapResult> prepareViewState() async {
    final savedDni = await SessionStorage.getSavedDni();
    final normalizedDni = (savedDni ?? '').trim();
    final shouldAutoSubmit = normalizedDni.isNotEmpty;

    return LoginBootstrapResult(
      state: LoginViewState(
        dni: normalizedDni,
        rememberMe: shouldAutoSubmit,
        isBootstrapLoading: shouldAutoSubmit,
        isSubmitLoading: false,
      ),
      shouldAutoSubmit: shouldAutoSubmit,
    );
  }

  LoginViewState buildBootstrapReadyState({
    required LoginViewState currentState,
    required String dni,
    required bool rememberMe,
  }) {
    return currentState.copyWith(
      dni: dni,
      rememberMe: rememberMe,
      isBootstrapLoading: false,
      isSubmitLoading: false,
    );
  }

  LoginViewState buildSubmitLoadingState({
    required LoginViewState currentState,
    required String dni,
    required bool rememberMe,
  }) {
    return currentState.copyWith(
      dni: dni,
      rememberMe: rememberMe,
      isBootstrapLoading: false,
      isSubmitLoading: true,
    );
  }

  LoginViewState buildSubmitFailureState({
    required LoginViewState currentState,
    required String dni,
    required bool rememberMe,
  }) {
    return currentState.copyWith(
      dni: dni,
      rememberMe: rememberMe,
      isBootstrapLoading: false,
      isSubmitLoading: false,
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
