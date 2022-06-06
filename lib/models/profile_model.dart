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
    List _job = json['job'] as List;
    List _workHistory = json['work_history'] as List;
    return ProfileModel(
      id: json['id'],
      avator: json['avator'],
      user_id: json['user_id'],
      resume: json['resume'],
      video_id: json['video_id'],
      video: json['video'],
      job: _job.isEmpty ? null : jsonEncode(_job),
      work_history: _workHistory.isEmpty ? null : jsonEncode(_workHistory),
      type : json['type'] ?? ""
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "avator": avator,
      "user_id": user_id,
      "resume": resume,
      "video_id": video_id,
      "video": video,
      "job": job,
      "work_history": work_history,
      "type" : type
    };
  }
}

