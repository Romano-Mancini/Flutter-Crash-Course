import 'package:auto_route/auto_route.dart';
import 'package:flutter_crash_course/services/auth/auth.dart';
import 'package:flutter_crash_course/services/router/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService _authService = AuthService();
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    try {
      await _authService.getCurrentUser();
      resolver.next(true);
    } on AuthException {
      resolver.redirectUntil(LoginRoute(), replace: true);
    }
  }
}
