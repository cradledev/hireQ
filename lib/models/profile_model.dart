import 'dart:convert';

class ProfileModel {
  int id;
  String avator;
  int user_id;
  String resume;
  int video_id;
  String video;
  String job;
  String work_history;
  String type;
  ProfileModel({
    this.id,
    this.avator,
    this.user_id,
    this.resume,
    this.video_id,
    this.video,
    this.job,
    this.work_history,
    this.type
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String _job = "";
    String _workHistory = "";
    if (json['job'] != null) {
      _job = jsonEncode(json['job']);
    }
    if (json['work_history'] != null) {
      _workHistory = jsonEncode(json['work_history']);
    }
    return ProfileModel(
      id: json['id'],
      avator: json['avator'] ?? "",
      user_id: json['user_id'] ?? "",
      resume: json['resume'] ?? "",
      video_id: json['video_id'] ?? "",
      video: json['video'] ?? "",
      job: _job,
      work_history: _workHistory,
      type : json['type'] ?? ""
    );
  }
}

