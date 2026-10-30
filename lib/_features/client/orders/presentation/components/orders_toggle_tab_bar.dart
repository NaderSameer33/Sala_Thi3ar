import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../logic/orders_state.dart';

class OrdersToggleTabBar extends StatelessWidget {
  final OrdersTab activeTab;
  final ValueChanged<OrdersTab> onTabChanged;

  const OrdersToggleTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.border,
          width: 1.r,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              tab: OrdersTab.current,
              title: 'الحالية',
              isSelected: activeTab == OrdersTab.current,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: _buildTab(
              tab: OrdersTab.finished,
              title: 'المنتهية',
              isSelected: activeTab == OrdersTab.finished,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required OrdersTab tab,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          title,
          style: isSelected
              ? AppStyles.font14BoldWhite
              : AppStyles.font14RegularGray,
        ),
      ),
    );
  }
}
