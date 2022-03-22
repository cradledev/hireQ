import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/widgets/common_widget.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key key}) : super(key: key);

  @override
  _JobScreen createState() => _JobScreen();
}

class _JobScreen extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[Text("job")],
          ),
        ),
      ),
    );
  }
}
