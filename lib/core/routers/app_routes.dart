import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/_onborading/presentation/views/on_borading_view.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/views/client_login_view.dart';
import 'package:sala_thimar/_features/client/auth/register/presentation/views/client_register_view.dart';
import 'package:sala_thimar/_features/driver/presentation/views/driver_login_view.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';

abstract class AppRoutes {
  static final routeConfig = GoRouter(
    initialLocation: AppRouterName.onborading,
    routes: [
      GoRoute(
        path: AppRouterName.onborading,
        builder: (context, state) => const OnBoradingView(),
      ),
      GoRoute(
        path: AppRouterName.clientLogin,
        builder: (context, state) => const ClientLoginView(),
      ),
      GoRoute(
        path: AppRouterName.clientRegister,
        builder: (context, state) => const ClientRegisterView(),
      ),
      GoRoute(
        path: AppRouterName.driverLogin,
        builder: (context, state) => const DriverLoginView(),
      ),
    ],
  );
}
