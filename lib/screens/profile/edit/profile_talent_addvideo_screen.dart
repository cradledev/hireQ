import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/profile_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:hire_q/widgets/video_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';

class ProfileTalentAddvideoScreen extends StatefulWidget {
  const ProfileTalentAddvideoScreen({Key key}) : super(key: key);

  @override
  _ProfileTalentAddvideoScreenState createState() =>
      _ProfileTalentAddvideoScreenState();
}

class _ProfileTalentAddvideoScreenState
    extends State<ProfileTalentAddvideoScreen> {
  // App state setting
  AppState appState;

  // API Setting
  APIClient api;
  // talent video list object
  List talentVideoList = [];

  // Imagepicker setting
  ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    api = APIClient();
    _picker = ImagePicker();
    Future.delayed(const Duration(milliseconds: 800), () {
// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
      });
      onInit();
    });
    
  }

  // custom init function
  void onInit() async {
    
    if (appState.profile == null) {
      talentVideoList = [
        {
          "url": "",
          "sequence": "Q1",
          "duration": 25,
          "description":
              "Your Name, City & Country, Current Title, Your Education"
        },
        {
          "url": "",
          "sequence": "Q2",
          "duration": 25,
          "description": "Quick brief Summary"
        },
        {
          "url": "",
          "sequence": "Q3",
          "duration": 65,
          "description": "Quick Snaps of your previous Experience"
        },
        {
          "url": "",
          "sequence": "Q4",
          "duration": 55,
          "description": "Current Job Roles & Responsibilities"
        },
        {
          "url": "",
          "sequence": "Q5",
          "duration": 25,
          "description": "Languages & Final words"
        }
      ];
      appState.talentVideoList = talentVideoList;
    } else {
      ProfileModel _tmpProfile = appState.profile;
      if (_tmpProfile.video_id == null) {
        talentVideoList = [
          {
            "url": "",
            "sequence": "Q1",
            "duration": 25,
            "description":
                "Your Name, City & Country, Current Title, Your Education"
          },
          {
            "url": "",
            "sequence": "Q2",
            "duration": 25,
            "description": "Quick brief Summary"
          },
          {
            "url": "",
            "sequence": "Q3",
            "duration": 65,
            "description": "Quick Snaps of your previous Experience"
          },
          {
            "url": "",
            "sequence": "Q4",
            "duration": 55,
            "description": "Current Job Roles & Responsibilities"
          },
          {
            "url": "",
            "sequence": "Q5",
            "duration": 25,
            "description": "Languages & Final words"
          }
        ];
        appState.talentVideoList = talentVideoList;
      } else {
        try {
          var res = await api.getVideoById(
              id: _tmpProfile.video_id, token: appState.user['jwt_token']);
          if (res.statusCode == 200) {
            var body = jsonDecode(res.body);
            if (body['status'] == "success") {
              var _videoData = (body['v_data'] as List).map((e) => e).toList();
              var _q1 = _videoData.firstWhere(
                  (element) => element['sequence'] == "Q1",
                  orElse: () => null);
              var _q2 = _videoData.firstWhere(
                  (element) => element['sequence'] == "Q2",
                  orElse: () => null);
              var _q3 = _videoData.firstWhere(
                  (element) => element['sequence'] == "Q3",
                  orElse: () => null);
              var _q4 = _videoData.firstWhere(
                  (element) => element['sequence'] == "Q4",
                  orElse: () => null);
              var _q5 = _videoData.firstWhere(
                  (element) => element['sequence'] == "Q5",
                  orElse: () => null);
              talentVideoList = [
                {
                  "url": _q1 == null ? "" : _q1['url'],
                  "sequence": "Q1",
                  "duration": 25,
                  "description":
                      "Your Name, City & Country, Current Title, Your Education"
                },
                {
                  "url": _q2 == null ? "" : _q2['url'],
                  "sequence": "Q2",
                  "duration": 25,
                  "description": "Quick brief Summary"
                },
                {
                  "url": _q3 == null ? "" : _q3['url'],
                  "sequence": "Q3",
                  "duration": 65,
                  "description": "Quick Snaps of your previous Experience"
                },
                {
                  "url": _q4 == null ? "" : _q4['url'],
                  "sequence": "Q4",
                  "duration": 55,
                  "description": "Current Job Roles & Responsibilities"
                },
                {
                  "url": _q5 == null ? "" : _q5['url'],
                  "sequence": "Q5",
                  "duration": 25,
                  "description": "Languages & Final words"
                }
              ];
              appState.talentVideoList = talentVideoList;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong. Please try again it."),
                backgroundColor: Colors.red,
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong. Please try again it."),
              backgroundColor: Colors.red,
            ));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unknow erro is occured."),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  // create talent video by camera
  void onTakeVideoByCamera(ImageSource source, {sequence}) async {
    //
    final result = await _picker.pickVideo(
        source: source,
        maxDuration: Duration(
            seconds: talentVideoList[talentVideoList
                    .indexWhere((element) => element['sequence'] == sequence)]
                ['duration'] as int));
    if (result != null) {
      onUploadFile(result, sequence: sequence);
    }
  }

  // create talent video by local file
  void onTakeVideoByFile(ImageSource source, {sequence}) async {
    //
    final result = await _picker.pickVideo(
        source: source,
        maxDuration: Duration(
            seconds: talentVideoList[talentVideoList
                    .indexWhere((element) => element['sequence'] == sequence)]
                ['duration'] as int));
    if (result != null) {
      onUploadFile(result, sequence: sequence);
    }
  }

  // file uplaod function
  void onUploadFile(XFile imageFile, {sequence = "Q1"}) async {
    try {
      var res = await api.postFileUpload(
          token: appState.user['jwt_token'], filePath: imageFile.path);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body['status'] == "success") {
          ProfileModel _tmpProfile = appState.profile;
          if (_tmpProfile == null) {
            talentVideoList[talentVideoList
                    .indexWhere((element) => element['sequence'] == sequence)]
                ['url'] = body['url'];
            Map payloads = {
              'v_data': talentVideoList,
              'type': appState.user['type']
            };
            onCreateVideoRow(jsonEncode(payloads), profileExist: false);
          } else {
            if (_tmpProfile.video_id == null) {
              talentVideoList[talentVideoList
                      .indexWhere((element) => element['sequence'] == sequence)]
                  ['url'] = body['url'];
              Map payloads = {
                'v_data': talentVideoList,
                'type': appState.user['type']
              };
              onCreateVideoRow(jsonEncode(payloads), profileExist: true);
            } else {
              print("object");
              talentVideoList[talentVideoList
                      .indexWhere((element) => element['sequence'] == sequence)]
                  ['url'] = body['url'];
              Map payloads = {
                'v_data': talentVideoList,
                'type': appState.user['type']
              };
              onVideoUpdate(_tmpProfile.video_id, jsonEncode(payloads));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong. Please try again later."),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(body['error']),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unknown error"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // create video row and return video id
  void onCreateVideoRow(_pPayloads, {profileExist = false}) async {
    try {
      var res = await api.createVideoRow(
          token: appState.user['jwt_token'], payloads: _pPayloads);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['status'] == "success") {
          if (profileExist) {
            ProfileModel _tmpProfile = appState.profile;
            Map payloads = {
              "avator": _tmpProfile.avator,
              "user_id": appState.user['id'],
              "resume": _tmpProfile.resume,
              "video_id": body['id'],
              "video": null,
              "job": _tmpProfile.job == null ? [] : jsonDecode(_tmpProfile.job),
              'work_history': _tmpProfile.work_history == null
                  ? []
                  : jsonDecode(_tmpProfile.work_history),
              "type": appState.user['type']
            };
            onProfileUpdate(_tmpProfile.id, jsonEncode(payloads));
          } else {
            Map payloads = {
              "avator": "",
              "user_id": appState.user['id'],
              "resume": null,
              "video_id": body['id'],
              "video": null,
              "job": [],
              'work_history': [],
              "type": appState.user['type']
            };
            print(payloads);
            onCreateProfile(jsonEncode(payloads));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong on creating Video file"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong on creating Video file"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong on creating Video file"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // video update
  void onVideoUpdate(_id, _payloads) async {
    try {
      var res = await api.updateVideoRow(
          id: _id, token: appState.user['jwt_token'], payloads: _payloads);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          // appState.profile = ProfileModel.fromJson(body);
          appState.talentVideoList = talentVideoList;
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong. Please try again later."),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try again later."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unknown error on updating profile."),
        backgroundColor: Colors.red,
      ));
    }
  }

  // profile update
  void onProfileUpdate(_id, _payloads) async {
    try {
      var res = await api.updateProfile(
          id: _id, token: appState.user['jwt_token'], payloads: _payloads);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          appState.profile = ProfileModel.fromJson(body);
          appState.talentVideoList = talentVideoList;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong. Please try again later."),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try again later."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unknown error on updating profile."),
        backgroundColor: Colors.red,
      ));
    }
  }

  // create profile function
  void onCreateProfile(_payloads) async {
    try {
      var res = await api.createProfile(
          token: appState.user['jwt_token'], payloads: _payloads);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          appState.profile = ProfileModel.fromJson(body);
          appState.talentVideoList = talentVideoList;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong. Please try again later."),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try again later."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unknown error on updating profile."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      drawer: const CustomDrawerWidget(),
      body: Consumer<AppState>(
        builder: (context, _pAppState, child) {
          List tmpTalentVideoList = _pAppState.talentVideoList;
          print(1);
          return Stack(
            fit: StackFit.expand,
            children: [
              InViewNotifierList(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                initialInViewIds: const ['0'],
                isInViewPortCondition: (double deltaTop, double deltaBottom,
                    double viewPortDimension) {
                  return deltaTop < (0.3 * viewPortDimension) &&
                      deltaBottom > (0.3 * viewPortDimension);
                },
                itemCount:
                    tmpTalentVideoList == null ? 5 : tmpTalentVideoList.length,
                builder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      // color: Colors.greenAccent,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // aspectRatio: 1 / 16,
                            height: 200,
                            // width: double.infinity,

                            // color: Colors.greenAccent,

                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //       color: Colors.greenAccent, width: 1.5),
                            //   borderRadius: BorderRadius.circular(20),

                            // ),

                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return InViewNotifierWidget(
                                id: '$index',
                                builder: (BuildContext context, bool isInView,
                                    Widget child) {
                                  if (tmpTalentVideoList == null) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "No Video Data.",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    if (tmpTalentVideoList[index]['url']
                                        .toString()
                                        .isEmpty) {
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "No Video Data.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return VideoPlayerWidget(
                                          play: isInView,
                                          // play: false,
                                          url: appState.hostAddress +
                                              tmpTalentVideoList[index]['url']);
                                    }
                                  }
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            tmpTalentVideoList == null
                                ? "...loading"
                                : tmpTalentVideoList[index]['sequence'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            tmpTalentVideoList == null
                                ? "...loading"
                                : tmpTalentVideoList[index]['description'],
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  onTakeVideoByCamera(ImageSource.camera,
                                      sequence: tmpTalentVideoList[index]
                                          ['sequence']);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.video_camera_front,
                                        color: primaryColor),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        50,
                                      ),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(2, 4),
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  onTakeVideoByFile(ImageSource.gallery,
                                      sequence: tmpTalentVideoList[index]
                                          ['sequence']);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child:
                                        Icon(Icons.folder, color: primaryColor),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        50,
                                      ),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(2, 4),
                                        color: Colors.black.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
