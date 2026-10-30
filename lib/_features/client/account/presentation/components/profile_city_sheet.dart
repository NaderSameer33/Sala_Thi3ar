import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/user_profile_model.dart';

class ProfileCitySheet extends StatelessWidget {
  final List<UserProfileCity> cities;
  final int? selectedCityId;
  final ValueChanged<UserProfileCity> onCitySelected;

  const ProfileCitySheet({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCitySelected,
  });

  static const List<UserProfileCity> defaultCities = [
    UserProfileCity(id: 5, name: 'الرياض'),
    UserProfileCity(id: 6, name: 'مكة المكرمة'),
    UserProfileCity(id: 7, name: 'جدة'),
    UserProfileCity(id: 8, name: 'القاهرة'),
    UserProfileCity(id: 12, name: 'المنصورة'),
  ];

  @override
  Widget build(BuildContext context) {
    final availableCities = cities.isNotEmpty ? cities : defaultCities;

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
              'اختر المدينة',
              style: AppStyles.font16BoldDark,
              textAlign: TextAlign.center,
            ),
            16.verticalSpacing,
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableCities.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final city = availableCities[index];
                  final isSelected = city.id == selectedCityId;

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    title: Text(
                      city.name,
                      style: isSelected
                          ? AppStyles.font14BoldPrimary
                          : AppStyles.font14MediumDark,
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      onCitySelected(city);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            12.verticalSpacing,
          ],
        ),
      ),
    );
  }
}

