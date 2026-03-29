import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
import 'package:geryon_web_app_ws_v2/models/Login/model.dart';

enum LoginErrorType {
  validation,
  recoverable,
}

class LoginViewState {
  final String dni;
  final bool rememberMe;
  final bool isBootstrapLoading;
  final bool isSubmitLoading;
  final String? errorTitle;
  final String? errorMessage;
  final LoginErrorType? errorType;

  const LoginViewState({
    required this.dni,
    required this.rememberMe,
    required this.isBootstrapLoading,
    required this.isSubmitLoading,
    this.errorTitle,
    this.errorMessage,
    this.errorType,
  });

  const LoginViewState.initial()
      : dni = '',
        rememberMe = true,
        isBootstrapLoading = true,
        isSubmitLoading = false,
        errorTitle = null,
        errorMessage = null,
        errorType = null;

  bool get isLoading => isBootstrapLoading || isSubmitLoading;
  bool get hasError =>
      errorMessage != null &&
      errorMessage!.trim().isNotEmpty &&
      errorType != null;
  bool get hasValidationError => errorType == LoginErrorType.validation;
  bool get hasRecoverableError => errorType == LoginErrorType.recoverable;

  String get bootstrapLoadingText => 'Preparando ingreso...';
  String get submitButtonLabel =>
      isSubmitLoading ? 'Validando ingreso...' : 'Ingresar';

  LoginViewState copyWith({
    String? dni,
    bool? rememberMe,
    bool? isBootstrapLoading,
    bool? isSubmitLoading,
    String? errorTitle,
    String? errorMessage,
    LoginErrorType? errorType,
    bool clearError = false,
  }) {
    return LoginViewState(
      dni: dni ?? this.dni,
      rememberMe: rememberMe ?? this.rememberMe,
      isBootstrapLoading: isBootstrapLoading ?? this.isBootstrapLoading,
      isSubmitLoading: isSubmitLoading ?? this.isSubmitLoading,
      errorTitle: clearError ? null : (errorTitle ?? this.errorTitle),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorType: clearError ? null : (errorType ?? this.errorType),
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
  final String? errorTitle;
  final String? errorMessage;
  final LoginErrorType? errorType;
  final dynamic response;

  const LoginControllerResult({
    required this.success,
    this.errorTitle,
    this.errorMessage,
    this.errorType,
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
      clearError: true,
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
      clearError: true,
    );
  }

  LoginViewState buildSubmitFailureState({
    required LoginViewState currentState,
    required String dni,
    required bool rememberMe,
    required String? errorTitle,
    required String? errorMessage,
    required LoginErrorType? errorType,
  }) {
    return currentState.copyWith(
      dni: dni,
      rememberMe: rememberMe,
      isBootstrapLoading: false,
      isSubmitLoading: false,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      errorType: errorType,
    );
  }

  LoginViewState buildToggleRememberMeState({
    required LoginViewState currentState,
    required bool rememberMe,
  }) {
    return currentState.copyWith(
      rememberMe: rememberMe,
    );
  }

  LoginViewState buildDniEditedState({
    required LoginViewState currentState,
    required String dni,
  }) {
    return currentState.copyWith(
      dni: dni,
      clearError: true,
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
        errorTitle: 'Ingresá un DNI/CUIT válido',
        errorMessage: 'Necesitamos un DNI o CUIT para continuar.',
        errorType: LoginErrorType.validation,
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
        errorTitle: 'No pudimos iniciar sesión',
        errorMessage: rResponse.errorDsc.toString(),
        errorType: LoginErrorType.recoverable,
        response: rResponse,
      );
    }

    if (rememberMe) {
      await SessionStorage.saveDni(normalizedDni);
    } else {
      await SessionStorage.removeSavedDni();
    }

    return LoginControllerResult(
      success: true,
      response: rResponse,
    );
  }
}
