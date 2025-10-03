import 'package:auto_route/auto_route.dart';
import 'package:flutter_crash_course/services/router/router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(LoginRoute(), replace: true);
    }
  }
}
