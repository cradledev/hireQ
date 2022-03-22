import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_q/widgets/common_widget.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreen createState() => _MessageScreen();
}

class _MessageScreen extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[Text("data")],
          ),
        ),
      ),
    );
  }
}
