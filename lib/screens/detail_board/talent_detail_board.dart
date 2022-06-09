import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';

class TalentDetailBoard extends StatefulWidget {
  const TalentDetailBoard({Key key, this.data}) : super(key: key);
  final TalentModel data;
  @override
  _TalentDetailBoard createState() => _TalentDetailBoard();
}

class _TalentDetailBoard extends State<TalentDetailBoard> {
  int currentPage = 3;
  // search text controller
  TextEditingController _searchTextController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            CupertinoIcons.line_horizontal_3,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          // leadingAction: () {
          // },
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
            currentPage = position;
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 800),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: LobbyScreen(indexTab: currentPage),
                  );
                },
              ),
            );
          },
          initialSelection: currentPage,
          activeIconColor: Colors.white,
          circleColor: primaryColor,
          textColor: primaryColor,
          inactiveIconColor: Colors.grey,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.arrow_left),
                      color: primaryColor,
                      iconSize: 30,
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Talent Detail",
                          style: TextStyle(fontSize: 26, color: primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.66,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: const Text("data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
