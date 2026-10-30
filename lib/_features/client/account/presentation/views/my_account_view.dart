import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/user_profile_model.dart';
import '../../logic/account_cubit.dart';
import '../../logic/account_state.dart';
import '../components/account_header.dart';
import '../components/account_menu_card.dart';
import '../components/account_menu_item.dart';
import '../components/logout_confirm_dialog.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AccountCubit>()..getProfile(),
      child: const _MyAccountViewBody(),
    );
  }
}

class _MyAccountViewBody extends StatelessWidget {
  const _MyAccountViewBody();

  void _showLogoutDialog(BuildContext context, AccountCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, state) {
              return LogoutConfirmDialog(
                isLoading: state.isLogoutLoading,
                onConfirm: () async {
                  await cubit.logout();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state.logoutStatus == AccountLogoutStatus.success) {
            Navigator.of(context, rootNavigator: true).pop();
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(
                state.logoutMessage.isNotEmpty
                    ? state.logoutMessage
                    : 'تم تسجيل الخروج بنجاح',
              ),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetLogoutStatus();
            context.go(AppRouterName.clientLogin);
          } else if (state.logoutStatus == AccountLogoutStatus.error) {
            Navigator.of(context, rootNavigator: true).pop();
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(
                state.errorMessage.isNotEmpty
                    ? state.errorMessage
                    : 'فشل تسجيل الخروج',
              ),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetLogoutStatus();
          }
        },
        builder: (context, state) {
          final profile = state.profile ?? UserProfileModel.dummy;

          return RefreshIndicator(
            onRefresh: () => cubit.getProfile(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Skeletonizer(
                    enabled: state.isLoading,
                    child: AccountHeader(
                      profile: profile,
                    ),
                  ),
                  16.verticalSpacing,
                  AccountMenuCard(
                    children: [
                      AccountMenuItem(
                        title: 'البيانات الشخصية',
                        iconPath: 'assets/images/User.png',
                        onTap: () async {
                          await context.push(AppRouterName.personalDetails);
                          if (context.mounted) {
                            await cubit.getProfile();
                          }
                        },
                      ),
                      AccountMenuItem(
                        title: 'المحفظة',
                        iconPath: 'assets/images/Wallet.png',
                        onTap: () {
                          context.push(AppRouterName.wallet);
                        },
                      ),
                      AccountMenuItem(
                        title: 'العناوين',
                        iconPath: 'assets/images/Location.png',
                        onTap: () {
                          context.push(AppRouterName.addresses);
                        },
                      ),
                      
                    ],
                  ),
                  16.verticalSpacing,
                  AccountMenuCard(
                    children: [
                      AccountMenuItem(
                        title: 'أسئلة متكررة',
                        iconPath: 'assets/images/Question.png',
                        onTap: () {
                          context.push(AppRouterName.faqs);
                        },
                      ),
                      AccountMenuItem(
                        title: 'سياسة الخصوصية',
                        iconPath: 'assets/images/Shield - check.png',
                        onTap: () {
                          context.push(AppRouterName.privacyPolicy);
                        },
                      ),
                      AccountMenuItem(
                        title: 'تواصل معنا',
                        iconPath: 'assets/images/Call - Calling.png',
                        onTap: () {
                          context.push(AppRouterName.contactUs);
                        },
                      ),
                      AccountMenuItem(
                        title: 'الشكاوي والأقتراحات',
                        iconPath: 'assets/images/Edit - 3.png',
                        onTap: () {
                          context.push(AppRouterName.suggestions);
                        },
                      ),
                      AccountMenuItem(
                        title: 'مشاركة التطبيق',
                        iconData: Icons.share_outlined,
                        onTap: () {},
                      ),
                      AccountMenuItem(
                        title: 'عن التطبيق',
                        iconPath: 'assets/images/Info.png',
                        onTap: () {
                          context.push(AppRouterName.aboutApp);
                        },
                      ),
                      AccountMenuItem(
                        title: 'تغيير اللغة',
                        iconData: Icons.language_rounded,
                        onTap: () {},
                      ),
                      AccountMenuItem(
                        title: 'الشروط والأحكام',
                        iconPath: 'assets/images/Note.png',
                        onTap: () {},
                      ),
                      AccountMenuItem(
                        title: 'تقييم التطبيق',
                        iconPath: 'assets/images/Star.png',
                        onTap: () {},
                      ),
                    ],
                  ),
                  16.verticalSpacing,
                  AccountMenuCard(
                    children: [
                      AccountMenuItem(
                        title: 'تسجيل الخروج',
                        showTrailingArrow: false,
                        trailing: Image.asset(
                          'assets/images/Turn off.png',
                          width: 22.r,
                          height: 22.r,
                          fit: BoxFit.contain,
                        ),
                        onTap: () => _showLogoutDialog(context, cubit),
                      ),
                    ],
                  ),
                  24.verticalSpacing,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
