import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crash_course/models/user.dart';
import 'package:flutter_crash_course/services/base_service.dart';

class AuthService extends BaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserModel> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
        );
      }
    } catch (e) {
      throw AuthException('Failed to fetch user data');
    }
    return UserModel();
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? '',
        name: credential.user!.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw AuthException(e.message ?? 'Failed to login');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);

      return UserModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? '',
        name: credential.user!.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw AuthException(e.message ?? 'Failed to sign up');
    } catch (e) {
      print(e);
      throw AuthException('Failed to sign up');
    }
  }

  Future<void> requestPasswordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}
