import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';

import 'package:provider/provider.dart';

// infinite scroll
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import './widgets/talent_card.dart';

class TalentScreen extends StatefulWidget {
  const TalentScreen({Key key}) : super(key: key);

  @override
  _TalentScreen createState() => _TalentScreen();
}

class _TalentScreen extends State<TalentScreen> {
  // scroll page controller for infinite scroll
  PagingController<int, TalentModel> _pagingController;
  static const PageSize = 10;

  // import provider
  AppState appState;

  // API Client setting
  APIClient api;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // App state init
    appState = Provider.of<AppState>(context, listen: false);
    // API init
    api = APIClient();

    // The PageController allows us to instruct the PageView to change pages.
    _pagingController = PagingController(firstPageKey: 0);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    try {
      var res = await api.getTalentsWithPagination(pageLength: 5, pageNum: 1);
      var body = jsonDecode(res.body);
    } catch (e) {
      print(e);
    }
  }

  // fetch job data with pagination
  Future<void> _fetchPage(int pageKey) async {
    try {
      var res = await api.getTalentsWithPagination(
          pageNum: pageKey + 1, pageLength: PageSize);
      // if (appState.user == null) {
      //   res = await api.getTalentsWithPagination(pageNum: pageKey + 1, pageLength: PageSize);
      // } else {
      //   if (appState.user['type'] == "company") {
      //     res = await api.getCompanyJobs(pageNum: pageKey + 1, pageLength: PageSize);
      //   } else {
      //     res = await api.getCompanyJobsByUserId(pageNum: pageKey + 1, pageLength: PageSize, token: appState.user['jwt_token']);
      //   }
      // }
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List<TalentModel> newItems = (body as List)
            .map((element) => TalentModel.fromJson(element))
            .toList();
        final isLastPage = newItems.length < PageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
        setState(() {});
      } else {
        List<TalentModel> newItems = [];
        _pagingController.appendLastPage(newItems);
        setState(() {});
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: PagedListView.separated(
          pagingController: _pagingController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          builderDelegate: PagedChildBuilderDelegate<TalentModel>(
            itemBuilder: (context, talent, index) {
              return Dismissible(
                background: Consumer<AppState>(
                  builder: (context, value, child) {
                    return Center(
                      child: Container(
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
                    );
                  },
                ),
                key: UniqueKey(),
                direction: DismissDirection.vertical,
                onUpdate: (DismissUpdateDetails updateDetail) {
                  // print(updateDetail.direction);
                  if (updateDetail.direction == DismissDirection.up) {
                    appState.talentSwipeUp = true;
                  } else {
                    appState.talentSwipeUp = false;
                  }
                },
                confirmDismiss: (DismissDirection direction) async {
                  return true;
                  // if (appState.user == null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("You must log in. Please try it now.",
                  //         textAlign: TextAlign.center),
                  //     backgroundColor: Colors.red,
                  //   ));
                  //   Navigator.pushAndRemoveUntil(
                  //       context,
                  //       PageRouteBuilder(
                  //         transitionDuration: const Duration(microseconds: 800),
                  //         pageBuilder:
                  //             (context, animation, secondaryAnimation) {
                  //           return FadeTransition(
                  //             opacity: animation,
                  //             child: const HomeScreen(),
                  //           );
                  //         },
                  //       ),
                  //       (route) => false);
                  // } else if (appState.user['type'] == "company") {
                  //   if (direction == DismissDirection.up) {
                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //       content: Text(
                  //         "Company can't apply the job.",
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       backgroundColor: Colors.orange,
                  //     ));
                  //     return false;
                  //   }
                  //   return true;
                  // } else {
                  //   if (direction == DismissDirection.up) {
                  //     Map payloads = {
                  //       'talent_id': appState.user['id'],
                  //       'job_id': job.id,
                  //       'company_id': job.company_id
                  //     };
                  //     print(payloads);
                  //     try {
                  //       var res = await api.applyCompanyJob(
                  //           token: appState.user['jwt_token'],
                  //           payloads: jsonEncode(payloads));
                  //       print(res.body);
                  //       if (res.statusCode == 200) {
                  //         // var body = jsonDecode(res.body);
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text(
                  //             "Successfully applied.",
                  //             textAlign: TextAlign.center,
                  //           ),
                  //           backgroundColor: Colors.green,
                  //         ));
                  //       } else {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text(
                  //             "Unknown Error is occured.",
                  //             textAlign: TextAlign.center,
                  //           ),
                  //           backgroundColor: Colors.red,
                  //         ));
                  //         return false;
                  //       }
                  //     } catch (e) {
                  //       ScaffoldMessenger.of(context)
                  //           .showSnackBar(const SnackBar(
                  //         content: Text(
                  //           "Unknown Error is occured.",
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         backgroundColor: Colors.red,
                  //       ));
                  //       return false;
                  //     }
                  //   }
                  //   return true;
                  // }
                  // return false;
                },
                onDismissed: (DismissDirection direction) {
                  print("dismissed");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: TalentCard(talentData: talent),
                ),
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
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('No Items Found'),
                  ],
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            width: 16,
          ),
        ),
      ),
    );
  }
}
