import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/caching/secure_storage_service.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/app_button.dart';

class DriverLoginView extends StatelessWidget {
  const DriverLoginView({super.key});

  Future<void> _switchToClient(BuildContext context) async {
    await SharedPrefService.setString(AppConstant.userRole, 'client');
    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.read(SecureStorageService.keyUserToken);
    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        context.go(AppRouterName.home);
      } else {
        context.go(AppRouterName.clientLogin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'بوابة المندوب',
          style: AppStyles.font18BoldDark,
        ),
        actions: [
          IconButton(
            tooltip: 'العودة لحساب العميل',
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
            onPressed: () => _switchToClient(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_shipping_outlined,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              24.verticalSpacing,
              Text(
                'مرحباً بك في بوابة المناديب',
                style: AppStyles.font20BoldDark,
                textAlign: TextAlign.center,
              ),
              8.verticalSpacing,
              Text(
                'سجل دخولك لمتابعة وتوصيل طلبات سلة ثمار بكل سهولة',
                style: AppStyles.font14RegularGray,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                text: 'تسجيل حساب مندوب جديد',
                onPressed: () => context.push(AppRouterName.driverRegister),
              ),
              12.verticalSpacing,
              OutlinedButton(
                onPressed: () => _switchToClient(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55.h),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Text(
                  'العودة إلى حساب العميل',
                  style: AppStyles.font14BoldPrimary,
                ),
              ),
              24.verticalSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
