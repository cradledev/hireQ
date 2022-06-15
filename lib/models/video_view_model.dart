import 'dart:convert';

class VideoViewModel {
  int id;
  String name;
  int user_id;
  String description;
  String region;
  String phone_number;
  String account_manager_name;
  String uuid;
  String company;
  String current_jobDescription;
  String current_jobTitle;
  String education;
  String first_name;
  String last_name;
  String resume;
  String talent_logo;
  String type;
  int video_id;
  int view_count;
  String years_experience;
  String company_logo;
  String video;

  VideoViewModel({
    this.id,
    this.name,
    this.user_id,
    this.description,
    this.region,
    this.phone_number,
    this.account_manager_name,
    this.uuid,
    this.company,
    this.current_jobDescription,
    this.current_jobTitle,
    this.education,
    this.first_name,
    this.last_name,
    this.resume,
    this.talent_logo,
    this.type,
    this.video_id,
    this.view_count,
    this.years_experience,
    this.company_logo,
    this.video
  });
  factory VideoViewModel.fromJson(Map<String, dynamic> json) {
    String _region = "";
    String _phoneNumber = "";
    if (json['region'] != null) {
      _region = jsonEncode(json['region']);
    }
    if (json['phone_number'] != null) {
      _phoneNumber = jsonEncode(json['phone_number']);
    }
    return VideoViewModel(
      id: json['id'],
      name: json['name'] ?? "",
      user_id: json['user_id'],
      description: json['description'] ?? "",
      region: _region,
      phone_number: _phoneNumber,
      account_manager_name: json['account_manager_name'] ?? "",
      uuid: json['uuid'] ?? "",
      company: json['company'],
      current_jobDescription: json['current_jobDescription'] ?? "",
      current_jobTitle: json['current_jobTitle'] ?? "",
      education: json['education'] ?? "",
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      resume: json['resume'] ?? "",
      talent_logo: json['talent_logo'] ?? "",
      type: json['type'] ?? "talent",
      video_id: json['video_id'],
      view_count: json['view_count'],
      years_experience: json['years_experience'] ?? "",
      company_logo: json['company_logo'] ?? "",
      video: json['video'] ?? ""
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
      "uuid" : uuid,
      "company" : company,
      "current_jobDescription" : current_jobDescription,
      "current_jobTitle" : current_jobTitle,
      "eduction" : education, 
      "first_name" : first_name,
      "last_name" : last_name,
      "resume" : resume,
      "talent_logo" : talent_logo,
      "type" : type,
      "video_id" : video_id,
      "view_count" : view_count,
      "years_experience" : years_experience,
      "company_logo" : company_logo,
      "video" : video
    };
  }
}

