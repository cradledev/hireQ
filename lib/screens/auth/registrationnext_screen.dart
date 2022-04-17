import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'widgets/header_widget.dart';

class RegisterNextScreen extends StatefulWidget {
  const RegisterNextScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterNextScreenState();
  }
}

class _RegisterNextScreenState extends State<RegisterNextScreen> {
  // slide setting
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  void _onNextPage() {
    if (_currentPage != _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      print("last screen");
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(microseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: const LobbyScreen(indexTab: 1),
              );
            },
          ),
          (route) => false);
      // if (_appState.user == null) {
      //   Navigator.pushNamed(context, '/auth');
      // } else {
      //   Navigator.pushReplacementNamed(context, '/home');
      // }
    }
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 35.0 : 8.0,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: 250,
              child: const HeaderWidget(
                  250, false, Icons.person_add_alt_1_rounded),
            ),
            const Text(
              'Sign up',
              style: TextStyle(
                  fontSize: 40,
                  color: primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: PageView(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration('First Name',
                                            'Enter your first name'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration('Last Name',
                                            'Enter your last name'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'County', 'Enter your County'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'City', 'Enter your City'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration("Mobile Number",
                                            "Enter your mobile number"),
                                    keyboardType: TextInputType.phone,
                                    validator: (val) {
                                      if (val.isNotEmpty &&
                                          !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                                key: _formKey1,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        decoration: ThemeHelper()
                                            .textInputDecoration(
                                                'Current Job Title',
                                                'Enter your Job Title'),
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      child: TextFormField(
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Company',
                                                'Enter your Company'),
                                      ),
                                      decoration: ThemeHelper()
                                          .inputBoxDecorationShaddow(),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildPageIndicator(),
                  ),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          (_currentPage != _numPages - 1) ? "Next" : "Finish",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _onNextPage();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
