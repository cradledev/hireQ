import 'dart:convert';

class TalentModel {
  int id;
  int user_id;
  String first_name;
  String last_name;
  String phone_number;
  String region;
  String current_jobTitle;
  String current_jobDescription;
  String company;

  TalentModel({
    this.id,
    this.user_id,
    this.first_name,
    this.last_name,
    this.phone_number,
    this.region,
    this.current_jobTitle,
    this.current_jobDescription,
    this.company
  });
  factory TalentModel.fromJson(Map<String, dynamic> json) {
    String _region = "";
    String _phoneNumber = "";
    if (json['region'] != null) {
      _region = jsonEncode(json['region']);
    }
    if (json['phone_number'] != null) {
      _phoneNumber = jsonEncode(json['phone_number']);
    }
    return TalentModel(
      id: json['id'],
      user_id: json['user_id'] ?? "",
      first_name : json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      region: _region,
      phone_number: _phoneNumber,
      current_jobTitle: json['current_jobTitle'] ?? "",
      current_jobDescription: json['current_jobDescription'] ?? "",
      company: json['company'] ?? "",

    );
  }
}

