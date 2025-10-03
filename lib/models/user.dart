class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({this.uid = '', this.email = '', this.name = ''});

  bool get isLoggedIn => uid.isNotEmpty;
}
