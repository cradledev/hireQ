import 'dart:convert';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/video_view_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_addvideo_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/image_gradient_overlay.dart';
import 'package:provider/provider.dart';

class TalentDetailScreen extends StatefulWidget {
  const TalentDetailScreen({Key key, this.talentData}) : super(key: key);
  final VideoViewModel talentData;
  @override
  _TalentDetailScreenState createState() => _TalentDetailScreenState();
}

class _TalentDetailScreenState extends State<TalentDetailScreen>
    with TickerProviderStateMixin {
  int currentPage = 3;
  // animation controller
  AnimationController _controller;

  // app state import
  AppState appState;

  // API setting
  APIClient api;

  // is deatil ?
  bool isDetail = false;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init function
  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    api = APIClient();
    if (mounted) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
    }
    print(widget.talentData.region);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // display job short info
  Widget widgetTalentShortInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageGradientOverlay(
            imageUrl: widget.talentData == null
                ? 'https://via.placeholder.com/150'
                : widget.talentData.talent_logo.isEmpty
                    ? 'https://via.placeholder.com/150'
                    : Provider.of<AppState>(context, listen: false)
                            .hostAddress +
                        widget.talentData.talent_logo,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HireQLogo(
                        fontSize: size.height * .065,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.talentData.first_name +
                                      " " +
                                      widget.talentData.last_name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.location_solid,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        jsonDecode(widget.talentData.region)[
                                                'city'] ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _openDetail();
                                },
                                elevation: 1.0,
                                fillColor: Colors.white,
                                child: const Icon(
                                  Icons.add,
                                  size: 30.0,
                                  color: primaryColor,
                                ),
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                if (appState.user != null) {
                  if (widget.talentData.video_id != null) {
                    _trackVideoHistory();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "This talent has no video right now.",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "You must login to view video. Please try it now.",
                        textAlign: TextAlign.left),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset('assets/icons/Play.png',
                    width: 110.0, height: 110.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetTalentDetailInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageGradientOverlay(
            imageUrl: widget.talentData == null
                ? 'https://via.placeholder.com/150'
                : widget.talentData.talent_logo.isEmpty
                    ? 'https://via.placeholder.com/150'
                    : Provider.of<AppState>(context, listen: false)
                            .hostAddress +
                        widget.talentData.talent_logo,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              border: Border.all(width: 5, color: Colors.white),
              color: Colors.transparent,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HireQLogo(
                        fontSize: size.height * .065,
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.talentData.first_name +
                                        " " +
                                        widget.talentData.last_name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location_solid,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          jsonDecode(widget.talentData.region)[
                                                  'city'] ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    _openPage();
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
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    widget.talentData.current_jobDescription
                                            .isNotEmpty
                                        ? widget
                                            .talentData.current_jobDescription
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      height: 1.5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // open job detail board

  void _openPage() {
    setState(() {
      isDetail = false;
    });
    _controller.reverse();
  }

  // open detail
  void _openDetail() {
    setState(() {
      isDetail = true;
    });
    _controller.forward();
  }

  // trach Video History
  void _trackVideoHistory() async {
    Map payloads = {
      'who': appState.user['id'],
      'which': widget.talentData.user_id,
    };
    try {
      var res = await api.createVideoHistory(
          token: appState.user['jwt_token'], payloads: jsonEncode(payloads));

      if (res.statusCode == 200) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(microseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ProfileTalentAddvideoScreen(
                  isView: true,
                  videoId: widget.talentData?.video_id,
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: isDetail
            ? ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.0, 0.8, curve: Curves.linear),
                ),
                child: widgetTalentDetailInfo(context))
            : widgetTalentShortInfo(context),
      ),
    );
  }
}
