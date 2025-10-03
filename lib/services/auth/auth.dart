import 'package:flutter_crash_course/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<UserModel> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    if (token != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      return UserModel(
        uid: 'user123',
        email: 'user@example.com',
        name: 'John Doe',
      );
    }
    throw AuthException('No user logged in');
  }

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email == 'demo@gmail.com' && password == 'password') {
      // Here we'll save the token to simulate a logged-in user
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', 'dummy_token');
      return await getCurrentUser();
    } else {
      throw AuthException('Invalid credentials');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await login(email, password);
  }

  Future<void> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}
