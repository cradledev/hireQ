import 'dart:convert';

class CompanyModel {
  int id;
  String name;
  int user_id;
  String description;
  String region;
  String phone_number;
  String account_manager_name;
  String uuid;
  CompanyModel({
    this.id,
    this.name,
    this.user_id,
    this.description,
    this.region,
    this.phone_number,
    this.account_manager_name,
    this.uuid
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    String _region = "";
    String _phoneNumber = "";
    if (json['region'] != null) {
      _region = jsonEncode(json['region']);
    }
    if (json['phone_number'] != null) {
      _phoneNumber = jsonEncode(json['phone_number']);
    }
    return CompanyModel(
      id: json['id'],
      name: json['name'] ?? "",
      user_id: json['user_id'],
      description: json['description'] ?? "",
      region: _region,
      phone_number: _phoneNumber,
      account_manager_name: json['account_manager_name'] ?? "",
      uuid: json['uuid']
    );
  }
   Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "user_id": user_id,
      "description": description,
      "region": region,
      "phone_number": phone_number,
      "account_manager_name": account_manager_name,
      "uuid" : uuid
    };
  }
}

