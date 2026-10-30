import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class AccountMenuCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const AccountMenuCard({
    super.key,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1.h,
                thickness: 0.8.h,
                color: AppColors.divider,
                indent: 14.w,
                endIndent: 14.w,
              ),
          ],
        ],
      ),
    );
  }
}

