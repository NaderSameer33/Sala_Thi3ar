import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../_features/_onborading/presentation/views/on_borading_view.dart';
import '../../_features/client/account/presentation/views/my_account_view.dart';
import '../../_features/client/account/presentation/views/personal_details_view.dart';
import '../../_features/client/addresses/data/models/address_model.dart';
import '../../_features/client/addresses/presentation/views/add_address_view.dart';
import '../../_features/client/addresses/presentation/views/addresses_view.dart';
import '../../_features/client/auth/forget_password/presentation/views/client_forget_password_view.dart';
import '../../_features/client/auth/login/presentation/views/client_login_view.dart';
import '../../_features/client/auth/register/presentation/views/client_register_view.dart';
import '../../_features/client/auth/reset_password/presentation/views/client_reset_password_view.dart';
import '../../_features/client/auth/verify_otp/presentation/views/client_verify_otp_view.dart';
import '../../_features/client/cart/presentation/views/cart_view.dart';
import '../../_features/client/category_products/presentation/views/category_products_view.dart';
import '../../_features/client/favorites/presentation/views/favorites_view.dart';
import '../../_features/client/home/data/models/category_model.dart';
import '../../_features/client/home/data/models/product_model.dart';
import '../../_features/client/home/presentation/views/home_view.dart';
import '../../_features/client/main_shell/presentation/views/main_bottom_nav_shell.dart';
import '../../_features/client/notifications/presentation/views/notifications_view.dart';
import '../../_features/client/orders/data/models/order_details_model.dart';
import '../../_features/client/orders/data/models/order_model.dart';
import '../../_features/client/orders/presentation/views/complete_order_view.dart';
import '../../_features/client/orders/presentation/views/my_orders_view.dart';
import '../../_features/client/orders/presentation/views/order_details_view.dart';
import '../../_features/client/product_details/presentation/views/product_details_view.dart';
import '../../_features/client/rating/presentation/views/rate_products_view.dart';
import '../../_features/client/support/presentation/views/about_app_view.dart';
import '../../_features/client/support/presentation/views/contact_us_view.dart';
import '../../_features/client/support/presentation/views/faqs_view.dart';
import '../../_features/client/support/presentation/views/privacy_policy_view.dart';
import '../../_features/client/support/presentation/views/suggestions_view.dart';
import '../../_features/client/wallet/presentation/views/charge_wallet_view.dart';
import '../../_features/client/wallet/presentation/views/transactions_history_view.dart';
import '../../_features/client/wallet/presentation/views/wallet_view.dart';
import '../../_features/driver/auth/register/presentation/views/driver_register_view.dart';
import '../../_features/driver/presentation/views/driver_login_view.dart';
import '../../_features/splash/presentation/views/splash_view.dart';
import '../caching/secure_storage_service.dart';
import '../caching/shared_pref_service.dart';
import '../constants/constant.dart';
import '../services/get_it_service.dart';
import 'app_page_transition.dart';
import 'app_router_name.dart';

abstract class AppRoutes {
  static GoRouter routeConfig = createRouter(AppRouterName.splash);

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
          path: AppRouterName.splash,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const SplashView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.onborading,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const OnBoradingView(),
          ),
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
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const ClientLoginView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.clientRegister,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const ClientRegisterView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.clientVerifyOtp,
          pageBuilder: (context, state) {
            Widget child;
            if (state.extra is Map<String, dynamic>) {
              final map = state.extra as Map<String, dynamic>;
              final phone = map['phone']?.toString() ?? '';
              final isForgetPassword = map['isForgetPassword'] == true;
              child = ClientVerifyOtpView(
                phone: phone,
                isForgetPassword: isForgetPassword,
              );
            } else {
              child = const ClientVerifyOtpView(phone: '');
            }
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: child,
            );
          },
        ),
        GoRoute(
          path: AppRouterName.clientForgetPassword,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const ClientForgetPasswordView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.clientResetPassword,
          pageBuilder: (context, state) {
            final map = state.extra is Map<String, dynamic>
                ? state.extra as Map<String, dynamic>
                : <String, dynamic>{};
            final phone = map['phone']?.toString() ?? '';
            final code = map['code']?.toString() ?? '';
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: ClientResetPasswordView(
                phone: phone,
                code: code,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRouterName.driverLogin,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const DriverLoginView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.driverRegister,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const DriverRegisterView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.productDetails,
          pageBuilder: (context, state) {
            Widget child;
            if (state.extra is Map<String, dynamic>) {
              final map = state.extra as Map<String, dynamic>;
              final product = map['product'] as ProductModel;
              final heroTag = map['heroTag']?.toString() ?? '';
              child = ProductDetailsView(
                product: product,
                heroTag: heroTag,
              );
            } else {
              final product = state.extra as ProductModel;
              child = ProductDetailsView(product: product);
            }
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: child,
            );
          },
        ),
        GoRoute(
          path: AppRouterName.cart,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const CartView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.personalDetails,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const PersonalDetailsView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.wallet,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const WalletView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.chargeWallet,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const ChargeWalletView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.addresses,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const AddressesView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.addAddress,
          pageBuilder: (context, state) {
            final address = state.extra is AddressModel
                ? state.extra as AddressModel
                : null;
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: AddAddressView(address: address),
            );
          },
        ),
        GoRoute(
          path: AppRouterName.transactionsHistory,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const TransactionsHistoryView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.categoryProducts,
          pageBuilder: (context, state) {
            Widget child;
            if (state.extra is CategoryModel) {
              final category = state.extra as CategoryModel;
              child = CategoryProductsView(
                categoryId: category.id,
                categoryName: category.name,
              );
            } else {
              final map = state.extra as Map<String, dynamic>? ?? {};
              child = CategoryProductsView(
                categoryId: map['categoryId'] as int? ?? 0,
                categoryName: map['categoryName']?.toString() ?? '',
              );
            }
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: child,
            );
          },
        ),
        GoRoute(
          path: AppRouterName.faqs,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const FaqsView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.privacyPolicy,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const PrivacyPolicyView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.aboutApp,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const AboutAppView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.contactUs,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const ContactUsView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.completeOrder,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const CompleteOrderView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.suggestions,
          pageBuilder: (context, state) => buildSmoothTransitionPage(
            context: context,
            state: state,
            child: const SuggestionsView(),
          ),
        ),
        GoRoute(
          path: AppRouterName.orderDetails,
          pageBuilder: (context, state) {
            Widget child;
            if (state.extra is OrderModel) {
              final order = state.extra as OrderModel;
              child = OrderDetailsView(
                orderId: order.id,
                initialOrder: order,
              );
            } else if (state.extra is Map<String, dynamic>) {
              final map = state.extra as Map<String, dynamic>;
              final orderId = map['orderId'] as int? ?? 0;
              final order = map['order'] as OrderModel?;
              child = OrderDetailsView(
                orderId: orderId,
                initialOrder: order,
              );
            } else {
              final orderId = int.tryParse(state.extra?.toString() ?? '0') ?? 0;
              child = OrderDetailsView(orderId: orderId);
            }
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: child,
            );
          },
        ),
        GoRoute(
          path: AppRouterName.rateProducts,
          pageBuilder: (context, state) {
            Widget child;
            if (state.extra is List<OrderProductItemModel>) {
              child = RateProductsView(
                products: state.extra as List<OrderProductItemModel>,
              );
            } else if (state.extra is OrderDetailsModel) {
              child = RateProductsView(
                products: (state.extra as OrderDetailsModel).products,
              );
            } else {
              child = const RateProductsView(products: []);
            }
            return buildSmoothTransitionPage(
              context: context,
              state: state,
              child: child,
            );
          },
        ),
      ],
    );
  }
}
