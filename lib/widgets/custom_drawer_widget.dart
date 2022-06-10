import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/provider/jobs_provider.dart';
import 'package:hire_q/screens/home/home_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
import 'package:hire_q/screens/profile/setting/setting_company_screen.dart';
import 'package:hire_q/screens/profile/setting/setting_talent_screen.dart';
import 'package:provider/provider.dart';

import 'package:hire_q/models/navigation_item.dart';
import 'package:hire_q/provider/index.dart';
import 'package:hire_q/provider/navigation_provider.dart';

class CustomDrawerWidget extends StatelessWidget {
  static const padding = EdgeInsets.symmetric(horizontal: 20);

  const CustomDrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Drawer(
      child: Container(
        color: primaryColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
              context,
              urlImage: "urlImage",
              name: "name",
              email: "email",
            ),
            const SizedBox(height: 10),
            Container(
              padding: padding,
              child: Column(
                children: [
                  // const ListTile(
                  //   contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  //   title: Text(
                  //     "Auth",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        appState.user != null
                            ? buildMenuItem(context,
                                item: NavigationItem.setting,
                                text: 'Setting',
                                icon: Icons.settings)
                            : const SizedBox(
                                height: 0,
                              )
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        appState.user == null
                            ? buildMenuItem(context,
                                item: NavigationItem.login,
                                text: 'Log In',
                                icon: Icons.login_outlined)
                            : buildMenuItem(context,
                                item: NavigationItem.logout,
                                text: 'Log out',
                                icon: Icons.logout_outlined),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white70),
                  // const ListTile(
                  //   contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  //   title: Text("Spreading the brightness",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       )),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                  //   child: Column(
                  //     children: [
                  //       buildMenuItem(
                  //         context,
                  //         item: NavigationItem.logout,
                  //         text: 'Theme',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
    BuildContext context, {
    NavigationItem item,
    String text,
    IconData icon,
  }) {
    final provider = Provider.of<NavigationProvider>(context);
    final currentItem = provider.navigationItem;
    final isSelected = item == currentItem;

    final color = isSelected ? Colors.orangeAccent : Colors.white;

    // return Material(
    //   color: Colors.transparent,
    //   child: ListTile(
    //     selected: isSelected,
    //     selectedTileColor: Colors.white24,
    //     // leading: icon != null
    //     //     ? Icon(icon, color: color)
    //     //     : const SizedBox(
    //     //         width: 0,
    //     //         height: 0,
    //     //       ),
    //     title: Text(text,
    //         style: TextStyle(
    //             color: color, fontSize: 16, fontWeight: FontWeight.normal)),
    //     onTap: () => selectItem(context, item),
    //   ),
    // );
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: (() => selectItem(context, item)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // CircleAvatar(
            //   radius: 20,
            //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            // ),
            Expanded(
              child: Row(
                children: [
                  icon != null
                      ? Icon(icon, color: color)
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 5, top: 7, bottom: 7, right: 5),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    // final appState = Provider.of<AppState>(context, listen: false);
    // if (appState.user == null) {
    //   appState.notifyToastDanger(
    //       context: context, message: "Admin must sign up.");
    // } else {
    //   provider.setNavigationItem(item);
    // }
    provider.setNavigationItem(item);
    onGoPage(context, item);
  }

  void onGoPage(BuildContext context, NavigationItem item) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    switch (item) {
      case NavigationItem.logout:
        appState.setLocalStorage(key: "user", value: "");
        appState.setLocalStorage(key: "firebaseuser", value: "");
        appState.removeAllState();
        jobsProvider.removeAll();
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const HomeScreen(),
                );
              },
            ),
            (route) => false);
        break;
      case NavigationItem.login:
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const HomeScreen(),
                );
              },
            ),
            (route) => false);
        break;
      case NavigationItem.setting:
        if (appState.user['type'] == "company") {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const SettingCompanyScreen(),
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const SettingTalentScreen(),
                );
              },
            ),
          );
        }

        break;
      case NavigationItem.header:
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(microseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const LobbyScreen(
                    indexTab: 3,
                  ),
                );
              },
            ),
            (route) => false);
        break;
      default:
        break;
    }
  }

  Widget buildHeader(
    BuildContext context, {
    String urlImage,
    String name,
    String email,
  }) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => selectItem(context, NavigationItem.header),
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Column(
            children: [
              Consumer<AppState>(
                builder: (context, _pAppState, child) {
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: CachedNetworkImage(
                        width: 110,
                        height: 110,
                        imageUrl: _pAppState.profile == null
                            ? 'https://via.placeholder.com/150'
                            : ((_pAppState.profile).avator == null ||
                                    (_pAppState.profile).avator == "")
                                ? 'https://via.placeholder.com/150'
                                : _pAppState.hostAddress +
                                    (_pAppState.profile).avator,
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
                  );
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        appState.user != null ? appState.user['email'] : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appState.user != null ? appState.user['type'] : "",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              // const Spacer(),
              // const CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
