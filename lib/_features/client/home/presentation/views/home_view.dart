import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/core/caching/secure_storage_service.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الرئيسية',
          style: AppStyles.font18BoldDark,
        ),
        actions: [
          IconButton(
            tooltip: 'تسجيل الخروج',
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.red,
            ),
            onPressed: () async {
              final secureStorage = getIt<SecureStorageService>();
              await secureStorage.delete(SecureStorageService.keyUserToken);
              if (context.mounted) {
                context.go(AppRouterName.clientLogin);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
              24.verticalSpacing,
              Center(
                child: Text(
                  'أهلاً بك في سلة ثمار',
                  style: AppStyles.font20BoldDark.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              8.verticalSpacing,
              Center(
                child: Text(
                  'تسوق أفضل الخضروات والفواكه الطازجة بجودة عالية',
                  style: AppStyles.font14RegularGray,
                  textAlign: TextAlign.center,
                ),
              ),
              32.verticalSpacing,
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    14.horizontalSpacing,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تم تسجيل الدخول بنجاح',
                            style: AppStyles.font16BoldDark,
                          ),
                          4.verticalSpacing,
                          Text(
                            'حسابك مفعل وجاهز للطلب',
                            style: AppStyles.font13RegularGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
