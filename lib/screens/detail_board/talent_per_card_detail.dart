import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';

import 'package:hire_q/widgets/common_widget.dart';

// import lobby page
import 'package:hire_q/screens/lobby/lobby_screen.dart';

class TalentPerCardDetail extends StatelessWidget {
  TalentPerCardDetail({Key key, this.data}) : super(key: key);

  final TalentModel data;
  // bottom navbar
  int currentPage = 3;

  // void _minimizeDetail(BuildContext context) {
  //   final newRoute = PageRouteBuilder(
  //     transitionDuration: const Duration(milliseconds: 1000),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: const Text("data"),
  //       );
  //     },
  //   );
  //   Navigator.pushAndRemoveUntil(context, newRoute, ModalRoute.withName(''));
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resizeNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!resizeNotifier.value) resizeNotifier.value = true;
    });
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
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
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: resizeNotifier,
              builder: (context, dynamic value, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  bottom: value ? 20 : -size.height * .3,
                  left: 0,
                  right: 0,
                  child: child,
                );
              },
              child: SizedBox(
                height: size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * .32),
                    Center(
                      child: HireQLogo(
                        fontSize: size.height * .065,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: RawMaterialButton(
                              onPressed: () {
                                resizeNotifier.value = false;
                                Navigator.pop(context);
                              },
                              elevation: 1.0,
                              fillColor: Colors.white,
                              child: const Icon(
                                CupertinoIcons.minus,
                                size: 30.0,
                                color: primaryColor,
                              ),
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 10),
                                      child: Text(
                                        data.firstName + " " + data.lastName,
                                        style: const TextStyle(
                                            fontSize: 28, color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
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
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                data.description +
                                                    data.description +
                                                    data.description,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                margin: const EdgeInsets.only(bottom: 0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.zero,
                                    //   child: ImageButton(
                                    //       onPressed: () {},
                                    //       imageHeight: 40,
                                    //       image: "assets/icons/q white.png"),
                                    // ),
                                    // Center(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       // _openPage(context, const TalentDetail());
                                    //     },
                                    //     icon: const Icon(
                                    //         CupertinoIcons.multiply_circle),
                                    //     color: Colors.red,
                                    //     iconSize: 30,
                                    //   ),
                                    // ),
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
