import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/_onborading/presentation/views/on_borading_view.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';

abstract class AppRoutes {
  static final routeConfig = GoRouter(
    initialLocation: AppRouterName.onborading,

    routes: [
      GoRoute(
        path: AppRouterName.onborading,
        builder: (context, state) => OnBoradingView(),
      ),
    ],
  );
}
