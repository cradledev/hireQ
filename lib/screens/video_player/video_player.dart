import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({Key key}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  FlickManager flickManager;
  final videoPlayerController = VideoPlayerController.network(
      'http://192.168.116.39:5000/static/uploads/history.mp4');
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {
    // await videoPlayerController.initialize();
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
    flickManager = FlickManager(
      videoPlayerController: videoPlayerController,
    );
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.hasError) {
        print("=======================");
        print(videoPlayerController.value.errorDescription);
      }
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await flickManager.flickControlManager.pause();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIcon: const Icon(
            CupertinoIcons.line_horizontal_3,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          leadingAction: () {},
          leadingFlag: true,
          actionEvent: () {},
          actionFlag: false,
          title: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: Image.asset(
                'assets/icons/Q.png',
                // height: height * 0.1,
                width: 50,
                color: secondaryColor,
              )),
        ),
        drawer: const CustomDrawerWidget(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                preferredDeviceOrientation: const [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown
                ],
              ),
            ),
            // Positioned.fill(
            //   child: DecoratedBox(
            //     decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.3),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: const Center(
                    child: Text(
                      "data",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await flickManager.flickControlManager.pause();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(CupertinoIcons.multiply_circle),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
