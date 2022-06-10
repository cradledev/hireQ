import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:provider/provider.dart';

class MessageTalentBoard extends StatefulWidget {
  const MessageTalentBoard({Key key, this.room, this.talentData}) : super(key: key);
  final types.Room room;
  final TalentModel talentData; 
  @override
  _MessageTalentBoard createState() => _MessageTalentBoard();
}

class _MessageTalentBoard extends State<MessageTalentBoard> {
  bool _isAttachmentUploading = false;
  int currentPage = 2;
  // search text controller
  TextEditingController _searchTextController;
  // App state provider setting
  AppState appState;
  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
  }


  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
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
          title: AppbarSearchFormField(
            obsecureText: false,
            textInputType: TextInputType.text,
            prefixIcon: const Icon(
              CupertinoIcons.search,
              color: secondaryColor,
            ),
            maxLines: 1,
            textInputAction: TextInputAction.done,
            suffixIcon: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: secondaryColor,
            ),
            controller: _searchTextController,
          ),
        ),
        drawer: const CustomDrawerWidget(),
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
        body: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.zero,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
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
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   PageRouteBuilder(
                                          //     transitionDuration: const Duration(
                                          //         milliseconds: 500),
                                          //     pageBuilder: (context, animation,
                                          //         secondaryAnimation) {
                                          //       return FadeTransition(
                                          //         opacity: animation,
                                          //         child: JobDetailBoard(
                                          //           data:
                                          //               JobModel.dumpListData[3],
                                          //         ),
                                          //       );
                                          //     },
                                          //   ),
                                          // );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children:  [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 5),
                                                child: Text(
                                                  widget.talentData.first_name + ' ' + widget.talentData.last_name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 28,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children:  [
                                            const Icon(
                                              CupertinoIcons.location_solid,
                                              color: Colors.white70,
                                              size: 30.0,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.talentData.region.isEmpty ? "" : jsonDecode(widget.talentData.region)['city'] ?? "No City",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Text(
                                          appState.company.name,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<types.Room>(
                          initialData: widget.room,
                          stream:
                              FirebaseChatCore.instance.room(widget.room.id),
                          builder: (context, snapshot) {
                            return StreamBuilder<List<types.Message>>(
                              initialData: const [],
                              stream: FirebaseChatCore.instance
                                  .messages(snapshot.data),
                              builder: (context, snapshot) {
                                return Chat(
                                  isAttachmentUploading: _isAttachmentUploading,
                                  messages: snapshot.data ?? [],
                                  onAttachmentPressed: _handleAtachmentPressed,
                                  onMessageTap: _handleMessageTap,
                                  onPreviewDataFetched:
                                      _handlePreviewDataFetched,
                                  onSendPressed: _handleSendPressed,
                                  user: types.User(
                                    id: FirebaseChatCore
                                            .instance.firebaseUser?.uid ??
                                        '',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
