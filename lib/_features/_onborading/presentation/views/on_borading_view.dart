import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../logic/onboarding_cubit.dart';
import '../../logic/onboarding_state.dart';
import '../components/onboarding_features_row.dart';
import '../components/onboarding_header.dart';
import '../components/role_selection_card.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/app_button.dart';

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
                          24.verticalSpacing,
                          Text(
                            'اختر نوع الحساب',
                            style: AppStyles.font18BoldDark,
                          ),
                          6.verticalSpacing,
                          Text(
                            'يرجى تحديد هويتك للانتقال إلى الواجهة المناسبة لاحتياجاتك',
                            style: AppStyles.font14RegularGray,
                          ),
                          16.verticalSpacing,
                          RoleSelectionCard(
                            title: 'عميل / متسوق',
                            description:
                                'تصفح واطلب الخضروات والفواكه الطازجة مع توصيل سريع حتى باب بيتك',
                            icon: Icons.shopping_basket_outlined,
                            isSelected: state.selectedRole == UserRole.client,
                            onTap: () => cubit.selectRole(UserRole.client),
                          ),
                          14.verticalSpacing,
                          RoleSelectionCard(
                            title: 'سائق / مندوب توصيل',
                            description:
                                'انضم لأسطول مناديب سلة ثمار واستقبل طلبات التوصيل وحقق أرباحاً مميزة',
                            icon: Icons.delivery_dining_outlined,
                            isSelected: state.selectedRole == UserRole.driver,
                            onTap: () => cubit.selectRole(UserRole.driver),
                          ),
                          20.verticalSpacing,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
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
