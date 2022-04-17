import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/widgets/common_widget.dart';

import '../detail/talent_detail.dart';
import 'package:hire_q/widgets/image_gradient_overlay.dart';

class TalentCard extends StatelessWidget {
  final BuildContext buildContext;
  final TalentModel talentData;
  TalentCard({Key key, this.buildContext, this.talentData}) : super(key: key);
  final hideNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ImageGradientOverlay(
            imageUrl: talentData.imageUrl,
          ),
          ValueListenableBuilder(
            valueListenable: hideNotifier,
            builder: (context, dynamic value, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: value ? -100 : 0,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: HireQLogo(
                              fontSize: size.height * .065,
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            "assets/icons/Play.png",
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                talentData.firstName +
                                    " " +
                                    talentData.lastName,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: RawMaterialButton(
                                onPressed: () {
                                  _openPage(
                                      context, TalentDetail(data: talentData));
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
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
