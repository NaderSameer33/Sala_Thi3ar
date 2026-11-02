import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../data/models/order_details_model.dart';
import 'order_products_bottom_sheet.dart';

class OrderDetailsBottomAction extends StatelessWidget {
  final OrderDetailsModel order;
  final bool isLoading;
  final VoidCallback onCancelOrder;

  const OrderDetailsBottomAction({
    super.key,
    required this.order,
    required this.isLoading,
    required this.onCancelOrder,
  });

  void _showCancelConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'إلغاء الطلب',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
            style: AppStyles.font14RegularDark,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'تراجع',
                style: AppStyles.font14RegularGray,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onCancelOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'تأكيد الإلغاء',
                style: AppStyles.font14BoldWhite,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (order.isCanceled) {
      return const SizedBox.shrink();
    }

    if (order.isFinished) {
      return AppButton(
        text: 'تقييم المنتجات',
        isLoading: isLoading,
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(
          AppRouterName.rateProducts,
          extra: order.products,
        ),
      );
    }

    if (order.isInWay) {
      return AppButton(
        text: 'عرض المنتجات',
        isLoading: isLoading,
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
          if (order.products.isNotEmpty) {
            OrderProductsBottomSheet.show(context, order.products);
          }
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _showCancelConfirmDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.redLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.red,
                ),
              )
            : Text(
                'إلغاء الطلب',
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  color: AppColors.red,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
