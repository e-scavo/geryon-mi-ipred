// export 'package:geryon_web_app_ws_v2/features/auth/presentation/login_widget.dart';
// import 'dart:developer' as developer;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geryon_web_app_ws_v2/common_vars.dart';
// import 'package:geryon_web_app_ws_v2/models/Login/model.dart';
// import 'package:geryon_web_app_ws_v2/core/session/session_storage.dart';
// import 'package:geryon_web_app_ws_v2/shared/widgets/shake_text_field.dart';

// class LoginPageWidget extends ConsumerStatefulWidget {
//   const LoginPageWidget({super.key});

//   @override
//   ConsumerState<LoginPageWidget> createState() => _LoginPageWidgetState();
// }

// class _LoginPageWidgetState extends ConsumerState<LoginPageWidget> {
//   final _dniController = TextEditingController();
//   final _shakeKey = GlobalKey<ShakeTextFieldState>();

//   bool _rememberMe = true;
//   bool _loading = false;

//   void _checkAutoLogin() async {
//     final savedDni = await SessionStorage.getSavedDni();
//     if (savedDni != null && savedDni.isNotEmpty) {
//       _dniController.text = savedDni;
//       _rememberMe = true;
//       _login();
//     } else {
//       setState(() => _loading = false);
//     }
//   }

//   void _login() async {
//     final dni = _dniController.text.trim();
//     if (dni.isEmpty) {
//       _shakeKey.currentState?.shake(); // vibra el textfield
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Por favor, ingrese un DNI/CUIT válido.")),
//         );
//       }
//       return;
//     }

//     setState(() => _loading = true);
//     final pLogin = LoginModel(
//       dni: dni,
//       rememberMe: _rememberMe,
//     );
//     var rResponse = await ref.read(notifierServiceProvider).doLogin(
//           pLogin: pLogin,
//         );
//     if (debug) {
//       developer.log(
//         'LoginModel: doLogin response: ${rResponse.toString()}',
//         name: '.::LoginPageWidget::_login::.',
//       );
//     }
//     if (rResponse.errorCode != 0) {
//       setState(() => _loading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(rResponse.errorDsc.toString())),
//         );
//       }
//       return;
//     }
//     if (_rememberMe) await SessionStorage.saveDni(dni);
//     if (mounted) {
//       if (Navigator.canPop(context)) {
//         Navigator.pop(context, rResponse);
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkAutoLogin();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/logo-ipred-color.png',
//                 scale: 2.5,
//               ),
//               SizedBox(height: 24),
//               ShakeTextField(
//                 key: _shakeKey,
//                 controller: _dniController,
//                 hintText: 'Ingrese DNI/CUIT',
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Checkbox(
//                       value: _rememberMe,
//                       onChanged: (v) => setState(() => _rememberMe = v!)),
//                   Text("Recordarme"),
//                 ],
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _loading ? null : _login,
//                 child:
//                     _loading ? CircularProgressIndicator() : Text("Ingresar"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PopUpLoginWidget<T> extends PopupRoute<T> {
//   PopUpLoginWidget();

//   @override
//   Color? get barrierColor => Colors.black.withAlpha(0x50);

//   // This allows the popup to be dismissed by tapping the scrim or by pressing
//   // the escape key on the keyboard.
//   @override
//   bool get barrierDismissible => false;

//   @override
//   String? get barrierLabel => 'Dismissible Dialog';

//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);

//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return const Center(
//         child: Material(
//       type: MaterialType.transparency,
//       child: LoginPageWidget(), // Your ConsumerStatefulWidget
//     ));
//   }
// }
