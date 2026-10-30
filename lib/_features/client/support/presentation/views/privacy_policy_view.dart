import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/html_parser_helper.dart';
import '../../logic/support_cubit.dart';
import '../../logic/support_state.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SupportCubit>()..getPolicy(),
      child: const _PrivacyPolicyViewBody(),
    );
  }
}

class _PrivacyPolicyViewBody extends StatelessWidget {
  const _PrivacyPolicyViewBody();

  static const _dummyText =
      'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.\n\nإذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية.';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupportCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'سياسة الخصوصية',
          style: AppStyles.font18BoldPrimary,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          final isLoading = state.isPolicyLoading;
          final content = isLoading
              ? _dummyText
              : (state.policy.isNotEmpty
                  ? HtmlParserHelper.parseHtmlString(state.policy)
                  : 'لا توجد سياسة خصوصية متوفرة حالياً.');

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => cubit.getPolicy(),
            child: Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Text(
                  content,
                  style: AppStyles.font14RegularDark.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

