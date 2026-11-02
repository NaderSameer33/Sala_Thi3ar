import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/_features/client/account/presentation/components/profile_city_sheet.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';

class RegisterCitySheet extends StatefulWidget {
  final List<UserProfileCity> cities;
  final int? selectedCityId;
  final ValueChanged<UserProfileCity> onCitySelected;

  const RegisterCitySheet({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCitySelected,
  });

  @override
  State<RegisterCitySheet> createState() => _RegisterCitySheetState();
}

class _RegisterCitySheetState extends State<RegisterCitySheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<UserProfileCity> _availableCities;
  late List<UserProfileCity> _filteredCities;

  @override
  void initState() {
    super.initState();
    _availableCities = widget.cities.isNotEmpty
        ? widget.cities
        : ProfileCitySheet.defaultCities;
    _filteredCities = List.from(_availableCities);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = List.from(_availableCities);
      } else {
        _filteredCities = _availableCities
            .where((city) => city.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
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
              style: AppStyles.font18BoldDark,
              textAlign: TextAlign.center,
            ),
            14.verticalSpacing,
            AppInput(
              controller: _searchController,
              hintText: 'ابحث عن مدينتك...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textLightGray,
              ),
            ),
            14.verticalSpacing,
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 320.h,
              ),
              child: _filteredCities.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          'لا توجد مدينة مطابقة للبحث',
                          style: AppStyles.font14RegularGray,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _filteredCities.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1.h,
                        color: AppColors.divider,
                      ),
                      itemBuilder: (context, index) {
                        final city = _filteredCities[index];
                        final isSelected = city.id == widget.selectedCityId;

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 2.h,
                          ),
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
                            widget.onCitySelected(city);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
            8.verticalSpacing,
          ],
        ),
      ),
    );
  }
}
