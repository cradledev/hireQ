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
  String talent_logo;
  int video_id;
  String resume;
  bool is_shortlist;
  int applied_job_id;
  String uuid;

  TalentModel({
    this.id,
    this.user_id,
    this.first_name,
    this.last_name,
    this.phone_number,
    this.region,
    this.current_jobTitle,
    this.current_jobDescription,
    this.company,
    this.talent_logo,
    this.video_id,
    this.is_shortlist,
    this.applied_job_id,
    this.resume,
    this.uuid
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
      talent_logo : json['talent_logo'] ?? "",
      video_id: json['video_id'],
      resume: json['resume'] ?? "",
      is_shortlist: json['is_shortlist'] ?? false,
      applied_job_id: json['appliedjob_id'],
      uuid: json['uuid']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": user_id,
      "first_name": first_name,
      "last_name": last_name,
      "region": region,
      "phone_number": phone_number,
      "current_jobTitle": current_jobTitle,
      "current_jobDescription": current_jobDescription,
      "company": company,
      "talent_logo": talent_logo,
      "video_id": video_id,
      "resume" : resume,
      "uuid" : uuid
    };
  }
}

