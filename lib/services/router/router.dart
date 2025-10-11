import 'package:auto_route/auto_route.dart';
import 'package:flutter_crash_course/services/router/auth_guard.dart';
import 'package:flutter_crash_course/services/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: HomeRoute.page, initial: true, guards: [AuthGuard()]),
    AutoRoute(page: AddCountryRoute.page, guards: [AuthGuard()]),
  ];
}
