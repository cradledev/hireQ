import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/company_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class SettingCompanyScreen extends StatefulWidget {
  const SettingCompanyScreen({Key key}) : super(key: key);
  @override
  _SettingCompanyScreen createState() => _SettingCompanyScreen();
}

class _SettingCompanyScreen extends State<SettingCompanyScreen> {
  // app state setting
  AppState appState;
  // address values setting
  final GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  // phone number setting
  String phoneNumber = "";
  String initialCountryCode = "SA";
  String displayPhoneNumber = "";

  // slide setting
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // validation flag setting
  bool isValid = false;
  bool isValid1 = false;
  // isloading when processing with rest api.
  bool isLoading = false;

  // sign up form setting
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  // final _formKey1 = GlobalKey<FormState>();

  // textediting controller for company name, company account manager name
  TextEditingController companyNameController;
  TextEditingController accountManageerNameController;
  TextEditingController descriptionController;
  // api service setting
  APIClient api;

  // firebase auth user uid
  String currentFirebaseUserUid;

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
    appState = Provider.of<AppState>(context, listen: false);
    api = APIClient();
    companyNameController = TextEditingController();
    accountManageerNameController = TextEditingController();
    descriptionController = TextEditingController();
    onInit();
  }

  void onInit() async {
    if (appState.company != null) {
      // phone number init
      var _phoneDict = jsonDecode((appState.company).phone_number);
      initialCountryCode = _phoneDict['initialCountryCode'];
      displayPhoneNumber = _phoneDict['displayPhoneNumber'];
      phoneNumber = _phoneDict['phoneNumber'];
      // region init
      var _regionDict = jsonDecode((appState.company).region);
      countryValue = _regionDict['country'];
      stateValue = _regionDict['state'];
      cityValue = _regionDict['city'];
      // company name and manager name
      companyNameController.text = (appState.company).name;
      descriptionController.text = appState.company.description;
      accountManageerNameController.text =
          (appState.company).account_manager_name;
    }
    String _tmpFirebaseUser = await appState.getLocalStorage('firebaseuser');
    currentFirebaseUserUid =
        _tmpFirebaseUser.isNotEmpty ? _tmpFirebaseUser : null;
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

  bool _onValidationRegion() {
    if (countryValue.isNotEmpty) {
      return true;
    } else {
      return false;
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
  void dispose() {
    companyNameController.dispose();
    accountManageerNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onSave() async {
    _checkValidation();
    if (_currentPage != _numPages - 1) {
      if (isValid == true) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    } else {
      if (isValid1 == true) {
        _formKey.currentState?.save();
        if (_onValidationRegion()) {
          setState(() {
            isLoading = true;
          });
          Map payloads = {
            'user_id': appState.user['id'],
            'account_manager_name': accountManageerNameController.text,
            'name': companyNameController.text,
            'description': descriptionController.text.isEmpty ? "" : descriptionController.text,
            "phone_number": {
              "phoneNumber": phoneNumber,
              "initialCountryCode": initialCountryCode,
              "displayPhoneNumber": displayPhoneNumber
            },
            "uuid": currentFirebaseUserUid,
            "region": {
              "country": countryValue,
              "city": cityValue ?? "no city",
              "state": stateValue
            },
          };
          try {
            var res;
            if (appState.company != null) {
              res = await api.updateCompany(
                  companyId: (appState.company).id,
                  token: appState.user['jwt_token'],
                  payloads: jsonEncode(payloads));
            } else {
              res = await api.createCompanyInfo(
                  token: appState.user['jwt_token'],
                  payloads: jsonEncode(payloads));
            }

            if (res.statusCode == 200) {
              var result = jsonDecode(res.body);
              // String _tmpAvatorUrl = "";
              // if (appState.profile != null) {
              //   if (appState.profile.avator != null) {
              //     _tmpAvatorUrl = appState.profile.avator;
              //   }
              // }
              await FirebaseChatCore.instance.createUserInFirestore(
                types.User(
                  firstName: companyNameController.text,
                  id: currentFirebaseUserUid,
                  imageUrl: "",
                  lastName: '',
                ),
              );
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Successfully saved."),
              ));
              appState.company = CompanyModel.fromJson(result);
              Navigator.of(context).pop();
            }
            setState(() {
              isLoading = false;
            });
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(e.toString()),
            ));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIcon: const Icon(
            CupertinoIcons.arrow_left,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          leadingAction: () {
            Navigator.of(context).pop();
          },
          leadingFlag: true,
          actionEvent: () {},
          actionFlag: true,
          actionIcon: const Icon(
            CupertinoIcons.bell_fill,
            size: 30,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Image.asset(
              'assets/icons/Q.png',
              // height: height * 0.1,
              width: 50,
              color: secondaryColor,
            ),
          ),
        ),
        drawer: const CustomDrawerWidget(),
        body: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.grey.shade200,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  appState.profile == null
                                      ? "https://via.placeholder.com/150"
                                      : ((appState.profile).avator == null ||
                                              (appState.profile).avator == "")
                                          ? "https://via.placeholder.com/150"
                                          : appState.hostAddress +
                                              (appState.profile).avator,
                                ),
                              ),
                            ),
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
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    child: TextFormField(
                                        controller:
                                            accountManageerNameController,
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
                                        controller: descriptionController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: ThemeHelper()
                                            .textInputDecoration('Description',
                                                'Enter Description.'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Please enter Description.";
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
                                onSave();
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
