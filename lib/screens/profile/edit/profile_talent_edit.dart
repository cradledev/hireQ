import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/profile_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/profile/edit/profile_talent_addvideo_screen.dart';
import 'package:hire_q/screens/profile/setting/setting_talent_screen.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class ProfileTalentEditScreen extends StatefulWidget {
  const ProfileTalentEditScreen({Key key}) : super(key: key);

  @override
  _ProfileTalentEditScreen createState() => _ProfileTalentEditScreen();
}

class _ProfileTalentEditScreen extends State<ProfileTalentEditScreen> {
  // app state setting
  AppState appState;

  // API Client setting
  APIClient api;

  // high level info diaglog Textform controller
  TextEditingController highLevelInputController;
  List<String> highLevelInformation = [];
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
    highLevelInputController = TextEditingController();
    if (appState.profile != null) {
      String _workHistory = (appState.profile).work_history;
      if (_workHistory.isNotEmpty) {
        var _workHistoryDict = jsonDecode(_workHistory);
        highLevelInformation =
            (_workHistoryDict as List).map((e) => e.toString()).toList();
      }
    }
    // print((appState.profile).toMap());
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
          if (_tmpProfile == null) {
            if (type == "image") {
              Map payloads = {
                "avator": body['url'],
                "user_id": appState.user['id'],
                "resume": _tmpProfile?.resume,
                "video_id": _tmpProfile?.video_id,
                "video": _tmpProfile?.video,
                "job": [],
                'work_history': [],
                "type": appState.user['type']
              };
              print(payloads);
              onCreateProfile(jsonEncode(payloads));
            }
            if (type == "video") {
              Map payloads = {
                "avator": "",
                "user_id": appState.user['id'],
                "resume": _tmpProfile?.resume,
                "video_id": _tmpProfile?.video_id,
                "video": _tmpProfile?.video,
                "job": [],
                'work_history': [],
                "type": appState.user['type']
              };
              print(payloads);
              onCreateProfile(jsonEncode(payloads));
            }
          } else {
            if (type == "image") {
              Map payloads = {
                "avator": body['url'],
                "user_id": _tmpProfile.user_id,
                "resume": _tmpProfile.resume,
                "video_id": _tmpProfile.video_id,
                "video": _tmpProfile.video,
                "job": _tmpProfile.job == null
                    ? []
                    : jsonDecode(_tmpProfile.job) as List,
                "work_history": _tmpProfile.work_history == null
                    ? []
                    : (jsonDecode(_tmpProfile.work_history) as List)
                        .map((e) => e.toString())
                        .toList(),
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
                "job":
                    _tmpProfile.job == null ? [] : jsonDecode(_tmpProfile.job),
                "work_history": _tmpProfile.work_history == null
                    ? []
                    : jsonDecode(_tmpProfile.work_history),
                "type": _tmpProfile.type
              };
              print(payloads);
              onProfileUpdate(_tmpProfile.id, jsonEncode(payloads));
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
            child: const SettingTalentScreen(),
          );
        },
      ),
    );
  }

  // adding talent high level information
  void onAddHighLevelInfo(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add High Level Info'),
            content: TextField(
              onChanged: (value) {
                // setState(() {
                //   valueText = value;
                // });
              },
              controller: highLevelInputController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration:
                  const InputDecoration(hintText: "Enter the High Level Info"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  setState(() {
                    highLevelInputController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  if (highLevelInputController.text.isNotEmpty) {
                    ProfileModel tmpProfile = appState.profile;

                    // if profile exist, then create the profile Or update profile
                    if (tmpProfile == null) {
                      try {
                        List<String> _preSaveHighLevelInfo = [];
                        _preSaveHighLevelInfo
                            .add(highLevelInputController.text);
                        Map payloads = {
                          'avator': tmpProfile == null ? "" : tmpProfile.avator,
                          'resume': tmpProfile == null ? "" : tmpProfile.resume,
                          'video_id': tmpProfile?.video_id,
                          'video': tmpProfile?.video,
                          'user_id': appState.user['id'],
                          'job': tmpProfile == null
                              ? []
                              : tmpProfile.job == null
                                  ? []
                                  : jsonDecode(tmpProfile.job) as List,
                          'work_history': _preSaveHighLevelInfo,
                          'type': appState.user['type']
                        };
                        var res = await api.createProfile(
                            token: appState.user['jwt_token'],
                            payloads: jsonEncode(payloads));
                        if (res.statusCode == 200) {
                          var body = jsonDecode(res.body);
                          if (body['status'] == "success") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Successfully Done.",
                              ),
                              backgroundColor: Colors.green,
                            ));
                            // roles.insert(index, 'Planet');
                            setState(() {
                              highLevelInformation
                                  .add(highLevelInputController.text);
                              highLevelInputController.clear();
                            });
                            appState.profile = ProfileModel.fromJson(body);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Something went wrong, Please try again it.",
                              ),
                              backgroundColor: Colors.orange,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Something went wrong, Please try again it.",
                            ),
                            backgroundColor: Colors.orange,
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Unknown Error is occured.",
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      List<String> _preSaveHighLevelInfo =
                          tmpProfile.work_history == null
                              ? []
                              : (jsonDecode(tmpProfile.work_history) as List)
                                  .map((e) => e.toString())
                                  .toList();
                      _preSaveHighLevelInfo.add(highLevelInputController.text);
                      Map payloads = {
                        'avator': tmpProfile == null ? "" : tmpProfile.avator,
                        'resume': tmpProfile == null ? "" : tmpProfile.resume,
                        'video_id': tmpProfile?.video_id,
                        'video': tmpProfile?.video,
                        'user_id': appState.user['id'],
                        'job': tmpProfile == null
                            ? []
                            : tmpProfile.job == null
                                ? []
                                : jsonDecode(tmpProfile.job) as List,
                        'work_history': _preSaveHighLevelInfo,
                        'type': appState.user['type']
                      };
                      try {
                        var res = await api.updateProfile(
                            id: tmpProfile.id,
                            token: appState.user['jwt_token'],
                            payloads: jsonEncode(payloads));
                        if (res.statusCode == 200) {
                          var body = jsonDecode(res.body);
                          if (body['status'] == "success") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Successfully Updated.",
                              ),
                              backgroundColor: Colors.green,
                            ));
                            setState(() {
                              highLevelInformation
                                  .add(highLevelInputController.text);
                              highLevelInputController.clear();
                            });
                            appState.profile = ProfileModel.fromJson(body);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Something went wrong, Please try again it.",
                              ),
                              backgroundColor: Colors.orange,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Something went wrong, Please try again it.",
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Unknown Error is occured.",
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.orange,
                      content: Text("Text input is empty."),
                    ));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<AppState>(builder: (context, _pAppState, child) {
                        return Text(
                          _pAppState.talent == null
                              ? ""
                              : (_pAppState.talent).first_name +
                                  (_pAppState.talent).last_name,
                          style: const TextStyle(
                              fontSize: 30, color: primaryColor),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: CachedNetworkImage(
                                        width: 140,
                                        height: 140,
                                        imageUrl: _pAppState.profile == null
                                            ? 'https://via.placeholder.com/150'
                                            : ((_pAppState.profile).avator ==
                                                        null ||
                                                    (_pAppState.profile)
                                                            .avator ==
                                                        "")
                                                ? 'https://via.placeholder.com/150'
                                                : _pAppState.hostAddress +
                                                    (_pAppState.profile).avator,
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
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.grey),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(microseconds: 800),
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
                          child: Stack(
                            children: [
                              CircleAvatar(
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
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(CupertinoIcons.eye_solid,
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        "Work History",
                        style: TextStyle(color: primaryColor, fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
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
                              onTap: () {
                                onAddHighLevelInfo(context);
                              },
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
                  child: highLevelInformation.isEmpty
                      ? Column(children: const [
                          SizedBox(
                            height: 30,
                          ),
                          Text("No work history Information in your Profile")
                        ])
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.horizontal,
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                ProfileModel tmpProfile = appState.profile;
                                List<String> _preSaveHighLevelInfo =
                                    tmpProfile.work_history == null
                                        ? []
                                        : (jsonDecode(tmpProfile.work_history)
                                                as List)
                                            .map((e) => e.toString())
                                            .toList();
                                _preSaveHighLevelInfo.removeAt(index);
                                Map payloads = {
                                  'avator': tmpProfile == null
                                      ? ""
                                      : tmpProfile.avator,
                                  'resume': tmpProfile == null
                                      ? ""
                                      : tmpProfile.resume,
                                  'video_id': tmpProfile?.video_id,
                                  'video': tmpProfile?.video,
                                  'user_id': appState.user['id'],
                                  'job': tmpProfile == null
                                      ? []
                                      : tmpProfile.job == null
                                          ? []
                                          : jsonDecode(tmpProfile.job) as List,
                                  'work_history': _preSaveHighLevelInfo,
                                  'type': appState.user['type']
                                };
                                try {
                                  var res = await api.updateProfile(
                                      id: tmpProfile.id,
                                      token: appState.user['jwt_token'],
                                      payloads: jsonEncode(payloads));
                                  if (res.statusCode == 200) {
                                    var body = jsonDecode(res.body);
                                    if (body['status'] == "success") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Successfully Updated.",
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      appState.profile =
                                          ProfileModel.fromJson(body);
                                      return true;
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Something went wrong, Please try again it.",
                                        ),
                                        backgroundColor: Colors.orange,
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Something went wrong, Please try again it.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Unknown Error is occured.",
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                  return false;
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  highLevelInformation.removeAt(index);
                                });
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20.0),
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                color: Colors.redAccent,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    highLevelInformation[index],
                                    style: const TextStyle(color: primaryColor),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: highLevelInformation.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          // padding: EdgeInsets.all(5),
                          scrollDirection: Axis.vertical,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
