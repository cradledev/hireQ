import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // end point url
  final String _endpoint = 'http://192.168.116.39:5000/api/v1/';
  // is talent? flag
  bool _talentSwipeUp = false;
  bool _isTalent = true;
  // sign up and login User type : "company" or "talent"
  String _entryType = "talent";
  // user data
  Map _user;
  //get
  get talentSwipeUp => _talentSwipeUp;
  get isTalent => _isTalent;
  get user => _user;
  get endpoint => _endpoint;
  get entryType => _entryType;
  // set
  set talentSwipeUp(value) {
    _talentSwipeUp = value;
    notifyListeners();
  }

  set isTalent(value) {
    _isTalent = value;
    notifyListeners();
  }

  set entryType(value) {
    _entryType = value;
    notifyListeners();
  }

  set user(value) {
    _user = value;
    notifyListeners();
  }

  void notifyToast({context, message}) {
    ToastContext().init(context);
    Toast.show(message, duration: Toast.lengthLong, gravity: Toast.center);
  }

  void notifyToastDanger({context, message}) {
    ToastContext().init(context);
    Toast.show(message,
        duration: Toast.lengthLong,
        gravity: Toast.center,
        backgroundColor: Colors.red,
        webTexColor: Colors.white);
  }

  void notifyToastSuccess({context, message}) {
    ToastContext().init(context);
    Toast.show(message,
        duration: Toast.lengthLong,
        gravity: Toast.center,
        backgroundColor: Colors.green,
        webTexColor: Colors.white);
  }

  Future<String> loadInterestJsonFile(String assetsPath) async {
    return rootBundle.loadString(assetsPath);
  }

  Future<http.Response> post(url, payload) async {
    var response = await http.post(url,
        body: payload,
        headers: {"content-type": "application/json", "accept": "*/*"});

    return response;
  }

  Future<http.Response> postWithToken(url, payload) async {
    var response = await http.post(url, body: payload, headers: {
      "content-type": "application/json",
      "accept" : "*/*",
      "api-token" : user['jwt_token']
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

  Future setLocalStorage({key, value, type = "string"}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (type == "string") {
      await _prefs.setString(key, value);
    }
    if (type == "int") {
      await _prefs.setInt(key, value);
    }
    
    notifyListeners();
  }

  Future<String> getLocalStorage(key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _temp = _prefs.getString(key) ?? "";
    return _temp;
  }
}
