import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/company_job_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:hire_q/widgets/theme_helper.dart';
import 'package:provider/provider.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:csc_picker/csc_picker.dart';

class ProfileCompanyAddJobScreen extends StatefulWidget {
  const ProfileCompanyAddJobScreen(
      {Key key, this.editable = false, this.selectedJob})
      : super(key: key);
  final bool editable;
  final CompanyJobModel selectedJob;
  @override
  State<StatefulWidget> createState() {
    return _ProfileCompanyAddJobScreenState();
  }
}

class _ProfileCompanyAddJobScreenState
    extends State<ProfileCompanyAddJobScreen> {
  // app state import
  AppState appState;

  // API Client service setting
  APIClient api;
  // slide setting
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // from setting
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  // textediting controller set
  TextEditingController jobTitleController;
  TextEditingController yearsOfExperienceController;
  TextEditingController salaryController;
  TextEditingController departmentController;
  TextEditingController descriptionController;

  // Roles & Responsibilities list string
  List<String> roles = [];
  // Roles Adding input textcontroller
  TextEditingController rolesController;
  // address values setting
  final GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
  String countryValue = "United States";
  String stateValue = "";
  String cityValue = "";

  // isloading setting true or false when processing with rest api
  bool isLoading;

  // validation flag setting
  bool isValid = false;
  bool isValid1 = false;

  // education dropdown setting
  final List<String> educationItems = [
    'B.S',
    'B.A',
  ];
  // select education value
  String selectedEducationValue;

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
    jobTitleController = TextEditingController();
    yearsOfExperienceController = TextEditingController();
    salaryController = TextEditingController();
    departmentController = TextEditingController();
    rolesController = TextEditingController();
    descriptionController = TextEditingController();
    // api instance
    api = APIClient();
    // init value if editable is true
    if (widget.editable) {
      Map _region = jsonDecode((widget.selectedJob).region);
      List _roles = (widget.selectedJob).roles;
      jobTitleController.text = (widget.selectedJob).title;
      yearsOfExperienceController.text = (widget.selectedJob).experience_year;
      salaryController.text = (widget.selectedJob).salary;
      departmentController.text = (widget.selectedJob).department;
      descriptionController.text = (widget.selectedJob).description;
      countryValue = _region['country'];
      stateValue = _region['state'];
      cityValue = _region['city'];
      selectedEducationValue = (widget.selectedJob).education;

      roles.addAll(_roles.map((e) => e.toString()).toList());
    }
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
    super.dispose();
  }

  bool _onValidationRegion() {
    if (countryValue.isNotEmpty && stateValue.isNotEmpty && roles.isNotEmpty) {
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
      if (isValid1 == true) {
        _formKey1.currentState?.save();
        // print(1);
        if (_onValidationRegion()) {
          setState(() {
            isLoading = true;
          });
          if (widget.editable) {
            Map payloads = {
              "company_id": (appState.company).id,
              "department": departmentController.text,
              "education": selectedEducationValue,
              "experience_year": yearsOfExperienceController.text,
              "region": {
                "country": countryValue,
                "city": cityValue,
                "state": stateValue
              },
              "salary": salaryController.text,
              "title": jobTitleController.text,
              "description": descriptionController.text,
              "roles": roles,
            };
            //  setState(() {
            //   isLoading = false;
            // });
            print(payloads);
            try {
              var res = await api.updateCompanyJob(
                  id : (widget.selectedJob).id,
                  token: appState.user['jwt_token'],
                  payloads: jsonEncode(payloads));
              setState(() {
                isLoading = false;
              });
              var body = jsonDecode(res.body);
              if (res.statusCode == 200) {
                if (body['status'] == "success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Successfully Updated with Job."),
                    ),
                  );
                  Provider.of<JobsProvider>(context, listen: false)
                      .updateCuurentCompanyJob(CompanyJobModel.fromJson(body));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text("Something went wrong, Please try again it."),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(body['error'].toString()),
                ));
              }
            } catch (e) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Unknown error is occured."),
              ));
            }
          } else {
            Map payloads = {
              "company_id": (appState.company).id,
              "department": departmentController.text,
              "education": selectedEducationValue,
              "experience_year": yearsOfExperienceController.text,
              "region": {
                "country": countryValue,
                "city": cityValue,
                "state": stateValue
              },
              "salary": salaryController.text,
              "title": jobTitleController.text,
              "description": descriptionController.text,
              "roles": roles,
            };
            //  setState(() {
            //   isLoading = false;
            // });
            try {
              var res = await api.addCompanyJob(
                  token: appState.user['jwt_token'],
                  payloads: jsonEncode(payloads));
              setState(() {
                isLoading = false;
              });
              var body = jsonDecode(res.body);
              if (res.statusCode == 200) {
                if (body['status'] == "success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Successfully Added with Job."),
                    ),
                  );

                  Provider.of<JobsProvider>(context, listen: false)
                      .addCurrentCompanyJob(CompanyJobModel.fromJson(body));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text("Something went wrong, Please try again it."),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(body['error'].toString()),
                ));
              }
            } catch (e) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Unknown error is occured."),
              ));
            }
          }
        } else {
          if (roles.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orange,
              content: Text("Please Enter the Roles & Responsibilities."),
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
                                      controller: jobTitleController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration('Job Title',
                                              'Enter Job title here.'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Please enter the job title.";
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
                                      controller: yearsOfExperienceController,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Years of Experience',
                                          'Enter Years of experience of required.'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Please enter the years of experience.";
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
                                const SizedBox(
                                  height: 30,
                                ),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(1, 10),
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonFormField2(
                                    decoration: InputDecoration(
                                      //Add isDense true and zero Padding.
                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      //Add more decoration as you want here
                                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                    ),
                                    isExpanded: true,
                                    hint: const Text(
                                      'Minimun Education required',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                    buttonHeight: 50,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 20,
                                          offset: const Offset(0, 5),
                                        )
                                      ],
                                    ),
                                    items: educationItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select Education Level.';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      //Do something when changing the item if you want.
                                      selectedEducationValue = value.toString();
                                    },
                                    onSaved: (value) {
                                      selectedEducationValue = value.toString();
                                    },
                                    value: selectedEducationValue,
                                  ),
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
                                    controller: salaryController,
                                    decoration: ThemeHelper()
                                        .textInputDecoration('Salary',
                                            'Enter Salary (optional)'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: TextFormField(
                                      controller: departmentController,
                                      decoration: ThemeHelper()
                                          .textInputDecoration('Department',
                                              'Enter Department.'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Please enter Department.";
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
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextFormField(
                                          controller: rolesController,
                                          decoration: ThemeHelper()
                                              .textInputDecoration(
                                                  'Roles & Responsibilities',
                                                  'Enter Roles & Responsibilities.'),
                                        ),
                                        decoration: ThemeHelper()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.white,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              50,
                                            ),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: const Offset(1, 3),
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: Material(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            child: InkWell(
                                              splashColor: Colors.white,
                                              onTap: () {
                                                setState(() {
                                                  if (rolesController
                                                      .text.isNotEmpty) {
                                                    // roles.insert(index, 'Planet');
                                                    roles.add(
                                                        rolesController.text);
                                                    rolesController.clear();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      backgroundColor:
                                                          Colors.orange,
                                                      content:
                                                          Text("Text is empty"),
                                                    ));
                                                  }
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const <Widget>[
                                                  Icon(
                                                    Icons.add_card,
                                                    color: primaryColor,
                                                  ), // <-- Icon
                                                  Text("Add"), // <-- Text
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // Text(roles.isNotEmpty ? roles.toString() : ""),
                                Column(
                                  children: roles.map((item) {
                                    final index = roles.indexWhere(
                                        (element) => element == item);
                                    return GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          roles.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 3,
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                10,
                                              ),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(1, 3),
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 20,
                                              ),
                                            ]),
                                        child: Text(item),
                                      ),
                                    );
                                  }).toList(),
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
                                    : widget.editable
                                        ? "Save"
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
    );
  }
}
