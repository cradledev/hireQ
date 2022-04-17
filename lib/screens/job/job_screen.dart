import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/models/job_model.dart';
import 'package:hire_q/provider/index.dart';

import 'package:hire_q/widgets/swipe_detector.dart';
import 'package:provider/provider.dart';

import './widgets/job_card.dart';
// import home page
import 'package:hire_q/screens/home/home_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key key}) : super(key: key);

  @override
  _JobScreen createState() => _JobScreen();
}

class _JobScreen extends State<JobScreen> {
  PageController _pageController;
  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  // talent data
  List<JobModel> _talents;
  // import provider
  @override
  void initState() {
    super.initState();
    _init();
    // The PageController allows us to instruct the PageView to change pages.
    _pageController = PageController();
  }

  void _init() {
    _talents = JobModel.dumpListData;
  }

  void _goForward() {
    _pageController.nextPage(
      duration: pageTurnDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: pageTurnDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: ((context, value, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Image.asset(
                        value.talentSwipeUp
                            ? 'assets/icons/up.png'
                            : 'assets/icons/down.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              PageView.builder(
                itemCount: _talents.length,
                controller: _pageController,
                // NeverScrollableScrollPhysics disables PageView built-in gestures.
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SwipeDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: JobCard(
                          buildContext: context, jobData: _talents[index]),
                    ), //Your Widget Tree here
                    onSwipeUp: () {
                      print("Swipe Up");
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 800),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: const HomeScreen(),
                              );
                            },
                          ),
                          (Route<dynamic> route) => false);
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
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
