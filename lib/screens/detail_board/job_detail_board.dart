import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/applied_job_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:provider/provider.dart';

class JobDetailBoard extends StatefulWidget {
  const JobDetailBoard({Key key, this.data}) : super(key: key);
  final AppliedJobModel data;
  @override
  _JobDetailBoard createState() => _JobDetailBoard();
}

class _JobDetailBoard extends State<JobDetailBoard> {
  // AppState setting
  AppState appState;
  int currentPage = 3;
  // search text controller
  TextEditingController _searchTextController;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init function
  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        body: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 20,
                        offset: const Offset(1, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              width: size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  HireQLogo(
                                    fontSize: size.height * .065,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.data.company_name,
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        ),
                                        SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                    .data.company_logo.isEmpty
                                                ? 'https://via.placeholder.com/150'
                                                : Provider.of<AppState>(context,
                                                            listen: false)
                                                        .hostAddress +
                                                    widget.data.company_logo,
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                              );
                                            },
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.title,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location_solid,
                                          color: primaryColor,
                                          size: 30.0,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          jsonDecode(
                                                  widget.data.region)['city'] ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      child: Text(
                                        widget.data.description.isNotEmpty
                                            ? widget.data.description
                                            : "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          height: 1.5,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 60,
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   alignment: Alignment.center,
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //         bottomLeft: Radius.circular(10),
                      //         bottomRight: Radius.circular(10)),
                      //     color: primaryColor,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.zero,
                      //         child: ImageButton(
                      //             onPressed: () {},
                      //             imageHeight: 40,
                      //             image: "assets/icons/q white.png"),
                      //       ),
                      //       Center(
                      //         child: IconButton(
                      //           onPressed: () {
                      //             // _openPage(context, const TalentDetail());
                      //           },
                      //           icon:
                      //               const Icon(CupertinoIcons.multiply_circle),
                      //           color: Colors.red,
                      //           iconSize: 30,
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.zero,
                      //         child: ImageButton(
                      //             onPressed: () {},
                      //             imageHeight: 35,
                      //             image: "assets/icons/share.png"),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
