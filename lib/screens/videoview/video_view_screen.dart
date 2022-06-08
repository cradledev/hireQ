import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent1_model.dart';
import 'package:hire_q/screens/detail_board/talent_detail_board.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';

class VideoViewScreen extends StatefulWidget {
  const VideoViewScreen({Key key}) : super(key: key);
  @override
  _VideoViewScreen createState() => _VideoViewScreen();
}

class _VideoViewScreen extends State<VideoViewScreen> {
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
                    const Text(
                      "Video Views",
                      style: TextStyle(fontSize: 26, color: primaryColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.forward),
                      color: primaryColor,
                      iconSize: 30,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: TalentDetailBoard(
                                  data: TalentModel1.dumpListData[1],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: CachedNetworkImage(
                                width: 64,
                                height: 64,
                                imageUrl:
                                    "https://images.unsplash.com/photo-1569124589354-615739ae007b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) {
                                  return Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 68,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: accentColor),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        "Beca Lway",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        "@Beca_Lway",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // child: const ListTile(
                                //   title: Text(
                                //     "Jeddah",
                                //     style: TextStyle(
                                //       color: primaryColor,
                                //     ),
                                //   ),
                                //   subtitle: Text(
                                //     "Project Manager",
                                //     style: TextStyle(fontSize: 16),
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 30,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
