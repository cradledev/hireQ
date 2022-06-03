import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/company_job_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/video_player/video_player.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

import 'package:hire_q/widgets/image_gradient_overlay.dart';

class JobCard extends StatefulWidget {
  const JobCard({Key key, this.jobData}) : super(key: key);
  final CompanyJobModel jobData;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> with TickerProviderStateMixin {
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
  void dispose () {
    _controller.dispose();
    super.dispose();
  }
  // display job short info
  Widget widgetJobShortInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageGradientOverlay(
            imageUrl:
                Provider.of<AppState>(context, listen: false).hostAddress +
                    widget.jobData.company_logo,
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    widget.jobData.company_name,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  ),
                                  SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: CachedNetworkImage(
                                      imageUrl: Provider.of<AppState>(context,
                                                  listen: false)
                                              .hostAddress +
                                          widget.jobData.company_logo,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.jobData.title,
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
                                          jsonDecode(widget.jobData.region)[
                                                  'city'] ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.jobData.experience_year
                                                    .isNotEmpty
                                                ? widget.jobData
                                                        .experience_year +
                                                    " (years Experience) "
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            widget.jobData.education.isNotEmpty
                                                ? widget.jobData.education +
                                                    " in Engineering"
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            widget.jobData.department ?? "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            widget.jobData.salary.isNotEmpty
                                                ? widget.jobData.salary +
                                                    " (salary)"
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            jsonDecode(widget.jobData.region)[
                                                    'country'] ??
                                                "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
                if (widget.jobData.company_video.isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(microseconds: 800),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: CustomVideoPlayer(
                            sourceUrl:
                                Provider.of<AppState>(context).hostAddress +
                                    widget.jobData.company_video,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("This company has no video right now."),
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

  Widget widgetJobDetailInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Consumer<AppState>(
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Image.asset(
                        value.talentSwipeUp
                            ? 'assets/icons/up.png'
                            : 'assets/icons/down.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 5, color: Colors.white),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
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
                                      widget.jobData.company_name,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28),
                                    ),
                                    SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: CachedNetworkImage(
                                        imageUrl: Provider.of<AppState>(context,
                                                    listen: false)
                                                .hostAddress +
                                            widget.jobData.company_logo,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) {
                                          return Center(
                                            child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.jobData.title,
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
                                          jsonDecode(widget.jobData.region)[
                                                  'city'] ??
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
                                  fillColor: primaryColor,
                                  child: const Icon(
                                    CupertinoIcons.minus,
                                    size: 30.0,
                                    color: Colors.white,
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  widget.jobData.description.isNotEmpty
                                      ? widget.jobData.description
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
              curve: const Interval(0.0, 0.3, curve: Curves.linear),
            ),
            child: widgetJobDetailInfo(context))
        : widgetJobShortInfo(context);
  }
}
