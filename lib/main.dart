import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metrovalencia_reloaded/screens/home/home.dart';
import 'package:metrovalencia_reloaded/screens/transportCards/check_transport_cards.dart';
import 'package:metrovalencia_reloaded/service_locator.dart';

import 'environments/environment.dart';

Future<void> main() async {
  String environment = getEnvironment();

  Environment().initConfig(environment);

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupServiceLocator();
  runApp(
    EasyLocalization(
      child: const MyApp(),
      supportedLocales: const [Locale('es', '')],
      path: 'i18n',
      useOnlyLangCode: true,
      fallbackLocale: const Locale('es', ''),
    ),
  );
}

String getEnvironment() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.PROD,
  );
  // flutter run --dart-define=ENVIRONMENT=PROD
  return environment;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateTitle: (context) {
          return tr('appTitle');
        },
        theme: ThemeData(
          fontFamily: 'TitilliumWeb',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 222, 28, 44),
            secondary: const Color.fromARGB(255, 47, 47, 47),
          ),
        ),
        home: const MyHomePage(),
        builder: EasyLoading.init(),
        // Localization
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: const Locale('es', ''));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomeScreen(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
