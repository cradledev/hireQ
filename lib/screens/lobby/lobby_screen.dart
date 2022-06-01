import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/message/message_company_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';

import 'package:hire_q/screens/job/job_screen.dart';
import 'package:hire_q/screens/message/message_screen.dart';
import 'package:hire_q/screens/profile/profile_screen.dart';
import 'package:hire_q/screens/profile/profile_company_screen.dart';
import 'package:hire_q/screens/talent/talent_screen.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';

import 'package:provider/provider.dart';

import 'package:hire_q/provider/index.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key key, this.indexTab, this.tabString}) : super(key: key);
  final int indexTab;
  final String tabString;

  @override
  _LobbyScreen createState() => _LobbyScreen();
}

class _LobbyScreen extends State<LobbyScreen> {
  // appstate
  AppState _appState;
  // bottom navbar
  int currentPage = 0;
  // search text controller
  TextEditingController _searchTextController;
  @override
  void initState() {
    super.initState();
    currentPage = widget.indexTab;
    _searchTextController = TextEditingController();
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    if (widget.indexTab == 0 || widget.indexTab == 1) {
      return [
        const JobScreen(),
        const TalentScreen(),
        const MessageScreen(),
        const ProfileScreen()
      ];
    }
    if (_appState.user['type'] == "talent") {
      return [
        const JobScreen(),
        const TalentScreen(),
        const MessageScreen(),
        const ProfileScreen()
      ];
    } else {
      return [
        const JobScreen(),
        const TalentScreen(),
        const MessageCompanyScreen(),
        const ProfileCompanyScreen()
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: CustomAppBar(
        leadingIcon: const Icon(
          CupertinoIcons.line_horizontal_3,
          size: 40,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        leadingAction: () {
        },
        leadingFlag: true,
        actionEvent: () {},
        actionFlag: true,
        actionIcon: const Icon(
          CupertinoIcons.bell_fill,
          size: 30,
          color: Colors.white,
        ),
        title: AppbarSearchFormField(
          obsecureText: false,
          textInputType: TextInputType.text,
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: secondaryColor,
          ),
          maxLines: 1,
          textInputAction: TextInputAction.done,
          suffixIcon: const Icon(
            CupertinoIcons.slider_horizontal_3,
            color: secondaryColor,
          ),
          controller: _searchTextController,
        ),
      ),
      drawer: const CustomDrawerWidget(),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: CupertinoIcons.briefcase_fill, title: "Job"),
          TabData(iconData: CupertinoIcons.person_3_fill, title: "Talent"),
          TabData(
              iconData: CupertinoIcons.chat_bubble_2_fill, title: "Messages"),
          TabData(iconData: CupertinoIcons.person_fill, title: "Profile")
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
        initialSelection: currentPage,
        activeIconColor: Colors.white,
        circleColor: primaryColor,
        textColor: primaryColor,
        inactiveIconColor: Colors.grey,
      ),
      body: _buildScreens()[currentPage],
    );
  }
}
