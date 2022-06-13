import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/profile_model.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/appliedq/applied_q_talent_screen.dart';
import 'package:hire_q/screens/home/home_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_addvideo_screen.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_edit.dart';
import 'package:hire_q/screens/videoview/video_view_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';

import 'package:hire_q/screens/jobsq/jobs_q_talent_screen.dart';
import 'package:provider/provider.dart';

import 'package:steps_indicator/steps_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  // app state setting
  AppState appState;

  // API setting
  APIClient api;
  // profile status setting
  int selectedStep = 2;
  int nbSteps = 5;
  // chart setting
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  // count of  applied job
  int appliedJobsCount;
  int shortlistJobsCount;
  int videoViewsCount;
  List<Color> colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7)
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedStep = 2;
      appliedJobsCount = 0;
      shortlistJobsCount = 0;
      videoViewsCount = 0;
    });
    onInit();
  }

  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    if (appState.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(microseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: const HomeScreen(),
              );
            },
          ),
        );
      });
      return;
    }
    api = APIClient();
    // init get data including talent, profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onGetTalent();
      onGetProfile();
      onGetAppliedJobsCount();
      onGetVideoViewsCount();
    });
  }

  void onGetTalent() async {
    try {
      var res = await api.getTalentByUser(
          userId: appState.user['id'], token: appState.user['jwt_token']);
      if (res.statusCode == 200) {
        appState.talent = TalentModel.fromJson(jsonDecode(res.body.toString()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("You have no profile now. Please fill it."),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Unknown Error."),
      ));
    }
  }

  void onGetProfile() async {
    try {
      var res = await api.getProfile(
          userId: appState.user['id'], token: appState.user['jwt_token']);
      var body = jsonDecode(res.body.toString());
      if (res.statusCode == 200) {
        appState.profile = ProfileModel.fromJson(body);
      }
      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(body['error']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Unknown Error is occured."),
      ));
    }
  }

  // get applied jobs count
  void onGetAppliedJobsCount() async {
    try {
      var res = await api.getTotalCountAppliedJobsByMe(
          token: appState.user['jwt_token']);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body.toString());
        setState(() {
          appliedJobsCount = body['applied_count'];
          shortlistJobsCount = body['shortlist_count'];
        });
      }
    } catch (e) {
      print(e);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")))
    }
  }

  // get video views count
  void onGetVideoViewsCount() async {
    try {
      var res = await api.getVideoViewsCount(
          token: appState.user['jwt_token']);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body.toString());
        setState(() {
          videoViewsCount = body['count'];
        });
      }
    } catch (e) {
      print(e);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")))
    }
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35 * 5 / 6 +
                    MediaQuery.of(context).size.height * 0.33 * 0.5,
                padding: EdgeInsets.zero,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          height:
                              MediaQuery.of(context).size.height * 0.35 * 5 / 6,
                          width: MediaQuery.of(context).size.width,
                          child: Consumer<AppState>(
                            builder: (context, _pAppState, child) {
                              return CachedNetworkImage(
                                imageUrl: _pAppState.profile == null
                                    ? "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
                                    : ((_pAppState.profile).avator == null ||
                                            (_pAppState.profile).avator == "")
                                        ? "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
                                        : appState.hostAddress +
                                            (_pAppState.profile).avator,
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
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                        Container(
                          height:
                              MediaQuery.of(context).size.height * 0.33 * 0.5,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          color: const Color(0xffEFF2F2),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Profile Status",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Completed : 50%',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: StepsIndicator(
                                  selectedStep: selectedStep,
                                  nbSteps: nbSteps,
                                  selectedStepColorOut: primaryColor,
                                  selectedStepColorIn: Colors.white,
                                  unselectedStepColorIn: accentColor,
                                  unselectedStepColorOut: accentColor,
                                  doneStepColor: primaryColor,
                                  doneLineColor: primaryColor,
                                  undoneLineColor: accentColor,
                                  isHorizontal: true,
                                  doneStepSize: 10,
                                  unselectedStepSize: 10,
                                  selectedStepSize: 14,
                                  selectedStepBorderSize: 1,
                                  // doneStepWidget: Container(), // Custom Widget
                                  // unselectedStepWidget: Container(), // Custom Widget
                                  selectedStepWidget: const CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 12,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ), // Custom Widget
                                  lineLength:
                                      MediaQuery.of(context).size.width * 0.12,
                                  // lineLengthCustomStep: [
                                  //   StepsIndicatorCustomLine(nbStep: 4, length: 105)
                                  // ],
                                  enableLineAnimation: true,
                                  enableStepAnimation: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          height:
                              MediaQuery.of(context).size.height * 0.35 * 5 / 6,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                          child: const Image(
                                            image: AssetImage(
                                                "assets/icons/Gold.png"),
                                            height: 35.0,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            "Q Gold",
                                            style: TextStyle(
                                              color: Color(0xffbea06a),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Consumer<AppState>(
                                        builder: (context, _pAppState, child) {
                                      return Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              child: CachedNetworkImage(
                                                width: 100,
                                                height: 100,
                                                imageUrl: _pAppState.profile ==
                                                        null
                                                    ? 'https://via.placeholder.com/150'
                                                    : ((_pAppState.profile)
                                                                    .avator ==
                                                                null ||
                                                            (_pAppState.profile)
                                                                    .avator ==
                                                                "")
                                                        ? 'https://via.placeholder.com/150'
                                                        : _pAppState
                                                                .hostAddress +
                                                            (_pAppState.profile)
                                                                .avator,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                        downloadProgress) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: CircularProgressIndicator(
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
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              _pAppState.talent == null
                                                  ? ""
                                                  : '@${(_pAppState.talent).current_jobTitle}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: Text(
                                              _pAppState.talent != null
                                                  ? (_pAppState.talent)
                                                          .first_name +
                                                      " " +
                                                      (_pAppState.talent)
                                                          .last_name
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: OutlineButtonCustomWithIcon(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child:
                                                const ProfileTalentEditScreen(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  text: "More",
                                  height: 35,
                                  image: "assets/icons/edit.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
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
                                    child: const ProfileTalentAddvideoScreen(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 15, left: 15, right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                            child: const Image(
                              image: AssetImage("assets/icons/Play.png"),
                              height: 35.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.33 * 2 / 5,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: accentColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
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
                                child: const ProfileTalentAddvideoScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Color(0xffC8D3D5),
                            child: Image(
                              image: AssetImage("assets/icons/Creat video.png"),
                              height: 22.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Create Video",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 800),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: const LobbyScreen(indexTab: 2),
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Color(0xffC8D3D5),
                            child: Image(
                              image: AssetImage("assets/icons/message.png"),
                              height: 22.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Message",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
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
                                child: const ProfileTalentEditScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Color(0xffC8D3D5),
                            child: Image(
                              image: AssetImage("assets/icons/upload file.png"),
                              height: 22.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Upload File",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: accentColor),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dash Q View",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text("Three Figures",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                )),
                            content: Padding(
                              padding: EdgeInsets.zero,
                              child: PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius: math.min(
                                    MediaQuery.of(context).size.width / 3.2,
                                    70),
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.disc,
                                ringStrokeWidth: 32,
                                centerText: null,

                                legendOptions: const LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: false,
                                  // legendShape: _BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                              ),
                            ),
                            backgroundColor: const Color(0xffEFF2F2),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Video Views",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 16,
                              ),
                            ),
                            content:  Text(
                              videoViewsCount?.toString() ?? '0',
                              style:
                                  TextStyle(color: accentColor, fontSize: 40),
                            ),
                            backgroundColor: primaryColor,
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
                                      child: const VideoViewScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Applied Q",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            content: Text(
                              appliedJobsCount.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 40),
                            ),
                            backgroundColor: secondaryColor,
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
                                      child: const AppliedQTalentScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Jobs Q",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            content: Text(
                              shortlistJobsCount?.toString() ?? "0",
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 40),
                            ),
                            backgroundColor: accentColor,
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
                                      child: const JobsQTalentScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "High Level Information",
                  style: TextStyle(color: primaryColor, fontSize: 22),
                ),
              ),
              Consumer<AppState>(
                builder: (context, _pAppState, child) {
                  return _pAppState.talent == null
                      ? const Text("No High Level Information.")
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Card(
                                  color: const Color(0xffC8D3D5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    title: const Text(
                                      "Location",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    subtitle: Text(
                                      jsonDecode((_pAppState.talent).region)[
                                              'state'] +
                                          ", " +
                                          jsonDecode((_pAppState.talent)
                                              .region)['city'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Card(
                                  color: const Color(0xffC8D3D5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    title: const Text(
                                      "Current Role",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    subtitle: Text(
                                      _pAppState.talent == null
                                          ? ""
                                          : (_pAppState.talent)
                                              .current_jobTitle,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Card(
                                  color: const Color(0xffC8D3D5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    title: const Text(
                                      "Years of Experience",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    subtitle: Text(
                                      _pAppState.talent == null
                                          ? ""
                                          : _pAppState.talent.years_experience.isEmpty ? "No Experience" : _pAppState.talent.years_experience,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Card(
                                  color: const Color(0xffC8D3D5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    title: const Text(
                                      "Education",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    subtitle: Text(
                                      _pAppState.talent == null
                                          ? ""
                                          : _pAppState.talent.education.isNotEmpty ? _pAppState.talent?.education : "No education",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
