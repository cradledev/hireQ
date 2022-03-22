import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hire_q/helpers/constants.dart';

class SplashStartScreen extends StatefulWidget {
  const SplashStartScreen({Key key}) : super(key: key);

  @override
  _SplashStartScreen createState() => _SplashStartScreen();
}

class _SplashStartScreen extends State<SplashStartScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    var _duration = const Duration(seconds: 6);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "START YOUR CAREER WITH Q",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                      wordSpacing: 5,
                      letterSpacing: 2),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: animation.value *
                    (MediaQuery.of(context).size.width * 0.35),
                height: animation.value *
                    (MediaQuery.of(context).size.width * 0.35),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 61, 61, 61),
                      offset: Offset(0.0, 10),
                      blurRadius: 35.0,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 25, 25),
                  child: Image.asset(
                    'assets/icons/Q.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
