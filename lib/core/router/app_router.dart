import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/client/auth/presentation/screens/client_login_screen.dart';
import '../../features/driver/auth/presentation/screens/driver_login_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
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
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.clientLogin,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ClientLoginScreen(),
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
