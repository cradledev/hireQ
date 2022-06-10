import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/detail_board/message_talent_board.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/helpers/api.dart';


import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:provider/provider.dart';



class MessageCompanyScreen extends StatefulWidget {
  const MessageCompanyScreen({Key key}) : super(key: key);

  @override
  _MessageCompanyScreen createState() => _MessageCompanyScreen();
}

class _MessageCompanyScreen extends State<MessageCompanyScreen> {
  AppState appState;
  APIClient api;
  @override
  void initState() {
    super.initState();
    api = APIClient();
    appState = Provider.of<AppState>(context, listen: false);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 800),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: const LobbyScreen(indexTab: 3),
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.arrow_left),
                      color: primaryColor,
                      iconSize: 30,
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Message Sent & Received",
                          style: TextStyle(fontSize: 26, color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: 
                 StreamBuilder<List<types.Room>>(
                  stream: FirebaseChatCore.instance.rooms(),
                  initialData: const [],
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                       final room = snapshot.data[index];
                       final otherUser = room.users.firstWhere(
                                (u) => u.id != appState.company.uuid
                              );
                        TalentModel  talentModel;
                        var body = {};
                          api.getTalentByuid(
                              uid: otherUser.id, token: appState.user['jwt_token']).then((res) =>{ 
                                if(res.statusCode == 200) {
                                body = jsonDecode(res.body),
                                talentModel = TalentModel(first_name: body['first_name'], last_name: body['first_name'], region: jsonEncode(body['region']) )
                              }});
                          // if (res.statusCode == 200) {
                          //   var body = jsonDecode(res.body);
                          //   setState(() {
                          //     totalCountOfTalents = body['applied_count'];
                          //     totalCountOfShortlist = body['shortlist_count'];
                          //   });
                          // }

                        return InkWell(
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
                                    child:  MessageTalentBoard(room: room, talentData: talentModel,),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: CachedNetworkImage(
                                    width: 64,
                                    height: 64,
                                    imageUrl:
                                        room.imageUrl,
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
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    height: 68,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: accentColor),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            room.name.toString(),
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            room.name.toString(),
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16,
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
                        );
                      },
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
