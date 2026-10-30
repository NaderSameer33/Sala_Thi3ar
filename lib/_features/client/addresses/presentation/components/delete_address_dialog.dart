import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class DeleteAddressDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAddressDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<bool?> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteAddressDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: AppColors.white,
      title: Text(
        'حذف العنوان',
        textAlign: TextAlign.center,
        style: AppStyles.font18BoldDark,
      ),
      content: Text(
        'هل أنت متأكد من حذف هذا العنوان؟',
        textAlign: TextAlign.center,
        style: AppStyles.font14RegularDark.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'إلغاء',
            style: AppStyles.font14RegularDark.copyWith(
              color: AppColors.textGray,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            'حذف',
            style: AppStyles.font14RegularDark.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

