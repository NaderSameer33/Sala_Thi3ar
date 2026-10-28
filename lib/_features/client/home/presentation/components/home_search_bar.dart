import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AppInput(
          hintText: 'ابحث عن ماتريد؟',

          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Image.asset(
              'assets/images/Search.png',
              width: 20.w,
              height: 20.h,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
