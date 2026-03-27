import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/features/auth/controllers/login_controller.dart';
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

    setState(() {
      _loginState = bootstrapResult.state;
    });

    if (bootstrapResult.shouldAutoSubmit) {
      await _login(isAutoSubmit: true);
    }
  }

  Future<void> _login({
    bool isAutoSubmit = false,
  }) async {
    final currentDni = _dniController.text.trim();
    final currentRememberMe = _loginState.rememberMe;

    if (!isAutoSubmit) {
      setState(() {
        _loginState = _controller.buildSubmitLoadingState(
          currentState: _loginState,
          dni: currentDni,
          rememberMe: currentRememberMe,
        );
      });
    }

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
        );
      });

      if ((result.errorMessage ?? '').contains('DNI/CUIT válido')) {
        _shakeKey.currentState?.shake();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Error desconocido.')),
      );
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
    final isLoading = _loginState.isLoading;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo-ipred-color.png',
                scale: 2.5,
              ),
              SizedBox(height: 24),
              ShakeTextField(
                key: _shakeKey,
                controller: _dniController,
                hintText: 'Ingrese DNI/CUIT',
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _loginState.rememberMe,
                    onChanged: isLoading
                        ? null
                        : (v) {
                            setState(() {
                              _loginState = _loginState.copyWith(
                                rememberMe: v ?? false,
                              );
                            });
                          },
                  ),
                  Text("Recordarme"),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                child:
                    isLoading ? CircularProgressIndicator() : Text("Ingresar"),
              ),
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
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return const Center(
      child: Material(
        type: MaterialType.transparency,
        child: LoginPageWidget(),
      ),
    );
  }
}
