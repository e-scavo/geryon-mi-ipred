import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/features/auth/controllers/login_controller.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/loading_generic.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/feature_error_state.dart';
import 'package:geryon_web_app_ws_v2/shared/widgets/shake_text_field.dart';

class LoginPageWidget extends ConsumerStatefulWidget {
  const LoginPageWidget({super.key});

  @override
  ConsumerState<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends ConsumerState<LoginPageWidget> {
  final _dniController = TextEditingController();
  final _shakeKey = GlobalKey<ShakeTextFieldState>();
  final _controller = LoginController();

  late LoginViewState _loginState;

  @override
  void initState() {
    super.initState();
    _loginState = _controller.buildInitialViewState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  Future<void> _checkAutoLogin() async {
    final bootstrapResult = await _controller.prepareViewState();

    if (!mounted) {
      return;
    }

    _dniController.text = bootstrapResult.state.dni;

    if (bootstrapResult.shouldAutoSubmit) {
      setState(() {
        _loginState = bootstrapResult.state;
      });

      await _login(isAutoSubmit: true);
      return;
    }

    setState(() {
      _loginState = _controller.buildBootstrapReadyState(
        currentState: bootstrapResult.state,
        dni: bootstrapResult.state.dni,
        rememberMe: bootstrapResult.state.rememberMe,
      );
    });
  }

  Future<void> _login({
    bool isAutoSubmit = false,
  }) async {
    final currentDni = _dniController.text.trim();
    final currentRememberMe = _loginState.rememberMe;

    setState(() {
      _loginState = _controller.buildSubmitLoadingState(
        currentState: _loginState,
        dni: currentDni,
        rememberMe: currentRememberMe,
      );
    });

    final result = await _controller.login(
      ref: ref,
      dni: currentDni,
      rememberMe: currentRememberMe,
    );

    if (!mounted) {
      return;
    }

    if (!result.success) {
      setState(() {
        _loginState = _controller.buildSubmitFailureState(
          currentState: _loginState,
          dni: currentDni,
          rememberMe: currentRememberMe,
          errorTitle: result.errorTitle,
          errorMessage: result.errorMessage,
          errorType: result.errorType,
        );
      });

      if (_loginState.hasValidationError) {
        _shakeKey.currentState?.shake();
      }

      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context, result.response);
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isBootstrapLoading = _loginState.isBootstrapLoading;
    final bool isSubmitLoading = _loginState.isSubmitLoading;
    final bool isBusy = _loginState.isLoading;
    final theme = Theme.of(context);

    Widget buildLoginCard() {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Card(
          elevation: 2,
          surfaceTintColor: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 28,
            ),
            child: IgnorePointer(
              ignoring: isBusy,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo-ipred-color.png',
                    scale: 2.5,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Ingresá con tu DNI o CUIT',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Accedé a tu panel de cliente y a tus comprobantes disponibles.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShakeTextField(
                    key: _shakeKey,
                    controller: _dniController,
                    hintText: 'Ingresá tu DNI o CUIT',
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Checkbox(
                        value: _loginState.rememberMe,
                        onChanged: isBusy
                            ? null
                            : (v) {
                                setState(() {
                                  _loginState =
                                      _controller.buildToggleRememberMeState(
                                    currentState: _loginState,
                                    rememberMe: v ?? false,
                                  );
                                });
                              },
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text('Recordarme'),
                      ),
                    ],
                  ),
                  if (_loginState.hasError) ...[
                    const SizedBox(height: 18),
                    FeatureErrorState(
                      title: _loginState.errorTitle ?? 'No pudimos ingresar',
                      message: _loginState.errorMessage ??
                          'Ocurrió un problema al intentar ingresar.',
                      padding: EdgeInsets.zero,
                      maxWidth: double.infinity,
                      icon: _loginState.hasValidationError
                          ? Icons.edit_note_outlined
                          : Icons.error_outline,
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isBusy ? null : _login,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSubmitLoading) ...[
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(_loginState.submitButtonLabel),
                        ],
                      ),
                    ),
                  ),
                  if (_loginState.hasRecoverableError) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Revisá el dato ingresado y volvé a intentarlo.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.78,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (isBootstrapLoading) {
      return Scaffold(
        body: LoadingGeneric(
          loadingText: _loginState.bootstrapLoadingText,
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLoginCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class PopUpLoginWidget<T> extends PopupRoute<T> {
  PopUpLoginWidget();

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Dismissible Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const Center(
      child: Material(
        type: MaterialType.transparency,
        child: LoginPageWidget(),
      ),
    );
  }
}
