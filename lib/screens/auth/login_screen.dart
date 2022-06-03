import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/auth/forgot_password_page.dart';
import 'package:hire_q/screens/auth/signupswitch_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:provider/provider.dart';

import 'widgets/header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  // app state
  AppState appState;
  final double _headerHeight = 250;
  // loaidng status
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init func
  void onInit() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    setState(() {
      isLoading = false;
    });
    appState = Provider.of<AppState>(context, listen: false);
  }

  void onLogin() async {
    final bool _isValid = _formKey.currentState.validate();
    if (_isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        Map payload = {
          'email': _emailController.text,
          'password': _passwordController.text
        };
        var res = await appState.post(
            Uri.parse(appState.endpoint + "/users/login"), jsonEncode(payload));
        setState(() {
          isLoading = false;
        });
        if (res.statusCode == 200) {
          var body = jsonDecode(res.body);
          appState.user = body;
          appState.setLocalStorage(key: 'user', value: jsonEncode(body));
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const LobbyScreen(indexTab: 3),
                );
              },
            ),
          );
        } else {
          var body = jsonDecode(res.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(body['error']),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Unknown Error is occured."),
        ));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.person),
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'User Email', 'Enter your Email'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Enter the Email";
                                    }
                                    // Check if the entered email has the right format
                                    if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value)) {
                                      return "Not Valid Email.";
                                    }
                                    // Return null if the entered email is valid
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              const SizedBox(height: 50.0),
                              Container(
                                child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please enter the password";
                                      }
                                      if (value.trim().length < 8) {
                                        return "Password must be at least 8 charactors.";
                                      }
                                      // Return null if the entered password is valid
                                      return null;
                                    }),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: const ForgotPasswordPage(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: (isLoading)
                                          ? const CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.transparent,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xff283488)),
                                              strokeWidth: 2,
                                            )
                                          : Text(
                                              'Sign In'.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                    ),
                                    onPressed: isLoading ? null : onLogin),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'signup',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 800),
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child:
                                                    const SignupSwitchScreen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: secondaryColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
