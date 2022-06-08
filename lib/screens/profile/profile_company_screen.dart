import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/applied_job_model.dart';
import 'package:hire_q/models/company_model.dart';
import 'package:hire_q/models/profile_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/screens/appliedq/applied_q_company_screen.dart';
import 'package:hire_q/screens/detail_board/job_detail_company_board.dart';
import 'package:hire_q/screens/jobsq/jobs_q_company_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/screens/profile/edit/profile_company_edit.dart';
import 'package:hire_q/screens/video_player/video_player.dart';
import 'package:hire_q/screens/videoview/video_view_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

import 'package:steps_indicator/steps_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

class ProfileCompanyScreen extends StatefulWidget {
  const ProfileCompanyScreen({Key key}) : super(key: key);

  @override
  _ProfileCompanyScreen createState() => _ProfileCompanyScreen();
}

class _ProfileCompanyScreen extends State<ProfileCompanyScreen> {
  // app state setting
  AppState appState;

  // Job provider setting
  JobsProvider jobProvider;
  int selectedStep = 2;
  int nbSteps = 5;
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };
  // API service import
  APIClient api;

  // total count of applied talent for company jobs
  int totalCountOfTalents = 0;
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
    onInit();
  }

  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    // job provider init
    jobProvider = Provider.of<JobsProvider>(context, listen: false);
    // set init state
    setState(() {
      selectedStep = 2;
      totalCountOfTalents = 0;
    });
    // APIClient instance
    api = APIClient();
    // init get data including company, profile, company jobs
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   onGetCompany();
    //   onGetProfile();
    // });
    onGetCompany();
    onGetProfile();
  }

  // get total count of talents for this company
  void onGetTotalCountOfTalentForCompanyJobs() async {
    try {
      var res = await api.getTotalCountAppliedTalentsForCompany(
          companyId: appState.company.id, token: appState.user['jwt_token']);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        setState(() {
          totalCountOfTalents = body['count'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void onGetCompany() async {
    try {
      var res = await api.getCompany(
          userId: appState.user['id'], token: appState.user['jwt_token']);
      if (res.statusCode == 200) {
        appState.company =
            CompanyModel.fromJson(jsonDecode(res.body.toString()));
        onGetCurrentCompayJobs(appState.company.id);
        onGetTotalCountOfTalentForCompanyJobs();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.message),
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
        content: Text("Unknown1 Error is occured."),
      ));
    }
  }

  void onGetCurrentCompayJobs(_p_companyId) {
    api
        .getCurrentCompanyJobs(
            companyId: _p_companyId, token: appState.user['jwt_token'])
        .then((res) {
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body.toString());
        if ((body as List).isNotEmpty) {
          jobProvider.currentCompanyJobs = (body as List)
              .map((item) => AppliedJobModel.fromJson(item))
              .toList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Your Company has no jobs."),
          ));
        }
      }
      if (res.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Something went wrong. Please try again it."),
        ));
      }
    }).catchError((error) {
      print(error);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   backgroundColor: Colors.red,
      //   content: Text("Unknown Error is occured."),
      // ));
    });
  }

  // go to company video view page
  void onGoToCompanyVideoView() {
    if (appState.profile != null) {
      ProfileModel _tmpProfile = appState.profile;
      if (_tmpProfile.video.isNotEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(microseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: CustomVideoPlayer(
                  sourceUrl: appState.hostAddress + _tmpProfile.video,
                ),
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Your Company has nothing for Video."),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("The video is loading... Please wait for a while."),
        ),
      );
    }
  }

  // go to job detail board page
  void onGotoJobDetailBoard(AppliedJobModel _pCompanyJob) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: JobDetailCompanyBoard(selectedCompanyJob: _pCompanyJob),
          );
        },
      ),
    );
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
                                    : ((appState.profile).avator == null ||
                                            (appState.profile).avator == "")
                                        ? "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
                                        : appState.hostAddress +
                                            (appState.profile).avator,
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
                                          CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: _pAppState
                                                        .profile ==
                                                    null
                                                ? const NetworkImage(
                                                    'https://via.placeholder.com/150')
                                                : ((_pAppState.profile)
                                                                .avator ==
                                                            null ||
                                                        (_pAppState.profile)
                                                                .avator ==
                                                            "")
                                                    ? const NetworkImage(
                                                        'https://via.placeholder.com/150')
                                                    : NetworkImage(
                                                        _pAppState.hostAddress +
                                                            (_pAppState.profile)
                                                                .avator),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: Text(
                                              _pAppState.company != null
                                                  ? (_pAppState.company).name
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              _pAppState.company == null
                                                  ? ""
                                                  : '@${(_pAppState.company).account_manager_name}',
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
                                            child: const ProfileCompanyEdit(),
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
                          onTap: onGoToCompanyVideoView,
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
                                child: const ProfileCompanyEdit(),
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
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: const LobbyScreen(
                                  indexTab: 2,
                                ),
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
                                child: const ProfileCompanyEdit(),
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
                                animationDuration:
                                    const Duration(milliseconds: 800),
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
                            content: const Text(
                              "487",
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
                              totalCountOfTalents.toString(),
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
                                      child: const AppliedQCompanyScreen(),
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
                              "Jobs Shortlist Q",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            content: const Text(
                              "5",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 40),
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
                                      child: const JobsQCompanyScreen(),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Jobs",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    Expanded(
                      child: Consumer<JobsProvider>(
                        builder: (context, pJobProvider, child) {
                          List<AppliedJobModel> _currentCompanyJobs =
                              pJobProvider.currentCompanyJobs;
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  onGotoJobDetailBoard(
                                      _currentCompanyJobs[index]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Card(
                                    // color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _currentCompanyJobs[index].title,
                                        style: const TextStyle(
                                            color: primaryColor),
                                      ),
                                      subtitle: Text(
                                        ((jsonDecode(_currentCompanyJobs[index]
                                                        .region))['city'] ==
                                                    null ||
                                                (jsonDecode(_currentCompanyJobs[
                                                            index]
                                                        .region))['city'] ==
                                                    "")
                                            ? ""
                                            : (jsonDecode(
                                                _currentCompanyJobs[index]
                                                    .region))['city'],
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _currentCompanyJobs.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            // padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
