import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/widgets/app_input.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF007A3D),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                alignment: Alignment.center,
                child: Image.asset('assets/images/flag.png'),
              ),
              3.verticalSpacing,
              Text(
                '+966',
                style: AppStyles.font12RegularGray.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpacing,
        Expanded(
          child: AppInput(
            controller: controller,
            hintText: 'رقم الجوال',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.textLightGray,
            ),
            validator: AppValidator.validatePhone,
          ),
        ),
      ],
    );
  }
}
