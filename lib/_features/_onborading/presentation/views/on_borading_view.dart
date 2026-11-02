import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import '../../data/models/onboarding_model.dart';
import '../../logic/onboarding_cubit.dart';
import '../../logic/onboarding_state.dart';
import '../components/onboarding_indicator.dart';
import '../components/onboarding_page_item.dart';

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

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/app_logo.png',
                        height: 38.h,
                        fit: BoxFit.contain,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: state.isLastPage ? 0.0 : 1.0,
                        child: IgnorePointer(
                          ignoring: state.isLastPage,
                          child: TextButton(
                            onPressed: () async {
                              final destination = await cubit.completeOnboarding();
                              if (context.mounted) {
                                context.go(destination);
                              }
                            },
                            child: Text(
                              'تخطي',
                              style: AppStyles.font14RegularGray.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: OnboardingModel.items.length,
                    onPageChanged: cubit.onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return OnboardingPageItem(
                        item: OnboardingModel.items[index],
                      );
                    },
                  ),
                ),
                16.verticalSpacing,
                OnboardingIndicator(
                  count: OnboardingModel.items.length,
                  activeIndex: state.currentPage,
                ),
                28.verticalSpacing,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: state.isLastPage
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: cubit.skipToLast,
                          child: Text(
                            'التخطي إلى النهاية',
                            style: AppStyles.font14RegularGray,
                          ),
                        ),
                        GestureDetector(
                          onTap: cubit.nextPage,
                          child: Container(
                            width: 54.r,
                            height: 54.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(90),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondChild: AppButton(
                      text: 'ابدأ التسوق الآن',
                      isLoading: state.isSubmitting,
                      onPressed: () async {
                        final destination = await cubit.completeOnboarding();
                        if (context.mounted) {
                          context.go(destination);
                        }
                      },
                    ),
                  ),
                ),
                24.verticalSpacing,
              ],
            );
          },
        ),
      ),
    );
  }
}
