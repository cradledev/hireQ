import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/models/company_job_model.dart';
import 'package:hire_q/models/job_model.dart';
import 'package:hire_q/provider/index.dart';

import 'package:hire_q/widgets/swipe_detector.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  // scroll page controller for infinite scroll
  PagingController<int, CompanyJobModel> _pagingController;
  static const PageSize = 5;

  // APPSTATE setting
  AppState appState;

  // API setting
  APIClient api;

  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  // talent data
  List<JobModel> _talents;
  // import provider
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    // app state init
    appState = Provider.of<AppState>(context, listen: false);
    // API instance
    api = APIClient();

    // The PageController allows us to instruct the PageView to change pages.
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  // fetch job data with pagination
  Future<void> _fetchPage(int pageKey) async {
    try {
      var res =
          await api.getCompanyJobs(pageNum: pageKey, pageLength: PageSize);
      var body = jsonDecode(res.body);
      print(body);
      List<CompanyJobModel> newItems = (body as List)
          .map((element) => CompanyJobModel.fromJson(element))
          .toList();
      final isLastPage = newItems.length < PageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }

  // void _goForward() {
  //   _pagingController.nextPage(
  //     duration: pageTurnDuration,
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  // void _goBack() {
  //   _pagingController.previousPage(
  //     duration: pageTurnDuration,
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ChangeNotifierProvider(
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
                PagedListView.separated(
                  pagingController: _pagingController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  builderDelegate: PagedChildBuilderDelegate<CompanyJobModel>(
                    itemBuilder: (context, job, index) {
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
                        // print("Swipe Down");
                      },
                      onSwipeLeft: () {
                        // _goForward();
                      },
                      onSwipeRight: () {
                        // _goBack();
                      },
                    );
                    },
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: const Text('Retry'),
                                  onPressed: () => _pagingController.refresh())
                            ],
                          )),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No Items Found'),
                            ],
                          )),
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                ),
                // PageView.builder(
                //   itemCount: _talents.length,
                //   controller: _pagingController,
                //   // NeverScrollableScrollPhysics disables PageView built-in gestures.
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     return SwipeDetector(
                //       child: Container(
                //         width: MediaQuery.of(context).size.width,
                //         height: MediaQuery.of(context).size.height * 0.8,
                //         padding: const EdgeInsets.symmetric(horizontal: 20),
                //         // decoration: BoxDecoration(
                //         //     borderRadius: BorderRadius.all(Radius.circular(50))),
                //         child: JobCard(
                //             buildContext: context, jobData: _talents[index]),
                //       ), //Your Widget Tree here
                //       onSwipeUp: () {
                //         print("Swipe Up");
                //         Navigator.pushAndRemoveUntil(
                //             context,
                //             PageRouteBuilder(
                //               transitionDuration:
                //                   const Duration(milliseconds: 800),
                //               pageBuilder:
                //                   (context, animation, secondaryAnimation) {
                //                 return FadeTransition(
                //                   opacity: animation,
                //                   child: const HomeScreen(),
                //                 );
                //               },
                //             ),
                //             (Route<dynamic> route) => false);
                //       },
                //       onSwipeDown: () {
                //         print("Swipe Down");
                //       },
                //       onSwipeLeft: () {
                //         _goForward();
                //       },
                //       onSwipeRight: () {
                //         _goBack();
                //       },
                //     );
                //   },
                // )
              ],
            );
          }),
        ),
      ),
    );
  }
}
