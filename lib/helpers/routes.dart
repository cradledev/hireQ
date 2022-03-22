import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as route;
import 'package:hire_q/screens/lobby/lobby_screen.dart';

// screens
import 'package:hire_q/screens/splash/splash_screen.dart';
import 'package:hire_q/screens/auth/login_screen.dart';
import 'package:hire_q/screens/home/home_screen.dart';

class FluroRouter {
  static final router = route.FluroRouter();
  //Login
  static final route.Handler _loginHandler = route.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return const LoginScreen();
  });
  // Splash
  static final route.Handler _splashHandler = route.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return const SplashScreen();
  });
  // Home screen
  static final route.Handler _homeHandler = route.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return const HomeScreen();
  });

  // lobby screen
  static final route.Handler _lobbyHandler = route.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    // print(args.tabIndex);
    return LobbyScreen(indexTab: args.tabIndex);
  });
  static void setupRouter() {
    //Login
    router.define(
      '/',
      handler: _splashHandler,
      transitionType: route.TransitionType.fadeIn,
    );
    router.define(
      '/login',
      handler: _loginHandler,
      transitionType: route.TransitionType.fadeIn,
    );
    router.define(
      '/splash',
      handler: _splashHandler,
      transitionType: route.TransitionType.fadeIn,
    );
    router.define(
      '/home',
      handler: _homeHandler,
      transitionType: route.TransitionType.none,
    );

    router.define(
      '/lobby',
      handler: _lobbyHandler,
      transitionType: route.TransitionType.cupertino,
    );
  }
}
