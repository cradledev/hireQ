import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/screens/auth/registrationcompany_screen.dart';
import 'package:hire_q/screens/auth/registrationnext_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'widgets/header_widget.dart';

import 'package:provider/provider.dart';

import 'package:hire_q/provider/index.dart';

class EmailValidationScreen extends StatefulWidget {
  const EmailValidationScreen({Key key, this.email, this.password, this.type})
      : super(key: key);
  final String email;
  final String password;
  final String type;

  @override
  _EmailValidationScreenState createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  // verification text controller
  OtpFieldController verificationContoller;
  // if entering verificaiton is completed or not
  bool _pinSuccess = false;

  // isLoading ? true : false when verifying
  bool isLoading = false;
  // verification pin code
  String pinCode;
  // app state setting
  AppState appState;

  @override
  void initState() {
    super.initState();
    _init();
    verificationContoller = OtpFieldController();
    setState(() {
      pinCode = "";
      isLoading = false;
    });
  }

  void _init() async {
    appState = Provider.of<AppState>(context, listen: false);
  }

  void _onVerify(BuildContext context) async {
    try {
      var payload = {
        'email': widget.email,
        'verify_code': pinCode,
        'password': widget.password,
        'type': widget.type
      };
      setState(() {
        isLoading = true;
      });
      var res = await appState.post(
          Uri.parse(appState.endpoint + "/users/verify"), jsonEncode(payload));
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        if (body['status'] == "success") {
          appState.user = body;
          appState.setLocalStorage(key: 'user', value: jsonEncode(body));
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: "",
              id: credential.user.uid,
              imageUrl: '',
              lastName: "",
            ),
          );
          setState(() {
            isLoading = false;
          });
          if (appState.entryType == "talent") {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: RegisterNextScreen(useruid: credential.user.uid),
                    );
                  },
                ));
          } else {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child:
                          RegisterCompanyScreen(useruid: credential.user.uid),
                    );
                  },
                ));
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        var body = jsonDecode(res.body);
        appState.notifyToastDanger(context: context, message: body['error']);
      }
    } catch (e) {
      appState.notifyToastDanger(
          context: context, message: "Unknown error is occured.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void onResendVerificationCode() async {
    try {
      var payload = {
        'email': widget.email,
        'password': widget.password,
        'type': widget.type
      };
      var res = await appState.post(
          Uri.parse(appState.endpoint + "/users/resend"), jsonEncode(payload));
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['status'] == "success") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemeHelper().alartDialog("Successful",
                  "Verification code resend successful.", context);
            },
          );
        }
      } else {
        // var body = jsonDecode(res.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ThemeHelper().alartDialog(
                "Error", "Failed resending verification.", context);
          },
        );
      }
    } catch (e) {
      appState.notifyToastDanger(
          context: context, message: "Unknown error is occured.");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: _headerHeight,
              child:
                  HeaderWidget(_headerHeight, true, Icons.privacy_tip_outlined),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Verification',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            // textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Enter the verification code we just sent you on your email address.',
                            style: TextStyle(
                                // fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            // textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          OTPTextField(
                            controller: verificationContoller,
                            length: 4,
                            width: 300,
                            fieldWidth: 50,
                            style: const TextStyle(fontSize: 30),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              setState(() {
                                _pinSuccess = true;
                                pinCode = pin;
                              });
                            },
                          ),
                          const SizedBox(height: 50.0),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "If you didn't receive a code! ",
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Resend',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      onResendVerificationCode();
                                    },
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Container(
                            decoration: _pinSuccess
                                ? ThemeHelper().buttonBoxDecoration(context)
                                : ThemeHelper().buttonBoxDecoration(
                                    context, "#AAAAAA", "#757575"),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xff283488)),
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        "Verify".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              onPressed: _pinSuccess
                                  ? () {
                                      _onVerify(context);
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
