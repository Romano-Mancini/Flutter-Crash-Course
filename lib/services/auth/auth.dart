import 'package:flutter_crash_course/models/user.dart';
import 'package:flutter_crash_course/services/base_service.dart';

class AuthService extends BaseService {
  Future<UserModel> getCurrentUser() async {
    final String? token = await tokenRepository.token;
    if (token != null) {
      final response = await client.get('${baseUrl}api/profile');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw AuthException('Failed to fetch user data');
      }
    }
    throw AuthException('No user logged in');
  }

  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      '${baseUrl}auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      await tokenRepository.setToken(response.data['access_token']);
      await tokenRepository.setRefreshToken(response.data['refresh_token']);
      return await getCurrentUser();
    } else {
      throw AuthException('Invalid credentials');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    final response = await client.post(
      '${baseUrl}auth/signup',
      data: {'email': email, 'password': password, 'name': name},
    );
    if (response.statusCode == 201) {
      return await login(email, password);
    } else {
      throw AuthException('Failed to sign up');
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final response = await client.post(
      '${baseUrl}auth/forgot-password',
      data: {'email': email},
    );
    if (response.statusCode != 200) {
      throw AuthException('Failed to request password reset');
    }
  }

  Future<void> logout() async {
    await tokenRepository.logout();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}
