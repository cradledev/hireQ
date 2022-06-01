class UserModel {
  int id;
  String email;
  String type;
  String token;
  UserModel({
    this.id,
    this.email,
    this.type,
    this.token
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      id: json['id'],
      email: json['email'] ?? "",
      type: json['type'] ?? "",
      token: json['token'] ?? ""
    );
  }
}
