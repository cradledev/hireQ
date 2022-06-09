import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_addvideo_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

import 'package:hire_q/widgets/image_gradient_overlay.dart';

class TalentCard extends StatefulWidget {
  const TalentCard({Key key, this.talentData}) : super(key: key);
  final TalentModel talentData;

  @override
  _TalentCardState createState() => _TalentCardState();
}

class _TalentCardState extends State<TalentCard> with TickerProviderStateMixin {
  // animation controller
  AnimationController _controller;

  // is deatil ?
  bool isDetail = false;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init function
  void onInit() {
    if (mounted) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
    }
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
            imageUrl: widget.talentData == null ? 
                'https://via.placeholder.com/150' : widget.talentData.talent_logo.isEmpty ? 'https://via.placeholder.com/150' : 
                Provider.of<AppState>(context, listen: false).hostAddress +
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
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Center(
                    child: IconButton(
                      key: UniqueKey(),
                      onPressed: () {
                        // _openPage(context, const TalentDetail());
                      },
                      icon: const Icon(CupertinoIcons.multiply_circle),
                      color: Colors.red,
                      iconSize: 40,
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                if (widget.talentData.video_id != null) {
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
                  print("object");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "This talent has no video right now.",
                      textAlign: TextAlign.center,
                    ),
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
            imageUrl: widget.talentData == null ? 
                'https://via.placeholder.com/150' : widget.talentData.talent_logo.isEmpty ? 'https://via.placeholder.com/150' : 
                Provider.of<AppState>(context, listen: false).hostAddress +
                    widget.talentData.talent_logo,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                  color : Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    widget.talentData.current_jobDescription.isNotEmpty
                                        ? widget.talentData.current_jobDescription
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
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: const Icon(CupertinoIcons.multiply_circle),
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

  @override
  Widget build(BuildContext context) {
    return isDetail
        ? ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 0.8, curve: Curves.linear),
            ),
            child: widgetTalentDetailInfo(context))
        : widgetTalentShortInfo(context);
  }
}
