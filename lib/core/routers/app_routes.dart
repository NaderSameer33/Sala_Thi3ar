import 'package:go_router/go_router.dart';
import '../../_features/_onborading/presentation/views/on_borading_view.dart';
import '../../_features/client/account/presentation/views/my_account_view.dart';
import '../../_features/client/auth/forget_password/presentation/views/client_forget_password_view.dart';
import '../../_features/client/auth/login/presentation/views/client_login_view.dart';
import '../../_features/client/auth/register/presentation/views/client_register_view.dart';
import '../../_features/client/auth/reset_password/presentation/views/client_reset_password_view.dart';
import '../../_features/client/auth/verify_otp/presentation/views/client_verify_otp_view.dart';
import '../../_features/client/favorites/presentation/views/favorites_view.dart';
import '../../_features/client/home/data/models/product_model.dart';
import '../../_features/client/home/presentation/views/home_view.dart';
import '../../_features/client/main_shell/presentation/views/main_bottom_nav_shell.dart';
import '../../_features/client/notifications/presentation/views/notifications_view.dart';
import '../../_features/client/orders/presentation/views/my_orders_view.dart';
import '../../_features/client/product_details/presentation/views/product_details_view.dart';
import '../../_features/driver/presentation/views/driver_login_view.dart';
import '../caching/secure_storage_service.dart';
import '../caching/shared_pref_service.dart';
import '../constants/constant.dart';
import 'app_router_name.dart';
import '../services/get_it_service.dart';

abstract class AppRoutes {
  static GoRouter routeConfig = createRouter(AppRouterName.onborading);

  static Future<String> getInitialRoute() async {
    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.read(SecureStorageService.keyUserToken);
    final isAuth = token != null && token.isNotEmpty;

    if (isAuth) {
      return AppRouterName.home;
    }

    final isFirst = SharedPrefService.getBool(AppConstant.isFirst) ?? true;
    if (!isFirst) {
      final role = SharedPrefService.getString(AppConstant.userRole);
      return role == 'driver'
          ? AppRouterName.driverLogin
          : AppRouterName.clientLogin;
    }

    return AppRouterName.onborading;
  }

  static void init(String initialRoute) {
    routeConfig = createRouter(initialRoute);
  }

  static GoRouter createRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRouterName.onborading,
          builder: (context, state) => const OnBoradingView(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainBottomNavShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouterName.home,
                  builder: (context, state) => const HomeView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouterName.myOrders,
                  builder: (context, state) => const MyOrdersView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouterName.notifications,
                  builder: (context, state) => const NotificationsView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouterName.favorites,
                  builder: (context, state) => const FavoritesView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouterName.myAccount,
                  builder: (context, state) => const MyAccountView(),
                ),
              ],
            ),
          ],
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
          path: AppRouterName.clientVerifyOtp,
          builder: (context, state) {
            if (state.extra is Map<String, dynamic>) {
              final map = state.extra as Map<String, dynamic>;
              final phone = map['phone']?.toString() ?? '';
              final isForgetPassword = map['isForgetPassword'] == true;
              return ClientVerifyOtpView(
                phone: phone,
                isForgetPassword: isForgetPassword,
              );
            }
            final phone = state.extra is String ? state.extra as String : '';
            return ClientVerifyOtpView(phone: phone);
          },
        ),
        GoRoute(
          path: AppRouterName.clientForgetPassword,
          builder: (context, state) => const ClientForgetPasswordView(),
        ),
        GoRoute(
          path: AppRouterName.clientResetPassword,
          builder: (context, state) {
            final map = state.extra is Map<String, dynamic>
                ? state.extra as Map<String, dynamic>
                : <String, dynamic>{};
            final phone = map['phone']?.toString() ?? '';
            final code = map['code']?.toString() ?? '';
            return ClientResetPasswordView(
              phone: phone,
              code: code,
            );
          },
        ),
        GoRoute(
          path: AppRouterName.driverLogin,
          builder: (context, state) => const DriverLoginView(),
        ),
        GoRoute(
          path: AppRouterName.productDetails,
          builder: (context, state) {
            if (state.extra is Map<String, dynamic>) {
              final map = state.extra as Map<String, dynamic>;
              final product = map['product'] as ProductModel;
              final heroTag = map['heroTag']?.toString() ?? '';
              return ProductDetailsView(
                product: product,
                heroTag: heroTag,
              );
            }
            final product = state.extra as ProductModel;
            return ProductDetailsView(product: product);
          },
        ),
      ],
    );
  }
}
