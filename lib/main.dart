import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hire_q/helpers/routes.dart';
import 'package:hire_q/helpers/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hire_q/screens/splash/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';
// import provider
import 'package:hire_q/provider/index.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  FluroRouter.setupRouter();
  setPathUrlStrategy();
  initializeDateFormatting().then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: AppState(),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => AppLocale(),
          // ),
          // ChangeNotifierProvider(
          //     create: (_) => DataNotifier(),
          //   ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        // scaffoldBackgroundColor: Colors.grey.shade100,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
        //     .copyWith(secondary: secondaryColor),
      ),
      initialRoute: '/',
      // onUnknownRoute: (settings) => MaterialPageRoute(
      //   builder: (context) => NotFoundPage(),
      // ),
      onGenerateRoute: FluroRouter.router.generator,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
