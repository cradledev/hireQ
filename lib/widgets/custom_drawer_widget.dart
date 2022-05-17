// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:starappemployee/model/navigation_item.dart';
// import 'package:starappemployee/provider/index.dart';
// import 'package:starappemployee/provider/navigation_provider.dart';
// import 'package:starappemployee/constant/constant.dart';

// class CustomDrawerWidget extends StatelessWidget {
//   static const padding = EdgeInsets.symmetric(horizontal: 20);

//   const CustomDrawerWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Drawer(
//         child: Container(
//           color: appMainColor,
//           child: ListView(
//             children: <Widget>[
//               // buildHeader(
//               //   context,
//               //   urlImage: "urlImage",
//               //   name: "name",
//               //   email: "email",
//               // ),
//               const SizedBox(height: 50),
//               Container(
//                 padding: padding,
//                 child: Column(
//                   children: [
//                     const ListTile(
//                       contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                       title: Text("Reminder",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
//                       child: Column(
//                         children: [
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.dailyprogram,
//                             text: 'Daily Program',
//                           ),
//                           buildMenuItem(context,
//                               item: NavigationItem.bonustarquiz,
//                               text: 'Bonus Star Quiz'),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.leaderboard,
//                             text: 'Leader Board',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.healthscreening,
//                             text: 'Health Screening',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.update,
//                             text: 'Update',
//                             icon: Icons.account_tree_outlined,
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.profileoverview,
//                             text: 'Profile Overview',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.message,
//                             text: 'Message',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.activity,
//                             text: 'Activity',
//                           ),
//                         ],
//                       ),
//                     ),

//                     // const Divider(color: Colors.white70),
//                     const ListTile(
//                       contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                       title: Text("Spreading the brightness",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
//                       child: Column(
//                         children: [
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.theme,
//                             text: 'Theme',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.rateus,
//                             text: 'Rate Us',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.share,
//                             text: 'Share',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.instagram,
//                             text: 'Instagram',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.community,
//                             text: 'Community',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const ListTile(
//                       contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                       title: Text(
//                         "Contact",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
//                       child: Column(
//                         children: [
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.emailus,
//                             text: 'Email Us',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.ourotherapps,
//                             text: 'Our other Apps',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const ListTile(
//                       contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                       title: Text(
//                         "Info",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
//                       child: Column(
//                         children: [
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.troubleshoot,
//                             text: 'Troubleshoot',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.attribution,
//                             text: 'Attribution',
//                           ),
//                           buildMenuItem(
//                             context,
//                             item: NavigationItem.privacypolicy,
//                             text: 'Privacy Policy',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );

//   Widget buildMenuItem(
//     BuildContext context, {
//     NavigationItem item,
//     String text,
//     IconData icon,
//   }) {
//     final provider = Provider.of<NavigationProvider>(context);
//     final currentItem = provider.navigationItem;
//     final isSelected = item == currentItem;

//     final color = isSelected ? Colors.orangeAccent : Colors.white;

//     // return Material(
//     //   color: Colors.transparent,
//     //   child: ListTile(
//     //     selected: isSelected,
//     //     selectedTileColor: Colors.white24,
//     //     // leading: icon != null
//     //     //     ? Icon(icon, color: color)
//     //     //     : const SizedBox(
//     //     //         width: 0,
//     //     //         height: 0,
//     //     //       ),
//     //     title: Text(text,
//     //         style: TextStyle(
//     //             color: color, fontSize: 16, fontWeight: FontWeight.normal)),
//     //     onTap: () => selectItem(context, item),
//     //   ),
//     // );
//     return Material(
//       color: Colors.transparent,
//       child: GestureDetector(
//         onTap: (() => selectItem(context, item)),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // CircleAvatar(
//             //   radius: 20,
//             //   backgroundImage: AssetImage('assets/avatar1.jpg'),
//             // ),
//             Expanded(
//               child: Container(
//                 padding:
//                     const EdgeInsets.only(left: 5, top: 7, bottom: 7, right: 5),
//                 child: Text(
//                   text,
//                   style: TextStyle(
//                       color: color,
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void selectItem(BuildContext context, NavigationItem item) {
//     final provider = Provider.of<NavigationProvider>(context, listen: false);
//     final appState = Provider.of<AppState>(context, listen: false);
//     // if (appState.user == null) {
//     //   appState.notifyToastDanger(
//     //       context: context, message: "Admin must sign up.");
//     // } else {
//     //   provider.setNavigationItem(item);
//     // }
//     provider.setNavigationItem(item);
//     onGoPage(context, item);
//   }

//   void onGoPage(BuildContext context, NavigationItem item) {
//     switch (item) {
//       case NavigationItem.dailyprogram:
//         Navigator.of(context).pushNamed(DAILYPROGRAM_SCREEN);
//         break;
//       case NavigationItem.leaderboard:
//         print("modifying existing quiz");
//         break;
//       default:
//     }
//   }
// //   Widget buildHeader(
// //     BuildContext context, {
// //     String urlImage,
// //     String name,
// //     String email,
// //   }) =>
// //       Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: () => selectItem(context, NavigationItem.header),
// //           child: Container(
// //             padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
// //             child: Row(
// //               children: [
// //                 CircleAvatar(
// //                     radius: 30, backgroundImage: NetworkImage(urlImage)),
// //                 const SizedBox(width: 20),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       name,
// //                       style: const TextStyle(fontSize: 20, color: Colors.white),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       email,
// //                       style: const TextStyle(fontSize: 14, color: Colors.white),
// //                     ),
// //                   ],
// //                 ),
// //                 const Spacer(),
// //                 const CircleAvatar(
// //                   radius: 24,
// //                   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
// //                   child: Icon(Icons.add_comment_outlined, color: Colors.white),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// }
