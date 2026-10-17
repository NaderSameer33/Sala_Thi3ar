import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/client/auth/presentation/view/client_login_view.dart';
import '../../features/driver/auth/presentation/view/driver_login_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import 'page_transitions.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.onboarding,
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        pageBuilder: (context, state) => buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: RouteNames.clientLogin,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ClientLoginView(),
        ),
      ),
      GoRoute(
        path: RouteNames.driverLogin,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const DriverLoginScreen(),
        ),
      ),
    ],
  );
}
