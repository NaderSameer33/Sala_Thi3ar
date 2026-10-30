import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class ProfileLabeledInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ProfileLabeledInput({
    super.key,
    required this.label,
    this.controller,
    this.trailingIcon,
    this.leadingIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primary.withAlpha(120),
            width: 1.2.r,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppStyles.font12RegularGray.copyWith(
                      color: AppColors.textLightGray,
                    ),
                  ),
                  2.verticalSpacing,
                  TextFormField(
                    controller: controller,
                    readOnly: readOnly || onTap != null,
                    onTap: onTap,
                    keyboardType: keyboardType,
                    validator: validator,
                    style: AppStyles.font14BoldPrimary.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingIcon != null) ...[
              8.horizontalSpacing,
              trailingIcon!,
            ],
            if (leadingIcon != null) ...[
              8.horizontalSpacing,
              leadingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}

