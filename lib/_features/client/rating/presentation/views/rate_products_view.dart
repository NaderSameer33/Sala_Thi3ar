import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/client/orders/data/models/order_details_model.dart';
import 'package:sala_thimar/_features/client/rating/logic/rating_cubit.dart';
import 'package:sala_thimar/_features/client/rating/logic/rating_state.dart';
import 'package:sala_thimar/_features/client/rating/presentation/components/rate_product_card.dart';
import 'package:sala_thimar/_features/client/rating/presentation/components/rate_success_dialog.dart';
import 'package:sala_thimar/core/helper/helper_method.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';

class RateProductsView extends StatelessWidget {
  final List<OrderProductItemModel> products;

  const RateProductsView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RatingCubit>()..initOrderProducts(products),
      child: _RateProductsViewBody(products: products),
    );
  }
}

class _RateProductsViewBody extends StatelessWidget {
  final List<OrderProductItemModel> products;

  const _RateProductsViewBody({required this.products});

  void _showSuccessDialog(BuildContext context) {
    RateSuccessDialog.show(
      context,
      title: 'تم التقييم بنجاح',
      message: 'شكراً لمشاركتك رأيك معنا، تقييمك يساعدنا في تحسين خدماتنا',
      buttonText: 'الرئيسية',
      onDismiss: () => context.go(AppRouterName.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RatingCubit>();

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
      body: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state.status == RatingStatus.success) {
            _showSuccessDialog(context);
          } else if (state.status == RatingStatus.error &&
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: AppButton(
                    text: 'تقييم',
                    isLoading: state.status == RatingStatus.loading,
                    backgroundColor: AppColors.primary,
                    onPressed: () => cubit.submitOrderRatings(displayProducts),
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
