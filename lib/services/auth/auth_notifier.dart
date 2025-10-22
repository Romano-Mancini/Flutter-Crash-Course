import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crash_course/models/user.dart';
import 'package:flutter_crash_course/services/auth/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  final AuthService _authService = AuthService();

  @override
  UserModel build() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        state = UserModel();
      } else {
        state = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
        );
      }
    });
    return UserModel();
  }

  init() async {
    state = await _authService.getCurrentUser();
  }

  login(String email, String password) async {
    state = await _authService.login(email, password);
  }

  signUp(String email, String password, String name) async {
    state = await _authService.signUp(email, password, name);
  }

  requestPasswordReset(String email) async {
    return await _authService.requestPasswordReset(email);
  }

  logout() async {
    await _authService.logout();
    state = UserModel();
  }
}
