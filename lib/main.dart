import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/core/utils/utils.dart';
import 'package:geryon_web_app_ws_v2/features/dashboard/presentation/dashboard_page.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/global_loading_dialog_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mi IP·RED',
      debugShowCheckedModeBanner: false,
      theme: ipredTheme,
      home: MyStartingPage(),
    );
  }
}

class AppStartupViewState {
  final bool hasCompletedInitialBoundary;

  const AppStartupViewState({
    required this.hasCompletedInitialBoundary,
  });

  const AppStartupViewState.initial() : hasCompletedInitialBoundary = false;

  bool get isBootstrapping => !hasCompletedInitialBoundary;

  AppStartupViewState markBoundaryCompleted() {
    return const AppStartupViewState(
      hasCompletedInitialBoundary: true,
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

  late AppStartupViewState _startupState;
  int buildTimes = 0;

  @override
  void initState() {
    super.initState();
    _startupState = const AppStartupViewState.initial();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWork();
    });
  }

  void _completeStartupBoundary() {
    if (!mounted) {
      return;
    }

    setState(() {
      _startupState = _startupState.markBoundaryCompleted();
    });
  }

  Future<void> _initWork() async {
    const functionName = '_initWork';
    const logFunctionName = '.::$functionName::.';

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

    if (appStatus.isReady) {
      _completeStartupBoundary();
      return;
    }

    developer.log(
      'App no está lista, inicializando...',
      name: '$logClassName - $logFunctionName',
    );

    final rStatus =
        await Navigator.of(context).push(ModelGeneralPoPUpLoadingProgress());

    developer.log(
      'rStatus: $rStatus',
      name: '$logClassName - $logFunctionName',
    );

    if (!mounted) {
      return;
    }

    if (!rStatus) {
      return;
    }

    _completeStartupBoundary();
  }

  @override
  Widget build(BuildContext context) {
    const functionName = 'BUILD';
    const logFunctionName = '.::$functionName::.';
    buildTimes++;

    developer.log(
      'Construyendo la página de inicio... [$buildTimes]',
      name: '$logClassName - $logFunctionName',
    );

    final appStatus = ref.watch(notifierServiceProvider);

    if (_startupState.isBootstrapping) {
      developer.log(
        'Startup boundary aún en bootstrap...',
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

    return DashboardPage(clientID: -1);
  }
}
