import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../data/models/order_details_model.dart';
import '../../logic/rate_products_cubit.dart';
import '../../logic/rate_products_state.dart';
import '../components/rate_product_card.dart';

class RateProductsView extends StatelessWidget {
  final List<OrderProductItemModel> products;

  const RateProductsView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RateProductsCubit>()..init(products),
      child: _RateProductsViewBody(products: products),
    );
  }
}

class _RateProductsViewBody extends StatelessWidget {
  final List<OrderProductItemModel> products;

  const _RateProductsViewBody({required this.products});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70.r,
                height: 70.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 44.r,
                ),
              ),
              16.verticalSpacing,
              Text(
                'تم التقييم بنجاح',
                style: AppStyles.font18BoldPrimary,
                textAlign: TextAlign.center,
              ),
              8.verticalSpacing,
              Text(
                'شكراً لمشاركتك رأيك معنا، تقييمك يساعدنا في تحسين خدماتنا',
                style: AppStyles.font14RegularDark,
                textAlign: TextAlign.center,
              ),
              20.verticalSpacing,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'الرئيسية',
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go(AppRouterName.home);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RateProductsCubit>();

    final displayProducts = products.isNotEmpty
        ? products
        : const [
            OrderProductItemModel(
              id: 1,
              title: 'طماطم',
              price: 45,
            ),
            OrderProductItemModel(
              id: 2,
              title: 'جزر',
              price: 45,
            ),
          ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'تقييم المنتجات',
          style: AppStyles.font18BoldPrimary,
        ),
      ),
      body: BlocConsumer<RateProductsCubit, RateProductsState>(
        listener: (context, state) {
          if (state.status == RateProductsStatus.success) {
            _showSuccessDialog(context);
          } else if (state.status == RateProductsStatus.error &&
              state.errorMessage.isNotEmpty) {
            showToast(
              context: context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      final rating = state.ratings[product.id] ?? 4;
                      final comment = state.comments[product.id] ?? '';

                      return RateProductCard(
                        product: product,
                        rating: rating,
                        comment: comment,
                        onRatingChanged: (newRating) {
                          cubit.updateRating(product.id, newRating);
                        },
                        onCommentChanged: (newComment) {
                          cubit.updateComment(product.id, newComment);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: AppButton(
                    text: 'تقييم',
                    isLoading: state.status == RateProductsStatus.loading,
                    backgroundColor: AppColors.primary,
                    onPressed: () => cubit.submitRatings(displayProducts),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

