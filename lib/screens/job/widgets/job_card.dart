import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/job_model.dart';
import 'package:hire_q/screens/video_player/video_player.dart';
import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/theme_helper.dart';

import '../detail/job_detail.dart';
import 'package:hire_q/widgets/image_gradient_overlay.dart';


class JobCard extends StatelessWidget {
  final BuildContext buildContext;
  final JobModel jobData;
  JobCard({Key key, this.buildContext, this.jobData}) : super(key: key);
  final hideNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageGradientOverlay(
            imageUrl: jobData.imageUrl,
          ),
          ValueListenableBuilder(
            valueListenable: hideNotifier,
            builder: (context, dynamic value, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: value ? -500 : 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  opacity: value ? 0.0 : 1.0,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            width: size.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(204, 209, 206, 1),
                                  Color.fromRGBO(204, 209, 206, 0.0),
                                ],
                                stops: [1, 0.0],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                HireQLogo(
                                  fontSize: size.height * .065,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        jobData.companyName,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 28),
                                      ),
                                      SizedBox(
                                        width: 64,
                                        child: Hero(
                                          tag: 'company_logo' +
                                              jobData.id.toString(),
                                          child: CachedNetworkImage(
                                            imageUrl: jobData.logo,
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      CircularProgressIndicator(
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 250,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobData.title,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.location_solid,
                                            color: primaryColor,
                                            size: 30.0,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            jobData.city,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Text(
                                              jobData.description,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                      _openPage(
                                          context, JobDetail(data: jobData));
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          // _openPage(context, const TalentDetail());
                        },
                        icon: const Icon(CupertinoIcons.multiply_circle),
                        color: Colors.red,
                        iconSize: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return ThemeHelper().alartDialog("warning",
                //         "Something went wrong, Please try again it.", context);
                //   },
                // );
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(microseconds: 800),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: const CustomVideoPlayer(),
                      );
                    },
                  ),
                );
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

  Future<void> _openPage(BuildContext context, Widget page) async {
    hideNotifier.value = true;
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: page);
        },
      ),
    );
    hideNotifier.value = false;
  }
}
