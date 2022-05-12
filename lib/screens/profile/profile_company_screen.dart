import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/widgets/common_widget.dart';

import 'package:steps_indicator/steps_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

class ProfileCompanyScreen extends StatefulWidget {
  const ProfileCompanyScreen({Key key}) : super(key: key);

  @override
  _ProfileCompanyScreen createState() => _ProfileCompanyScreen();
}

class _ProfileCompanyScreen extends State<ProfileCompanyScreen> {
  int selectedStep = 2;
  int nbSteps = 5;
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };
  List<Color> colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedStep = 2;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35 * 4 / 6 +
                    MediaQuery.of(context).size.height * 0.33 * 2 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          height:
                              MediaQuery.of(context).size.height * 0.35 * 4 / 6,
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
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
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          height:
                              MediaQuery.of(context).size.height * 0.33 * 2 / 5,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          color: const Color(0xffEFF2F2),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Profile Status",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 22),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Completed : 50%',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: StepsIndicator(
                                  selectedStep: selectedStep,
                                  nbSteps: nbSteps,
                                  selectedStepColorOut: primaryColor,
                                  selectedStepColorIn: Colors.white,
                                  unselectedStepColorIn: accentColor,
                                  unselectedStepColorOut: accentColor,
                                  doneStepColor: primaryColor,
                                  doneLineColor: primaryColor,
                                  undoneLineColor: accentColor,
                                  isHorizontal: true,
                                  doneStepSize: 10,
                                  unselectedStepSize: 10,
                                  selectedStepSize: 14,
                                  selectedStepBorderSize: 1,
                                  // doneStepWidget: Container(), // Custom Widget
                                  // unselectedStepWidget: Container(), // Custom Widget
                                  selectedStepWidget: const CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 12,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ), // Custom Widget
                                  lineLength:
                                      MediaQuery.of(context).size.width * 0.12,
                                  // lineLengthCustomStep: [
                                  //   StepsIndicatorCustomLine(nbStep: 4, length: 105)
                                  // ],
                                  enableLineAnimation: true,
                                  enableStepAnimation: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          height:
                              MediaQuery.of(context).size.height * 0.35 * 4 / 6,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                          child: const Image(
                                            image: AssetImage(
                                                "assets/icons/Gold.png"),
                                            height: 35.0,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            "Q Gold",
                                            style: TextStyle(
                                              color: Color(0xffbea06a),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: const [
                                    CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        "@ Aramco",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "aramco",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: OutlineButtonCustomWithIcon(
                                  onTap: () {},
                                  text: "edit",
                                  height: 35,
                                  image: "assets/icons/edit.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 15, left: 15, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: const Image(
                            image: AssetImage("assets/icons/Play.png"),
                            height: 35.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.33 * 2 / 5,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: accentColor),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color(0xffC8D3D5),
                          child: Image(
                            image: AssetImage("assets/icons/Creat video.png"),
                            height: 22.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Create Video",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color(0xffC8D3D5),
                          child: Image(
                            image: AssetImage("assets/icons/message.png"),
                            height: 22.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Message",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color(0xffC8D3D5),
                          child: Image(
                            image: AssetImage("assets/icons/upload file.png"),
                            height: 22.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Upload File",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: accentColor),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dash Q View",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text("Three Figures",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                )),
                            content: Padding(
                              padding: EdgeInsets.zero,
                              child: PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius: math.min(
                                    MediaQuery.of(context).size.width / 3.2,
                                    70),
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.disc,
                                ringStrokeWidth: 32,
                                centerText: null,

                                legendOptions: const LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: false,
                                  // legendShape: _BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                              ),
                            ),
                            backgroundColor: const Color(0xffEFF2F2),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Video Views",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 16,
                              ),
                            ),
                            content: const Text(
                              "487",
                              style:
                                  TextStyle(color: accentColor, fontSize: 40),
                            ),
                            backgroundColor: primaryColor,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Applied Q",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            content: const Text(
                              "25",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                            backgroundColor: secondaryColor,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: ReusableCard(
                            title: const Text(
                              "Jobs Q",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            content: const Text(
                              "5",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 40),
                            ),
                            backgroundColor: accentColor,
                            onTap: () {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Jobs",
                        style: TextStyle(color: primaryColor, fontSize: 22),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              // color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const ListTile(
                                title: Text(
                                  "Location",
                                  style: TextStyle(color: primaryColor),
                                ),
                                subtitle: Text(
                                  "Jeddah",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        // padding: EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
