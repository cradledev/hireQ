import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/company_job_model.dart';
import 'package:hire_q/models/profile_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/screens/profile/edit/profile_company_addjob_screen.dart';
import 'package:hire_q/screens/profile/setting/setting_company_screen.dart';
import 'package:hire_q/screens/video_player/video_player.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class ProfileCompanyEdit extends StatefulWidget {
  const ProfileCompanyEdit({Key key}) : super(key: key);

  @override
  _ProfileCompanyEdit createState() => _ProfileCompanyEdit();
}

class _ProfileCompanyEdit extends State<ProfileCompanyEdit> {
  // app state setting
  AppState appState;

  // API Client setting
  APIClient api;
  // Imagepicker setting
  ImagePicker _picker;
  // pick file
  // XFile _selectedFile;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {
    appState = Provider.of<AppState>(context, listen: false);
    api = APIClient();
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // take a picture from camera
  void onTakeProfilePicture(ImageSource source, {BuildContext context}) async {
    final result = await _picker.pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );
    if (result != null) {
      onUploadFile(result);
    }
  }

  // pick image from galler and replace image
  void onClickOverAvatar(ImageSource source, {BuildContext context}) async {
    final result = await _picker.pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );
    if (result != null) {
      onUploadFile(result);
    }
  }

  // creating company video function
  void onCreateCompanyVideo(ImageSource source) async {
    //
    final result = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    if (result != null) {
      onUploadFile(result, type: "video");
    }
  }

  // uploading video file from file manager
  void onClickOverVideo(ImageSource source) async {
    //
    final result = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    if (result != null) {
      onUploadFile(result, type: "video");
    }
  }

  // file uplaod function
  void onUploadFile(XFile imageFile, {type = "image"}) async {
    try {
      var res = await api.postFileUpload(
          token: appState.user['jwt_token'], filePath: imageFile.path);
      var body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (body['status'] == "success") {
          ProfileModel _tmpProfile = appState.profile;
          if (type == "image") {
            Map payloads = {
              "avator": body['url'],
              "user_id": _tmpProfile.user_id,
              "resume": _tmpProfile.resume,
              "video_id": _tmpProfile.video_id,
              "video": _tmpProfile.video,
              "job": _tmpProfile.job.isEmpty ? [] : jsonDecode(_tmpProfile.job),
              "work_history": _tmpProfile.work_history.isEmpty
                  ? []
                  : jsonDecode(_tmpProfile.work_history),
              "type": _tmpProfile.type
            };
            print(payloads);
            onProfileUpdate(_tmpProfile.id, jsonEncode(payloads));
          }
          if (type == "video") {
            Map payloads = {
              "avator": _tmpProfile.avator,
              "user_id": _tmpProfile.user_id,
              "resume": _tmpProfile.resume,
              "video_id": _tmpProfile.video_id,
              "video": body['url'],
              "job": _tmpProfile.job.isEmpty ? [] : jsonDecode(_tmpProfile.job),
              "work_history": _tmpProfile.work_history.isEmpty
                  ? []
                  : jsonDecode(_tmpProfile.work_history),
              "type": _tmpProfile.type
            };
            print(payloads);
            onProfileUpdate(_tmpProfile.id, jsonEncode(payloads));
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

  // go editing page for company including information such as company name, phone, region,etc.
  void onEditSetting() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const SettingCompanyScreen(),
          );
        },
      ),
    );
  }

  // adding current company job
  void onAddCompanyJob() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const ProfileCompanyAddJobScreen(),
          );
        },
      ),
    );
  }

  // go to current company job detail page
  void onDetailOfCurrentCompanyJob(CompanyJobModel _pCurrentJob) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ProfileCompanyAddJobScreen(
                editable: true, selectedJob: _pCurrentJob),
          );
        },
      ),
    );
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
        body: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<AppState>(builder: (context, _pAppState, child) {
                      return Text(
                        (_pAppState.company).name,
                        style:
                            const TextStyle(fontSize: 30, color: primaryColor),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: onEditSetting,
                        child: Container(
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.settings, color: primaryColor),
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
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            onClickOverAvatar(ImageSource.gallery,
                                context: context);
                          },
                          child: Consumer<AppState>(
                            builder: (context, _pAppState, child) {
                              return CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.grey.shade200,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                      (_pAppState.profile).avator == ""
                                          ? 'https://via.placeholder.com/150'
                                          : appState.hostAddress +
                                              (appState.profile).avator),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: InkWell(
                            onTap: () {
                              onTakeProfilePicture(ImageSource.camera,
                                  context: context);
                            },
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child:
                                    Icon(Icons.add_a_photo, color: Colors.grey),
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if ((appState.profile).video != "") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(microseconds: 800),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: CustomVideoPlayer(
                                        sourceUrl: appState.hostAddress +
                                            (appState.profile).video,
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Your company has nothing for Video. Please Upload Video."),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Consumer<AppState>(
                            builder: (context, _pAppState, child) {
                              return CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.grey.shade200,
                                child: const CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.grey,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/icons/Creat video.png"),
                                    height: 80,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: InkWell(
                            onTap: () {
                              onCreateCompanyVideo(ImageSource.camera);
                            },
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(Icons.add_a_photo,
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
                        ),
                        Positioned(
                          bottom: 1,
                          right: 50,
                          child: InkWell(
                            onTap: () {
                              onCreateCompanyVideo(ImageSource.gallery);
                            },
                            child: Container(
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(Icons.folder_copy,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: primaryColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "Jobs",
                      style: TextStyle(color: primaryColor, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Container(
                      width: 56,
                      height: 56,
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
                            offset: const Offset(1, 3),
                            color: Colors.black.withOpacity(
                              0.3,
                            ),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.7),
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: onAddCompanyJob,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(
                                  Icons.add_card,
                                  color: primaryColor,
                                ), // <-- Icon
                                Text("Add"), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                color: primaryColor,
              ),
              Expanded(
                child: Consumer<JobsProvider>(
                  builder: (context, pJobProvider, child) {
                    List<CompanyJobModel> _currentCompanyJobs =
                        pJobProvider.currentCompanyJobs;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onDetailOfCurrentCompanyJob(
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
                                  style: const TextStyle(color: primaryColor),
                                ),
                                subtitle: Text(
                                  ((jsonDecode(_currentCompanyJobs[index]
                                              .region))['city'] ==
                                          null || (jsonDecode(_currentCompanyJobs[index]
                                              .region))['city'] == "")
                                      ? ""
                                      : (jsonDecode(_currentCompanyJobs[index]
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
      ),
    );
  }
}
