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

  bool _rememberMe = true;
  bool _loading = false;

  Future<void> _checkAutoLogin() async {
    final initialState = await _controller.prepareInitialState();

    if (!mounted) {
      return;
    }

    _dniController.text = initialState.dni;

    setState(() {
      _rememberMe = initialState.rememberMe;
      _loading = initialState.shouldAutoSubmit;
    });

    if (initialState.shouldAutoSubmit) {
      await _login();
      return;
    }

    setState(() => _loading = false);
  }

  Future<void> _login() async {
    setState(() => _loading = true);

    final result = await _controller.login(
      ref: ref,
      dni: _dniController.text,
      rememberMe: _rememberMe,
    );

    if (!mounted) {
      return;
    }

    if (!result.success) {
      setState(() => _loading = false);

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v!)),
                  Text("Recordarme"),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child:
                    _loading ? CircularProgressIndicator() : Text("Ingresar"),
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
    ));
  }
}
