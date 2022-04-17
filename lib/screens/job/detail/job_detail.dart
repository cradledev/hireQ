import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/job_model.dart';

import 'package:hire_q/widgets/common_widget.dart';

// import lobby page
import 'package:hire_q/screens/lobby/lobby_screen.dart';

class JobDetail extends StatelessWidget {
  JobDetail({Key key, this.data}) : super(key: key);

  final JobModel data;
  // bottom navbar
  int currentPage = 0;

  void _minimizeDetail(BuildContext context) {
    final newRoute = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: const Text("data"),
        );
      },
    );
    Navigator.pushAndRemoveUntil(context, newRoute, ModalRoute.withName(''));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resizeNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!resizeNotifier.value) resizeNotifier.value = true;
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: Stack(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: resizeNotifier,
            builder: (context, dynamic value, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                bottom: value ? 0 : -size.height * .3,
                left: 0,
                right: 0,
                child: child,
              );
            },
            child: SizedBox(
              height: size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height * .24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(204, 209, 206, 1),
                            Color.fromRGBO(204, 209, 206, 0.0),
                          ],
                          stops: [1, 0.0],
                        ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.companyName,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 28),
                                ),
                                SizedBox(
                                  width: 64,
                                  child: Hero(
                                    tag: 'company_logo' + data.id.toString(),
                                    child: CachedNetworkImage(
                                      imageUrl: data.logo,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) {
                                        return Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Container(
                        height: size.height * .5,
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              data.title + " " + data.title,
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  color: primaryColor),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: RawMaterialButton(
                                                  onPressed: () {
                                                    resizeNotifier.value =
                                                        false;
                                                    Navigator.pop(context);
                                                  },
                                                  elevation: 1.0,
                                                  fillColor: primaryColor,
                                                  child: const Icon(
                                                    CupertinoIcons.minus,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                data.country,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              data.requirement,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: primaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: ImageButton(
                                        onPressed: () {},
                                        imageHeight: 40,
                                        image: "assets/icons/q white.png"),
                                  ),
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        // _openPage(context, const TalentDetail());
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.multiply_circle),
                                      color: Colors.red,
                                      iconSize: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: ImageButton(
                                        onPressed: () {},
                                        imageHeight: 35,
                                        image: "assets/icons/share.png"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DragDownIndication extends StatelessWidget {
  const _DragDownIndication({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Inicia sesión',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Desliza para ir hacia atras',
          style: TextStyle(
            height: 2,
            fontSize: 14,
            color: Colors.white.withOpacity(.9),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white.withOpacity(.8),
          size: 35,
        ),
      ],
    );
  }
}
