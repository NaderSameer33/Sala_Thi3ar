import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/faq_model.dart';
import '../../logic/support_cubit.dart';
import '../../logic/support_state.dart';
import '../components/faq_item_card.dart';

class FaqsView extends StatelessWidget {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SupportCubit>()..getFaqs(),
      child: const _FaqsViewBody(),
    );
  }
}

class _FaqsViewBody extends StatelessWidget {
  const _FaqsViewBody();

  static const _dummyFaqs = [
    FaqModel(
      id: 1,
      question: 'كيفية الدفع عن طريق البطاقة الإئتمانية؟',
      answer: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي.',
    ),
    FaqModel(
      id: 2,
      question: 'كل ما تريد معرفته عن أكواد الخصم/ الكوبونات',
      answer: 'يمكنك إدخال كود الخصم في صفحة إتمام الطلب للحصول على الخصم الفوري.',
    ),
    FaqModel(
      id: 3,
      question: 'هل يتم وضع منتجات جديدة كل فترة؟',
      answer: 'نعم، نقوم بإضافة منتجات طازجة ومميزة بشكل دوري ومستمر.',
    ),
    FaqModel(
      id: 4,
      question: 'ما هي الفترة الزمنية لتحديث المخزون لديكم؟',
      answer: 'يتم تحديث المخزون يومياً مع وصول الخضار والفواكه الطازجة.',
    ),
  ];

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
          'أسئلة متكررة',
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
          final isLoading = state.isFaqsLoading;
          final faqs = isLoading ? _dummyFaqs : state.faqs;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => cubit.getFaqs(),
            child: Skeletonizer(
              enabled: isLoading,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return FaqItemCard(faq: faqs[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

