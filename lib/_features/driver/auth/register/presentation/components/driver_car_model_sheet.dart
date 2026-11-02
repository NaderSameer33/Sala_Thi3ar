import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/car_model_item.dart';

class DriverCarModelSheet extends StatelessWidget {
  final List<CarModelItem> models;
  final int? selectedModelId;
  final ValueChanged<CarModelItem> onModelSelected;

  const DriverCarModelSheet({
    super.key,
    required this.models,
    this.selectedModelId,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final availableModels = models.isNotEmpty ? models : CarModelItem.defaultModels;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpacing,
            Text(
              'اختر موديل السيارة',
              style: AppStyles.font16BoldDark,
              textAlign: TextAlign.center,
            ),
            16.verticalSpacing,
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableModels.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.border.withAlpha(90),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final model = availableModels[index];
                  final isSelected = model.id == selectedModelId;

                  return InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () {
                      onModelSelected(model);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 20.sp,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textLightGray,
                          ),
                          12.horizontalSpacing,
                          Expanded(
                            child: Text(
                              model.name,
                              style: isSelected
                                  ? AppStyles.font14BoldPrimary
                                  : AppStyles.font14RegularDark,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
