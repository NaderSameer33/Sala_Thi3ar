import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';

class CartCheckoutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CartCheckoutButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppButton(
        text: 'الانتقال لإتمام الطلب',
        onPressed: onPressed,
        height: 52.h,
        textStyle: AppStyles.font15BoldWhite,
        borderRadius: 15.r,
      ),
    );
  }
}
