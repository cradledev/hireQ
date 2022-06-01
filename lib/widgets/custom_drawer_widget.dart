import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/home/home_screen.dart';
import 'package:hire_q/screens/lobby/lobby_screen.dart';
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
                  const ListTile(
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    title: Text(
                      "Auth",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
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

                  // const Divider(color: Colors.white70),
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
            //   backgroundImage: AssetImage('assets/avatar1.jpg'),
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
    switch (item) {
      case NavigationItem.logout:
        appState.setLocalStorage(key: "user", value: "");
        appState.user = null;
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
          child: Row(
            children: [
              // CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appState.user != null ? appState.user['email'] : "",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
