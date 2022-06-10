import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/applied_job_model.dart';
import 'package:hire_q/models/talent_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/screens/detail_board/job_detail_company_board.dart';
import 'package:hire_q/screens/detail_board/talent_detail_board.dart';
import 'package:hire_q/screens/jobsq/jobs_q_company_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ConsiderTalentListBoard extends StatefulWidget {
  const ConsiderTalentListBoard(
      {Key key,
      this.type,
      this.jobId,
      this.shortlistSourceFrom = "",
      this.sourceFromDetailCompany = ""})
      : super(key: key);
  final String type;
  final int jobId;
  final String sourceFromDetailCompany;
  final String shortlistSourceFrom;
  @override
  _ConsiderTalentListBoard createState() => _ConsiderTalentListBoard();
}

class _ConsiderTalentListBoard extends State<ConsiderTalentListBoard> {
  int currentPage = 3;
  // search text controller
  TextEditingController _searchTextController;

  // Appstate setting
  AppState appState;

  // API setting
  APIClient api;

  // scroll page controller for infinite scroll
  PagingController<int, TalentModel> _pagingController;
  static const PageSize = 2;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // custom init function
  void onInit() async {
    appState = Provider.of<AppState>(context, listen: false);
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
      if (widget.type == "shortlist") {
        res = await api.getTalentsShortlistForPerJob(
            jobId: widget.jobId,
            pageLength: PageSize,
            pageNum: pageKey + 1,
            token: appState.user['jwt_token']);
      } else {
        res = await api.getTalentsAppliedForPerJob(
            jobId: widget.jobId,
            pageLength: PageSize,
            pageNum: pageKey + 1,
            token: appState.user['jwt_token']);
      }

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

  // go to previous page (job detail company board page)
  void onPreviousPage() async {
    AppliedJobModel _selectedAppliedJob =
        Provider.of<JobsProvider>(context, listen: false)
            .currentSelectedAppliedJob;
    if (widget.shortlistSourceFrom == "profile") {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(microseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: const JobsQCompanyScreen(),
              );
            }),
      );
    } else {
      if (widget.sourceFromDetailCompany == "profile") {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: JobDetailCompanyBoard(
                    selectedCompanyJob: _selectedAppliedJob,
                    sourceFrom: "profile",
                  ),
                );
              }),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: JobDetailCompanyBoard(
                    selectedCompanyJob: _selectedAppliedJob,
                  ),
                );
              }),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIcon: const Icon(
            CupertinoIcons.arrow_left,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          leadingAction: () {
            onPreviousPage();
          },
          leadingFlag: true,
          actionEvent: () {},
          actionFlag: true,
          actionIcon: const Icon(
            CupertinoIcons.bell_fill,
            size: 30,
            color: Colors.white,
          ),
          title: AppbarSearchFormField(
            obsecureText: false,
            textInputType: TextInputType.text,
            prefixIcon: const Icon(
              CupertinoIcons.search,
              color: secondaryColor,
            ),
            maxLines: 1,
            textInputAction: TextInputAction.done,
            suffixIcon: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: secondaryColor,
            ),
            controller: _searchTextController,
          ),
        ),
        drawer: const CustomDrawerWidget(),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: CupertinoIcons.briefcase_fill, title: "Job"),
            TabData(iconData: CupertinoIcons.person_3_fill, title: "Talent"),
            TabData(
                iconData: CupertinoIcons.chat_bubble_2_fill, title: "Messages"),
            TabData(iconData: CupertinoIcons.person_fill, title: "Profile")
          ],
          onTabChangedListener: (position) {
            currentPage = position;
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 800),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: LobbyScreen(indexTab: currentPage),
                  );
                },
              ),
            );
          },
          initialSelection: currentPage,
          activeIconColor: Colors.white,
          circleColor: primaryColor,
          textColor: primaryColor,
          inactiveIconColor: Colors.grey,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   icon: const Icon(CupertinoIcons.arrow_left),
                    //   color: primaryColor,
                    //   iconSize: 30,
                    // ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.type == "shortlist"
                              ? "Shortlisted Talents"
                              : "Applied Talents",
                          style: const TextStyle(
                              fontSize: 26, color: primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () {
                      _pagingController.refresh();
                      setState(() {});
                    },
                  ),
                  child: PagedListView.separated(
                    pagingController: _pagingController,
                    padding: const EdgeInsets.all(16),
                    builderDelegate: PagedChildBuilderDelegate<TalentModel>(
                      itemBuilder: (context, _perItem, index) {
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
                                    child: TalentDetailBoard(
                                      data: _perItem,
                                      type: widget.type,
                                      shortlistSourceFrom:
                                          widget.shortlistSourceFrom,
                                      sourceFromDetailCompany:
                                          widget.sourceFromDetailCompany,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            // decoration: BoxDecoration(
                            //   border:
                            //           Border.all(width: 5, color: Colors.white),
                            //   color: Colors.white,
                            //   boxShadow: const [
                            //     BoxShadow(
                            //           color: Colors.black12,
                            //           blurRadius: 20,
                            //           offset: Offset(5, 5),
                            //         )
                            //   ]
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: CachedNetworkImage(
                                    width: 64,
                                    height: 64,
                                    imageUrl: _perItem.talent_logo.isEmpty
                                        ? "https://via.placeholder.com/150"
                                        : appState.hostAddress +
                                            _perItem.talent_logo,
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: 68,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: accentColor),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            _perItem.first_name +
                                                " " +
                                                _perItem.last_name,
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Text(
                                            jsonDecode(
                                                _perItem.region)['country'],
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
                            )),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
