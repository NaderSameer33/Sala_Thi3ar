import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/core/constants/app_assets.dart';
import 'package:sala_thimar/core/router/route_names.dart';
import 'package:sala_thimar/core/shared_widgets/theme_switcher.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/utils/app_button.dart';
import 'package:sala_thimar/features/onboarding/presentation/widgets/card_role.dart';

enum SelectedRole { client, driver }

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  SelectedRole _selectedRole = SelectedRole.client;

  void _onContinue() {
    switch (_selectedRole) {
      case SelectedRole.client:
        context.push(RouteNames.clientLogin);
      case SelectedRole.driver:
        context.push(RouteNames.driverLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: ThemeSwitcher(),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Image.asset(
                  AppAssets.appLogo,
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'سلة ثمار',
                textAlign: TextAlign.center,
                style: AppStyles.font24BoldPrimary,
              ),
              SizedBox(height: 6.h),
              Text(
                'اختر نوع حسابك للمتابعة في التطبيق',
                textAlign: TextAlign.center,
                style: AppStyles.font14RegularSubtitle.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 32.h),
              CardRole(
                title: 'حساب عميل',
                subtitle:
                    'تصفح واطلب خضروات وفواكه طازجة بأفضل الأسعار إلى باب منزلك',
                icon: Icons.shopping_bag_outlined,
                isSelected: _selectedRole == SelectedRole.client,
                onTap: () {
                  setState(() {
                    _selectedRole = SelectedRole.client;
                  });
                },
              ),
              SizedBox(height: 16.h),
              CardRole(
                title: 'حساب مندوب توصيل',
                subtitle:
                    'انضم لأسطول التوصيل واستقبل الطلبات وحقق دخلاً مرناً',
                icon: Icons.delivery_dining_outlined,
                isSelected: _selectedRole == SelectedRole.driver,
                onTap: () {
                  setState(() {
                    _selectedRole = SelectedRole.driver;
                  });
                },
              ),
              const Spacer(),
              AppButton(title: 'المتابعة', onPressed: _onContinue),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
