import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/splash/animation_screen.dart';
import 'package:hire_q/screens/splash/splash_start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: const <Widget>[
        SplashStartScreen(),
        IgnorePointer(
          child: AnimationScreen(
            color: primaryColor,
          ),
        )
      ]),
    );
  }
}
