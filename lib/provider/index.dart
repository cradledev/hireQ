import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _talentSwipeUp = false;
  //get
  get talentSwipeUp => _talentSwipeUp;

  // set
  set talentSwipeUp(value) {
    _talentSwipeUp = value;
    notifyListeners();
  }

  void notifyToast({context, message}) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void notifyToastDanger({context, message}) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void notifyToastSuccess({context, message}) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  Future<String> loadInterestJsonFile(String assetsPath) async {
    return rootBundle.loadString(assetsPath);
  }

  Future<http.Response> post(url, payload) async {
    var response = await http.post(url, body: payload, headers: {
      "accept": "application/json",
    });

    return response;
  }

  Future<http.Response> postURL(url, payload) async {
    var response = await http.post(url, body: payload, headers: {
      "accept": "application/json",
    });

    return response;
  }

  Future<http.Response> get(url, {context}) async {
    var response = await http.get(url, headers: {"accept": "application/json"});
    if (response.statusCode == 401 && context != null) {
      // Navigator.push(context,
      //     new MaterialPageRoute(builder: (context) => new LoginPage()));
    }

    return response;
  }

  String formatDate(date) {
    return date.toString().split(' ')[0];
  }

  String formatTime(time) {
    return time.toString().split(':')[0] + ':' + time.toString().split(':')[1];
  }
}
