import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../data/models/product_filter_data.dart';
import 'filter_order_section.dart';
import 'filter_price_range_section.dart';

class CategoryFilterBottomSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double? currentMinPrice;
  final double? currentMaxPrice;
  final String? currentFilter;

  const CategoryFilterBottomSheet({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    this.currentMinPrice,
    this.currentMaxPrice,
    this.currentFilter,
  });

  static Future<ProductFilterData?> show({
    required BuildContext context,
    required double minPrice,
    required double maxPrice,
    double? currentMinPrice,
    double? currentMaxPrice,
    String? currentFilter,
  }) {
    return showModalBottomSheet<ProductFilterData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryFilterBottomSheet(
        minPrice: minPrice,
        maxPrice: maxPrice,
        currentMinPrice: currentMinPrice,
        currentMaxPrice: currentMaxPrice,
        currentFilter: currentFilter,
      ),
    );
  }

  @override
  State<CategoryFilterBottomSheet> createState() =>
      _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  late double _min;
  late double _max;
  late RangeValues _rangeValues;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _min = widget.minPrice < widget.maxPrice ? widget.minPrice : 0.0;
    _max = widget.maxPrice > _min ? widget.maxPrice : 1000.0;

    final start = (widget.currentMinPrice ?? _min).clamp(_min, _max);
    final end = (widget.currentMaxPrice ?? _max).clamp(_min, _max);
    _rangeValues = RangeValues(
      start < end ? start : _min,
      end > start ? end : _max,
    );
    _selectedFilter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            12.verticalSpacing,
            Center(
              child: Text(
                'تصفية',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            16.verticalSpacing,
            FilterPriceRangeSection(
              values: _rangeValues,
              min: _min,
              max: _max,
              onChanged: (newValues) {
                setState(() => _rangeValues = newValues);
              },
            ),
            20.verticalSpacing,
            FilterOrderSection(
              selectedFilter: _selectedFilter,
              onChanged: (newFilter) {
                setState(() => _selectedFilter = newFilter);
              },
            ),
            24.verticalSpacing,
            AppButton(
              text: 'تطبيق',
              onPressed: () {
                final filterData = ProductFilterData(
                  filter: _selectedFilter,
                  minPrice: _rangeValues.start,
                  maxPrice: _rangeValues.end,
                );
                Navigator.of(context).pop(filterData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
