import 'dart:convert';

class CompanyJobModel {
  int id;
  int company_id;
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
  String title;
  String company_logo;
  String company_name;
  String company_video;

  CompanyJobModel({
    this.id,
    this.company_id,
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
    this.title,
    this.company_logo,
    this.company_name,
    this.company_video
  });
  factory CompanyJobModel.fromJson(Map<String, dynamic> json) {
    String _region = "";
    if (json['region'] != null) {
      _region = jsonEncode(json['region']);
    }
    return CompanyJobModel(
      id: json['id'],
      company_id: json['company_id'] ?? "",
      created_at: json['created_at'] ?? "",
      department: json['department'] ?? "",
      description: json['description'] ?? "",
      education: json['education'] ?? "",
      experience_year: json['experience_year'] ?? "",
      job_status: json['job_status'] ?? "",
      modified_at: json['modified_at'] ?? "",
      region: _region,
      roles: json['roles'] ?? [],
      salary: json['salary'] ?? "",
      title: json['title'] ?? "",
      company_logo : json['company_logo'] ?? "",
      company_name : json['company_name'] ?? "",
      company_video: json['company_video'] ?? ""
    );
  }
}

