import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/auth/registration_screen.dart';
//custome widget
import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

import 'package:hire_q/provider/index.dart';

class SignupSwitchScreen extends StatefulWidget {
  const SignupSwitchScreen({Key key}) : super(key: key);

  @override
  _SignupSwitchScreen createState() => _SignupSwitchScreen();
}

class _SignupSwitchScreen extends State<SignupSwitchScreen> {
  // app state setting
  AppState _appState;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Sign-up As",
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
                          text: "Individual".toUpperCase(),
                          onPressed: () {
                            _appState.isTalent = true;
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 800),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: const RegistrationScreen(),
                                  );
                                },
                              ),
                            );
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
                          text: "Company".toUpperCase(),
                          onPressed: () {
                            _appState.isTalent = false;
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 800),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: const RegistrationScreen(),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
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
