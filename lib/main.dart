import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/GeneralLoadingProgress/popup_model.dart';
import 'package:geryon_web_app_ws_v2/pages/dashboard_page.dart';
import 'package:geryon_web_app_ws_v2/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final savedDoc = await SessionStorage.getSavedDni();
  // // runApp(
  // //   ProviderScope(
  // //     child: MyApp(
  // //         startingPage:
  // //             savedDoc != null ? DashboardPage(dni: savedDoc) : LoginPage()),
  // //   ),
  // // );
  if (!Utils.isProductionWeb) {
    developer.log(
      '🚀 Main: main: Iniciando la aplicación en modo DEBUG',
      name: '.::Main::.',
    );
    debug = true;
  }
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //final Widget startingPage;

  const MyApp({
    super.key,
    //required this.startingPage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mi IP·RED',
      debugShowCheckedModeBanner: false,
      theme: ipredTheme,
      // theme: ThemeData(
      //   colorScheme: ipredScheme,
      //   useMaterial3: true,
      //   scaffoldBackgroundColor: ipredScheme.surface,
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: ipredScheme.primary,
      //     foregroundColor: ipredScheme.onPrimary,
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: ipredScheme.primary,
      //       foregroundColor: ipredScheme.onPrimary,
      //     ),
      //   ),
      // ),
      home: MyStartingPage(),
    );
  }
}

class MyStartingPage extends ConsumerStatefulWidget {
  const MyStartingPage({super.key});

  @override
  ConsumerState<MyStartingPage> createState() => _MyStartingPageState();
}

class _MyStartingPageState extends ConsumerState<MyStartingPage> {
  static final String className = '_MyStartingPageState';
  static final String logClassName = '.::$className::.';
  bool isInit = true;
  int buildTimes = 0;
  @override
  void initState() {
    super.initState();
    ref.read(notifierServiceProvider).addListener(() {
      if (debug) {
        developer.log(
          '🚀 initState: HOME ${ref.read(notifierServiceProvider).initStage}',
          name: '$logClassName - .::initState::.',
        );
      }
    });
    if (debug) {
      developer.log(
        '🚀 initState ejecutado',
        name: '$logClassName - .::initState::.',
      );
    }
    // 🚀 Esto fuerza la ejecución del FutureProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWork();
    });
  }

  _initWork() async {
    String functionName = '_initWork';
    String logFunctionName = '.::$functionName::.';
    developer.log(
      'Iniciando trabajo...',
      name: '$logClassName - $logFunctionName',
    );
    var appStatus = ref.read(notifierServiceProvider);
    developer.log(
      'initStage:${appStatus.initStage.toString()}',
      name: '$logClassName - $logFunctionName',
    );
    developer.log(
      'isReady:${appStatus.isReady}',
      name: '$logClassName - $logFunctionName',
    );

    if (!appStatus.isReady) {
      developer.log(
        'App no está lista, inicializando...',
        name: '$logClassName - $logFunctionName',
      );
      bool rStatus =
          await Navigator.of(context).push(ModelGeneralPoPUpLoadingProgress());
      developer.log(
        'rStatus: $rStatus',
        name: '$logClassName - $logFunctionName',
      );
      if (!mounted) {
        return false;
      }
      if (!rStatus) {
        return;
      }
      setState(() {
        isInit = false;
      });
    }
    /*

    appStatus = ref.read(notifierServiceProvider);
    if (!appStatus.isUserLoggedIn) {
      //developer.log('appStatus.isUserLoggedIn :${appStatus.isUserLoggedIn}');
      bool rLogin = await Navigator.of(context).push(ModelGeneralPoPUpLogin());
      if (!mounted) {
        return false;
      }
      if (!rLogin) {
        return;
      }
      //developer.log('rLogin: ${rLogin} ${appStatus.isReady}');
      developer.log('22222');
    }
    */
    //return null;
  }

  @override
  Widget build(BuildContext context) {
    String functionName = 'BUILD';
    String logFunctionName = '.::$functionName::.';
    buildTimes++;

    developer.log(
      'Construyendo la página de inicio... [$buildTimes]',
      name: '$logClassName - $logFunctionName',
    );
    //final _ = ref.watch(serviceProviderConfigProvider);
    final appStatus = ref.watch(notifierServiceProvider);
    //if (!appStatus.isReady) {
    if (isInit) {
      developer.log(
        'isInit es true, AÚN ejecutando _initWork...',
        name: '$logClassName - $logFunctionName',
      );
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      if (appStatus.isProgress) {
        developer.log(
          'App no está lista, mostrando indicador de carga...',
          name: '$logClassName - $logFunctionName',
        );

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
      //return const Placeholder();
      return DashboardPage(clientID: -1); // Aquí puedes pasar el clientID real
    }
  }
}
