import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_addvideo_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

import 'package:hire_q/widgets/image_gradient_overlay.dart';

class TalentDetailCard extends StatefulWidget {
  const TalentDetailCard({Key key, this.talentData}) : super(key: key);
  final TalentModel talentData;
  @override
  _TalentDetailCardState createState() => _TalentDetailCardState();
}

class _TalentDetailCardState extends State<TalentDetailCard>
    with TickerProviderStateMixin {
  // animation controller
  AnimationController _controller;

  // App state provider setting
  AppState appState;

  // Job provider setting
  JobsProvider jobProvider;
  // API setting
  APIClient api;
  // is deatil ?
  bool isDetail = false;

  // is shortlist flag
  bool isShortlist = false;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init function
  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    api = APIClient();
    if (mounted) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
    }
    setState(() {
      isShortlist = widget.talentData.is_shortlist;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // remove talent from shortlist
  void onRemoveTalentFromShortlist() async {
    try {
      Map _payloads = {"shortlist_status": false};
      var res = await api.updateShortlistStatus(
          token: appState.user['jwt_token'],
          appliedJobId: widget.talentData.applied_job_id,
          payloads: jsonEncode(_payloads));
      if (res.statusCode == 200) {
        setState(() {
          isShortlist = false;
        });
        // update state for job shortlist changed
        jobProvider.currentSelectedAppliedJob.shortlisttalents_count =
            jobProvider.currentSelectedAppliedJob.shortlisttalents_count - 1;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully removed."),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try it again."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  // add talent to shortlist
  void onAddTalentToShortlist() async {
    try {
      Map _payloads = {"shortlist_status": true};
      var res = await api.updateShortlistStatus(
          token: appState.user['jwt_token'],
          appliedJobId: widget.talentData.applied_job_id,
          payloads: jsonEncode(_payloads));
      if (res.statusCode == 200) {
        setState(() {
          isShortlist = true;
        });
        // update state for job shortlist changed
        jobProvider.currentSelectedAppliedJob.shortlisttalents_count =
            jobProvider.currentSelectedAppliedJob.shortlisttalents_count + 1;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully added."),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try it again."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
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
                  height: 30,
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
                      IconButton(
                        onPressed: () {
                          onChatMessage();
                        },
                        icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: () {
                          if (isShortlist) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              title: '',
                              desc:
                                  'Do you want to Remove this Talent to shortlist?',
                              buttonsTextStyle:
                                  const TextStyle(color: Colors.white),
                              showCloseIcon: true,
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                onRemoveTalentFromShortlist();
                              },
                              btnOkColor: primaryColor,
                              btnCancelColor: secondaryColor,
                              barrierColor:
                                  Colors.purple[900]?.withOpacity(0.1),
                            ).show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              title: '',
                              desc:
                                  'Do you want to add this Talent to shortlist?',
                              buttonsTextStyle:
                                  const TextStyle(color: Colors.white),
                              showCloseIcon: true,
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                onAddTalentToShortlist();
                              },
                              btnOkColor: primaryColor,
                              btnCancelColor: secondaryColor,
                              barrierColor:
                                  Colors.purple[900]?.withOpacity(0.1),
                            ).show();
                          }
                        },
                        // icon: const Icon(CupertinoIcons.delete_solid),
                        icon: isShortlist
                            ? const Icon(CupertinoIcons.multiply_circle)
                            : const Icon(CupertinoIcons.person_add),
                        color: Colors.white,
                        iconSize: 30,
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

  // on chat function
  void onChatMessage() {
    if (isShortlist) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: '',
        desc: 'Are you sure you want to connect with ${widget.talentData.first_name} ?',
        buttonsTextStyle: const TextStyle(color: Colors.white),
        showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          
        },
        btnOkColor: primaryColor,
        btnCancelColor: secondaryColor,
        barrierColor: Colors.purple[900]?.withOpacity(0.1),
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: '',
        desc: 'You must add this Talent to shortlist in the first. Are you sure to add this Talent to Shortlist?',
        buttonsTextStyle: const TextStyle(color: Colors.white),
        showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          onAddTalentToShortlist();
        },
        btnOkColor: primaryColor,
        btnCancelColor: secondaryColor,
        barrierColor: Colors.purple[900]?.withOpacity(0.1),
      ).show();
    }
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
