import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/models/company_job_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/home/home_screen.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import './widgets/job_card.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key key}) : super(key: key);

  @override
  _JobScreen createState() => _JobScreen();
}

class _JobScreen extends State<JobScreen> {
  // scroll page controller for infinite scroll
  PagingController<int, CompanyJobModel> _pagingController;
  static const PageSize = 4;

  // APPSTATE setting
  AppState appState;

  // API setting
  APIClient api;
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
      var res;
      if (appState.user == null) {
        res = await api.getCompanyJobs(
            pageNum: pageKey + 1, pageLength: PageSize);
      } else {
        if (appState.user['type'] == "company") {
          res = await api.getCompanyJobs(
              pageNum: pageKey + 1, pageLength: PageSize);
        } else {
          res = await api.getCompanyJobsByUserId(
              pageNum: pageKey + 1,
              pageLength: PageSize,
              token: appState.user['jwt_token']);
        }
      }
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
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
      } else {
        List<CompanyJobModel> newItems = [];
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
          builderDelegate: PagedChildBuilderDelegate<CompanyJobModel>(
            itemBuilder: (context, job, index) {
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
                  if (appState.user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("You must log in. Please try it now.",
                          textAlign: TextAlign.center),
                      backgroundColor: Colors.red,
                    ));
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(microseconds: 800),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: const HomeScreen(),
                            );
                          },
                        ),
                        (route) => false);
                  } else if (appState.user['type'] == "company") {
                    if (direction == DismissDirection.up) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Company can't apply the job.",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.orange,
                      ));
                      return false;
                    }
                    return false;
                  } else {
                    if (direction == DismissDirection.up) {
                      Map payloads = {
                        'talent_id': appState.user['id'],
                        'job_id': job.id,
                        'company_id': job.company_id
                      };
                      print(payloads);
                      try {
                        var res = await api.applyCompanyJob(
                            token: appState.user['jwt_token'],
                            payloads: jsonEncode(payloads));
                        print(res.body);
                        if (res.statusCode == 200) {
                          // var body = jsonDecode(res.body);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Successfully applied.",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.green,
                          ));
                          setState(() {
                            _pagingController.itemList.removeAt(index);
                          });
                          return true;
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Unknown Error is occured.",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ));
                          return false;
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Unknown Error is occured.",
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return false;
                      }
                    } else {
                      setState(() {
                        _pagingController.itemList.removeAt(index);
                      });
                      return true;
                    }
                  }
                  return false;
                },
                onDismissed: (DismissDirection direction) {
                  // print("dismissed");
                  // _pagingController.itemList.removeAt(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: JobCard(jobData: job),
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
