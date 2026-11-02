import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/caching/secure_storage_service.dart';
import '../../../../core/caching/shared_pref_service.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/routers/app_router_name.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driverController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _rotateAnimation;
  late final Animation<Offset> _slideTextAnimation;
  late final Animation<double> _fadeTextAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationAndNavigate();
  }

  void _initAnimations() {
    _driverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.06, end: 0.0).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOutBack),
      ),
    );

    _slideTextAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.45),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _fadeTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeIn),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _driverController,
        curve: const Interval(0.70, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _startAnimationAndNavigate() {
    _driverController.forward().then((_) => _navigateNext());
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;

    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.read(SecureStorageService.keyUserToken);
    final isAuth = token != null && token.isNotEmpty;

    if (!mounted) return;

    if (isAuth) {
      context.go(AppRouterName.home);
      return;
    }

    final isFirst = SharedPrefService.getBool(AppConstant.isFirst) ?? true;
    if (isFirst) {
      context.go(AppRouterName.onborading);
      return;
    }

    final role = SharedPrefService.getString(AppConstant.userRole);
    if (role == 'driver') {
      context.go(AppRouterName.driverLogin);
    } else {
      context.go(AppRouterName.clientLogin);
    }
  }

  @override
  void dispose() {
    _driverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -60.h,
            right: -60.w,
            child: Container(
              width: 240.r,
              height: 240.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryTint.withAlpha(160),
                    AppColors.white.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80.h,
            left: -80.w,
            child: Container(
              width: 280.r,
              height: 280.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryVeryLight.withAlpha(180),
                    AppColors.white.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                SizedBox(
                  width: 240.r,
                  height: 240.r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/splash_animation.json',
                        controller: _driverController,
                        width: 220.r,
                        height: 220.r,
                        fit: BoxFit.contain,
                      ),
                      AnimatedBuilder(
                        animation: _driverController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value * _pulseAnimation.value,
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Hero(
                                  tag: 'app_logo',
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 110.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                16.verticalSpacing,
                SlideTransition(
                  position: _slideTextAnimation,
                  child: FadeTransition(
                    opacity: _fadeTextAnimation,
                    child: Column(
                      children: [
                        Text(
                          'سلة ثمار',
                          style: AppStyles.font24BoldDark.copyWith(
                            color: AppColors.primary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        8.verticalSpacing,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            'خضروات وفواكه طازجة يومياً بأعلى جودة',
                            textAlign: TextAlign.center,
                            style: AppStyles.font14RegularGray.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                AnimatedBuilder(
                  animation: _driverController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeTextAnimation.value,
                      child: Container(
                        width: 140.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 140.w * _driverController.value,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                16.verticalSpacing,
                FadeTransition(
                  opacity: _fadeTextAnimation,
                  child: Text(
                    'الإصدار 1.0.0',
                    style: AppStyles.font12RegularGray.copyWith(
                      color: AppColors.textLightGray,
                    ),
                  ),
                ),
                20.verticalSpacing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
