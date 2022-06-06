import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:hire_q/widgets/video_widget.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({Key key, this.sourceUrl}) : super(key: key);
  final String sourceUrl;
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: const Icon(
          CupertinoIcons.line_horizontal_3,
          size: 40,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        // leadingAction: () {},
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
          VideoPlayerWidget(
            url: widget.sourceUrl,
            play: true,
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
    );
  }
}
