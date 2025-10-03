class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({this.uid = '', this.email = '', this.name = ''});

  bool get isLoggedIn => uid.isNotEmpty;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': uid, 'email': email, 'name': name};
  }
}
