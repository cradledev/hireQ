import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/widgets/common_widget.dart';

import 'package:hire_q/widgets/swipe_detector.dart';

class TalentScreen extends StatefulWidget {
  const TalentScreen({Key key}) : super(key: key);

  @override
  _TalentScreen createState() => _TalentScreen();
}

class _TalentScreen extends State<TalentScreen> {
  PageController _pageController;
  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    // The PageController allows us to instruct the PageView to change pages.
    _pageController = PageController();
  }

  void _goForward() {
    _pageController.nextPage(
      duration: pageTurnDuration,
      curve: Curves.ease,
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: pageTurnDuration,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 10,
      controller: _pageController,
      // NeverScrollableScrollPhysics disables PageView built-in gestures.
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Center(
          child: SwipeDetector(
            child: Container(
              height: 200,
              width: 300,
              color: Colors.red,
              alignment: Alignment.center,
              child: Text("data$index"),
            ), //Your Widget Tree here
            onSwipeUp: () {
              print("Swipe Up");
            },
            onSwipeDown: () {
              print("Swipe Down");
            },
            onSwipeLeft: () {
              _goForward();
            },
            onSwipeRight: () {
              _goBack();
            },
          ),
        );
      },
    );
  }
}
