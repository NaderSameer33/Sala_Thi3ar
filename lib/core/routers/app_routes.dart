import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/_onborading/presentation/views/on_borading_view.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/presentation/views/client_forget_password_view.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/views/client_login_view.dart';
import 'package:sala_thimar/_features/client/auth/register/presentation/views/client_register_view.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/presentation/views/client_reset_password_view.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/presentation/views/client_verify_otp_view.dart';
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
    ],
  );
}
