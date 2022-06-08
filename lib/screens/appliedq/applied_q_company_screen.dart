import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/api.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/models/applied_job_model.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/screens/detail_board/job_detail_company_board.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';

import 'package:hire_q/widgets/common_widget.dart';
import 'package:hire_q/widgets/custom_drawer_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class AppliedQCompanyScreen extends StatefulWidget {
  const AppliedQCompanyScreen({Key key}) : super(key: key);
  @override
  _AppliedQCompanyScreen createState() => _AppliedQCompanyScreen();
}

class _AppliedQCompanyScreen extends State<AppliedQCompanyScreen> {
  int currentPage = 3;
  // search text controller
  TextEditingController _searchTextController;
  // App state setting
  AppState appState;

  // api setting
  APIClient api;

  // scroll page controller for infinite scroll
  PagingController<int, AppliedJobModel> _pagingController;
  static const PageSize = 2;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  // custom init func
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
      var res = await api.getComprehensiveJobsInfoForCompanyJobs(
          companyId: appState.company.id,
          pageNum: pageKey + 1,
          pageLength: PageSize,
          token: appState.user['jwt_token']);

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List<AppliedJobModel> newItems = (body as List)
            .map((element) => AppliedJobModel.fromJson(element))
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
        List<AppliedJobModel> newItems = [];
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
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIcon: const Icon(
            CupertinoIcons.line_horizontal_3,
            size: 40,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          // leadingAction: () {
          // },
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
        body: Container(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Applied Q",
                      style: TextStyle(fontSize: 26, color: primaryColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.forward),
                      color: primaryColor,
                      iconSize: 30,
                    )
                  ],
                ),
              ),
              Expanded(
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
                    builderDelegate: PagedChildBuilderDelegate<AppliedJobModel>(
                      itemBuilder: (context, _perItem, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            onTap: () {
                              onGotoDetail(_perItem);
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(3.0),
                              child: CachedNetworkImage(
                                width: 64,
                                height: 64,
                                imageUrl: _perItem.company_logo == null
                                    ? "https://via.placeholder.com/150"
                                    : appState.hostAddress +
                                        _perItem.company_logo,
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
                            title: Text(
                              _perItem?.title ?? "No title",
                              style: const TextStyle(color: primaryColor),
                            ),
                            subtitle: Text(
                                _perItem?.company_name ?? "No Company name"),
                            trailing: Chip(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: primaryColor,
                              label: Text(
                                _perItem?.appliedtalents_count?.toString() ??
                                    "0",
                                style: const TextStyle(color: Colors.white),
                              ),
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

  // when click per item, it goes to detail page including shortlist, applied q counts for per job for self company
  void onGotoDetail(AppliedJobModel _pAppliedJob) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: JobDetailCompanyBoard(selectedCompanyJob: _pAppliedJob),
          );
        },
      ),
    );
  }
}
