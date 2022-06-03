class AppliedJobModel {
  int id;
  int talent_id;
  int job_id;
  String applied_at;

  AppliedJobModel({this.id, this.talent_id, this.job_id, this.applied_at});
  factory AppliedJobModel.fromJson(Map<String, dynamic> json) {
    return AppliedJobModel(
        id: json['id'],
        talent_id: json['talent_id'],
        job_id: json['job_id'],
        applied_at: json['applied_at'] ?? "");
  }
}
