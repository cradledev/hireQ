import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/auth/signupswitch_screen.dart';
//custome widget
import 'package:hire_q/widgets/common_widget.dart';

import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: _appbarTitle(context),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "What are you looking for?",
                      style: TextStyle(fontSize: 24, color: primaryColor),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: ImageTextButton(
                            image: "assets/icons/Jobs.png",
                            text: "Job Search",
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/lobby',
                                  arguments: ScreenArguments(tabIndex: 0));
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: secondaryColor.withOpacity(0.5),
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "or",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: primaryColor,
                                      ),
                                    )),
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: secondaryColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: ImageTextButton(
                            image: "assets/icons/Jobs.png",
                            text: "Talent Search",
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/lobby',
                                  arguments: ScreenArguments(tabIndex: 1));
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 100.0, left: 10, right: 10),
                    child: Column(
                      children: [
                        OutlineButtonCustom(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 800),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: const LoginScreen(),
                                  );
                                },
                              ),
                            );
                          },
                          text: "Login",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButtonCustom(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 800),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: const SignupSwitchScreen(),
                                  );
                                },
                              ),
                            );
                          },
                          text: "Sign up",
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarTitle(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
        child: Image.asset(
          'assets/icons/Q.png',
          // height: height * 0.1,
          width: 50,
          color: secondaryColor,
        ));
  }
}

class ScreenArguments {
  final int tabIndex;
  final String tabString;

  ScreenArguments({this.tabIndex, this.tabString});
}
