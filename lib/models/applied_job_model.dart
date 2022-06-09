import 'dart:convert';

class AppliedJobModel {
  int id;
  int appliedtalents_count;
  int company_id;
  String company_logo;
  String company_name;
  String company_video;
  String created_at;
  String department;
  String description;
  String education;
  String experience_year;
  String job_status;
  String modified_at;
  String region;
  List roles;
  String salary;
  int shortlisttalents_count;
  String title;

  AppliedJobModel({
    this.id,
    this.appliedtalents_count,
    this.company_id,
    this.company_logo,
    this.company_name,
    this.company_video,
    this.created_at,
    this.department,
    this.description,
    this.education,
    this.experience_year,
    this.job_status,
    this.modified_at,
    this.region,
    this.roles,
    this.salary,
    this.shortlisttalents_count,
    this.title
  });
  factory AppliedJobModel.fromJson(Map<String, dynamic> json) {
    String _region = "";
    if (json['region'] != null) {
      _region = jsonEncode(json['region']);
    }
    return AppliedJobModel(
      id: json['id'],
      appliedtalents_count : json['appliedtalents_count'],
      company_id : json['company_id'],
      company_logo : json['company_logo'],
      company_name : json['company_name'],
      company_video : json['company_video'],
      created_at : json['created_at'],
      department : json['department'],
      description : json['description'],
      education : json['education'],
      experience_year : json['experience_year'],
      job_status : json['job_status'],
      modified_at : json['modified_at'],
      region : _region,
      roles : json['roles'] ?? [],
      salary : json['salary'],
      shortlisttalents_count : json['shortlisttalents_count'],
      title  : json['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "appliedtalents_count" : appliedtalents_count,
      "company_id" : company_id,
      "company_logo" : company_logo,
      "company_name" : company_name,
      "company_video" : company_video,
      "created_at" : created_at,
      "department" : department,
      "description" : description,
      "education" : education,
      "experience_year" : experience_year,
      "job_status" : job_status,
      "modified_at" : modified_at,
      "region" : region,
      "roles" : roles,
      "salary" : salary,
      "shortlisttalents_count" : shortlisttalents_count,
      "title"  : title,
    };
  }
}
