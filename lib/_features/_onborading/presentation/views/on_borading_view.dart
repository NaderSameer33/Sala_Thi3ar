import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../logic/onboarding_cubit.dart';
import '../../logic/onboarding_state.dart';
import '../components/onboarding_features_row.dart';
import '../components/onboarding_header.dart';

class OnBoradingView extends StatelessWidget {
  const OnBoradingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingViewBody(),
    );
  }
}

class _OnboardingViewBody extends StatelessWidget {
  const _OnboardingViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const OnboardingHeader(),
                          18.verticalSpacing,
                          const OnboardingFeaturesRow(),
                          30.verticalSpacing,
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.primary.withAlpha(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 70.r,
                                  height: 70.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryTint,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 34,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                16.verticalSpacing,
                                Text(
                                  'تسوق خضرواتك وفواكهك بكل سهولة',
                                  style: AppStyles.font16BoldPrimary,
                                  textAlign: TextAlign.center,
                                ),
                                8.verticalSpacing,
                                Text(
                                  'تصفح أحدث العروض والمنتجات الطازجة المختارة بعناية لتصل إليك مغلفة بأعلى معايير النظافة والجودة',
                                  style: AppStyles.font14RegularGray,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpacing,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h, top: 8.h),
                    child: AppButton(
                      text: 'ابدأ الآن',
                      isLoading: state.isSubmitting,
                      onPressed: () async {
                        final destination = await cubit.completeOnboarding();
                        if (context.mounted) {
                          context.go(destination);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
