import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_weights.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/app_button.dart';

enum SelectedRole { client, driver }

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  SelectedRole _selectedRole = SelectedRole.client;

  void _onContinue() {
    if (_selectedRole == SelectedRole.client) {
      context.push(RouteNames.clientLogin);
    } else {
      context.push(RouteNames.driverLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Image.asset(
                  AppAssets.appLogo,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'سلة ثمار',
                textAlign: TextAlign.center,
                style: AppStyles.font24BoldPrimary,
              ),
              SizedBox(height: 8.h),
              Text(
                'اختر نوع حسابك للمتابعة في التطبيق',
                textAlign: TextAlign.center,
                style: AppStyles.font14RegularSubtitle,
              ),
              SizedBox(height: 36.h),
              _buildRoleCard(
                role: SelectedRole.client,
                title: 'حساب عميل',
                subtitle:
                    'تصفح واطلب خضروات وفواكه طازجة بأفضل الأسعار إلى باب منزلك',
                icon: Icons.shopping_bag_outlined,
              ),
              SizedBox(height: 16.h),
              _buildRoleCard(
                role: SelectedRole.driver,
                title: 'حساب مندوب توصيل',
                subtitle:
                    'انضم لأسطول التوصيل واستقبل الطلبات وحقق دخلاً مرناً',
                icon: Icons.delivery_dining_outlined,
              ),
              const Spacer(),
              AppButton(title: 'المتابعة', onPressed: _onContinue),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required SelectedRole role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBackground : AppColors.inputFill,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.primary,
                size: 28.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: AppFontWeights.bold,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: AppStyles.font12RegularGray),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : AppColors.subtitleGray,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
