import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:provider/provider.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'widgets/header_widget.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterCompanyScreenState();
  }
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  // app state provider
  AppState appState;
  // isloading when processing with rest api.
  bool isLoading = false;
  // slide setting
  final int _numPages = 1;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // address values setting
  final GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  // phone number setting
  String phoneNumber = "";
  String initialCountryCode = "SA";
  String displayPhoneNumber = "";

  // validation flag setting
  bool isValid = false;

  // sign up form setting
  final _formKey = GlobalKey<FormState>();
  // final _formKey1 = GlobalKey<FormState>();

  // textediting controller for company name, company account manager name
  TextEditingController companyNameController;
  TextEditingController accountManageerNameController;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  void _onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      isLoading = false;
    });
    companyNameController = TextEditingController();
    accountManageerNameController = TextEditingController();
  }

  void _checkValidation() {
    isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      _formKey.currentState?.save();
    }
  }

  bool _onValidationRegion() {
    if (countryValue.isNotEmpty &&
        stateValue.isNotEmpty &&
        cityValue.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  void _onNextPage() async {
    _checkValidation();
    if (_currentPage != _numPages - 1) {
      if (isValid == true) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    } else {
      if (isValid == true) {
        _formKey.currentState?.save();
        // print(1);
        if (_onValidationRegion()) {
          setState(() {
            isLoading = true;
          });
          try {
            Map payloads = {
              'user_id': appState.user['id'],
              'account_manager_name': accountManageerNameController.text,
              'name': companyNameController.text,
              "phone_number": phoneNumber,
              "region": {
                "country": countryValue,
                "city": cityValue,
                "state": stateValue
              },
            };

            
            var res = await appState.postWithToken(
                Uri.parse(appState.endpoint + "companies/"),
                jsonEncode(payloads));
            setState(() {
              isLoading = false;
            });
            var body = jsonDecode(res.body);
            if (res.statusCode == 200) {
              if (body['status'] == "success") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ThemeHelper()
                        .alartDialog("Success", "Success.", context);
                  },
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(microseconds: 800),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: const LobbyScreen(indexTab: 3),
                        );
                      },
                    ),
                    (route) => false);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ThemeHelper().alartDialog("warning",
                        "Something went wrong, Please try again it.", context);
                  },
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ThemeHelper()
                      .alartDialog("Error", body['error'], context);
                },
              );
            }
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThemeHelper()
                    .alartDialog("Error", "Unknown error is occured.", context);
              },
            );
          }
        }
      }
      // print("last screen");
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     PageRouteBuilder(
      //       transitionDuration: const Duration(microseconds: 800),
      //       pageBuilder: (context, animation, secondaryAnimation) {
      //         return FadeTransition(
      //           opacity: animation,
      //           child: const LobbyScreen(indexTab: 0),
      //         );
      //       },
      //     ),
      //     (route) => false);
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
              height: 200,
              child: const HeaderWidget(
                  200, false, Icons.person_add_alt_1_rounded),
            ),
            const Text(
              'Sign up As a Company',
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
                                      controller: companyNameController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration('Company Name',
                                              'Enter your Company name'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Please enter Company Name";
                                        }
                                        // Return null if the entered password is valid
                                        return null;
                                      }),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                      controller: accountManageerNameController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration(
                                              'Account Manager Name',
                                              'Enter your Account Manager name'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Please enter Account Manager name";
                                        }
                                        // Return null if the entered password is valid
                                        return null;
                                      }),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Column(
                                  children: [
                                    CSCPicker(
                                      key: _cscPickerKey,
                                      layout: Layout.vertical,

                                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                      showStates: true,

                                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                                      showCities: true,

                                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                      flagState: CountryFlag.DISABLE,

                                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                      dropdownDecoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              blurRadius: 20,
                                              offset: const Offset(0, 5),
                                            )
                                          ],
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1)),

                                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                      disabledDropdownDecoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey.shade300,
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1),
                                      ),

                                      ///placeholders for dropdown search field
                                      countrySearchPlaceholder: "Country",
                                      stateSearchPlaceholder: "State",
                                      citySearchPlaceholder: "City",

                                      ///labels for dropdown
                                      countryDropdownLabel: "*Country",
                                      stateDropdownLabel: "*State",
                                      cityDropdownLabel: "*City",

                                      ///Default Country
                                      //defaultCountry: DefaultCountry.India,

                                      ///Disable country dropdown (Note: use it with default country)
                                      //disableCountry: true,

                                      ///selected item style [OPTIONAL PARAMETER]
                                      selectedItemStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),

                                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                      dropdownHeadingStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),

                                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                      dropdownItemStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),

                                      ///Dialog box radius [OPTIONAL PARAMETER]
                                      dropdownDialogRadius: 10.0,

                                      ///Search bar radius [OPTIONAL PARAMETER]
                                      searchBarRadius: 10.0,

                                      ///triggers once country selected in dropdown
                                      onCountryChanged: (value) {
                                        setState(() {
                                          ///store value in country variable
                                          countryValue = value;
                                        });
                                      },

                                      ///triggers once state selected in dropdown
                                      onStateChanged: (value) {
                                        setState(() {
                                          ///store value in state variable
                                          stateValue = value;
                                        });
                                      },

                                      ///triggers once city selected in dropdown
                                      onCityChanged: (value) {
                                        setState(() {
                                          ///store value in city variable
                                          cityValue = value;
                                        });
                                      },
                                      currentCountry: countryValue,
                                      currentCity: cityValue,
                                      currentState: stateValue,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  child: IntlPhoneField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration('Phone Number',
                                            'Enter your phone number.'),
                                    onChanged: (phone) {
                                      // print(phone.number);
                                      // print(phone.completeNumber);
                                      setState(() {
                                        phoneNumber = phone.completeNumber;
                                        displayPhoneNumber = phone.number;
                                      });
                                    },
                                    initialValue: displayPhoneNumber,
                                    initialCountryCode: initialCountryCode,
                                    onCountryChanged: (country) {
                                      setState(() {
                                        initialCountryCode = country.code;
                                      });
                                      // print(country.code);
                                      // print('Country changed to: ' +
                                      //     country.name);
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        child: isLoading ?? false
                            ? const CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff283488)),
                                strokeWidth: 2,
                              )
                            : Text(
                                (_currentPage != _numPages - 1)
                                    ? "Next"
                                    : "Finish",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      onPressed: isLoading ?? false ? null : _onNextPage,
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
