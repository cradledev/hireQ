import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'widgets/header_widget.dart';

class RegisterNextScreen extends StatefulWidget {
  const RegisterNextScreen({Key key, this.useruid}) : super(key: key);
  final String useruid;
  @override
  State<StatefulWidget> createState() {
    return _RegisterNextScreenState();
  }
}

class _RegisterNextScreenState extends State<RegisterNextScreen> {
  // app state import
  AppState appState;
  // slide setting
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // from setting
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  // textediting controller set
  TextEditingController firstnameController;
  TextEditingController lastnameController;
  TextEditingController currentJobTitleController;
  TextEditingController companyController;
  TextEditingController yearsExperienceController;
  TextEditingController educationController;

  // address values setting
  final GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  // phone number setting
  String phoneNumber = "";
  String initialCountryCode = "SA";
  String displayPhoneNumber = "";

  // isloading setting true or false when processing with rest api
  bool isLoading;

  // validation flag setting
  bool isValid = false;
  bool isValid1 = false;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  void _onInit() {
    setState(() {
      isLoading = false;
    });
    appState = Provider.of<AppState>(context, listen: false);
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    currentJobTitleController = TextEditingController();
    companyController = TextEditingController();
    yearsExperienceController = TextEditingController();
    educationController = TextEditingController();
  }

  void _checkValidation() {
    isValid = _formKey.currentState?.validate();
    isValid1 = _formKey1.currentState?.validate();
    if (isValid == true) {
      _formKey.currentState?.save();
    }
    if (isValid1 == true) {
      _formKey1.currentState?.save();
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    currentJobTitleController.dispose();
    companyController.dispose();
    yearsExperienceController.dispose();
    educationController.dispose();
    super.dispose();
  }

  bool _onValidationRegion() {
    if (countryValue.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
      print("last screen");
      if (isValid1 == true) {
        _formKey1.currentState?.save();
        // print(1);
        if (_onValidationRegion()) {
          setState(() {
            isLoading = true;
          });
          try {
            Map payloads = {
              'user_id': appState.user['id'],
              'first_name': firstnameController.text,
              'last_name': lastnameController.text,
              'uuid': widget.useruid,
              "phone_number": {
                "phoneNumber": phoneNumber,
                "initialCountryCode": initialCountryCode,
                "displayPhoneNumber": displayPhoneNumber
              },
              "region": {
                "country": countryValue,
                "city": cityValue ?? "no city",
                "state": stateValue
              },
              "current_jobTitle": currentJobTitleController.text,
              "company": companyController.text,
              "years_experience" : yearsExperienceController.text,
              "education" : educationController.text
            };

            print(payloads);
            var res = await appState.postWithToken(
                Uri.parse(appState.endpoint + "/talents/"),
                jsonEncode(payloads));

            var body = jsonDecode(res.body);
            if (res.statusCode == 200) {
              await FirebaseChatCore.instance.createUserInFirestore(
                types.User(
                  firstName: firstnameController.text,
                  id: widget.useruid,
                  imageUrl: '',
                  lastName: lastnameController.text,
                ),
              );
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Successfully registered."),
                backgroundColor: Colors.red,
              ));
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(body['error']),
                backgroundColor: Colors.red,
              ));
            }
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Unkown error is occured."),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    WidgetsBinding.instance?.focusManager?.primaryFocus
                        ?.unfocus();
                    _checkValidation();
                    if (isValid == false && _currentPage == 0) {
                      // _pageController.jumpTo(0);
                      _pageController.jumpToPage(0);
                    } else {
                      setState(() {
                        _currentPage = page;
                      });
                    }
                  },
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 200,
                            child: const HeaderWidget(
                                200, false, Icons.person_add_alt_1_rounded),
                          ),
                          const Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 40,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
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
                                        controller: firstnameController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('First Name',
                                                'Enter your first name'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter First Name";
                                          }
                                          // Return null if the entered password is valid
                                          return null;
                                        }),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: TextFormField(
                                        controller: lastnameController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Last Name',
                                                'Enter your last name'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter Last Name";
                                          }
                                          // Return null if the entered password is valid
                                          return null;
                                        }),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                blurRadius: 20,
                                                offset: const Offset(0, 5),
                                              )
                                            ],
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1)),

                                        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                        disabledDropdownDecoration:
                                            BoxDecoration(
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height: 200,
                            child: const HeaderWidget(
                                200, false, Icons.person_add_alt_1_rounded),
                          ),
                          const Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 40,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
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
                                        controller: currentJobTitleController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration(
                                                'Current Job Title',
                                                'Enter your Job Title'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter Current Job Title";
                                          }
                                          // Return null if the entered password is valid
                                          return null;
                                        }),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: TextFormField(
                                        controller: companyController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Company',
                                                'Enter your Company'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter Company Name";
                                          }
                                          // Return null if the entered password is valid
                                          return null;
                                        }),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: yearsExperienceController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration(
                                              'Years Of Experience (*optional)',
                                              'Enter years of your experience.'),
                                    ),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: educationController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration(
                                              'Education (*optional)',
                                              'Enter education Level. (i.e. BS or BA, etc)'),
                                    ),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        onPressed: isLoading ?? false
                            ? null
                            : () {
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
      ),
    );
  }
}
