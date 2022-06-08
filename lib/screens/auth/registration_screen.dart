import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/auth/emailvalidatioin_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:provider/provider.dart';

import 'widgets/header_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // appstate provider
  AppState appState;
  final _formKey = GlobalKey<FormState>();
  // form text controller
  TextEditingController emailController;
  TextEditingController passwordController;

  //checking is loading? not
  bool isLoading;

  // value of accepting all terms and condition
  bool checkboxValue = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    setState(() {
      isLoading = false;
    });
    appState = Provider.of<AppState>(context, listen: false);
  }

  void onNextRegister() async {
    if (_formKey.currentState.validate()) {
      try {
        Map payload = {
          'email': emailController.text,
          'password': passwordController.text,
          'type': appState.entryType
        };
        var res = await appState.post(
            Uri.parse(appState.endpoint + "/users/"), jsonEncode(payload));
        setState(() {
          isLoading = false;
        });
        if (res.statusCode == 200) {
          var body = jsonDecode(res.body);
          if (body['status'] == "success") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                        opacity: animation,
                        child: EmailValidationScreen(
                          email: payload['email'],
                          password: payload['password'],
                          type: payload['type'],
                        ));
                  }),
            );
          }
        } else {
          var body = jsonDecode(res.body);
          appState.notifyToastDanger(context: context, message: body['error']);
        }
      } catch (e) {
        appState.notifyToastDanger(context: context, message: "Unknown error is occured.");
        setState(() {
          isLoading = false;
        });
      }
      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //       transitionDuration: const Duration(milliseconds: 800),
      //       pageBuilder: (context, animation, secondaryAnimation) {
      //         return FadeTransition(
      //             opacity: animation, child: const EmailValidationScreen());
      //       }),
      // );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: 300,
              child: const HeaderWidget(
                  300, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 200, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Enter a email address";
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 40.0),
                        Container(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: (isLoading)
                                    ? const CircularProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xff283488)),
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        "Next".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              onPressed: isLoading ? null : onNextRegister),
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
                          "Or create account using Google Account",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                // setState(() {
                                //   _isSigningIn = true;
                                // });
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 800),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return FadeTransition(
                                            opacity: animation,
                                            child:
                                                const EmailValidationScreen());
                                      },
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                      image: AssetImage(
                                          "assets/images/google_logo.png"),
                                      height: 35.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
