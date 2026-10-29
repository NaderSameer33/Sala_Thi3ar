import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../../core/theme/app_colors.dart';

class MainBottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomNavShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              backgroundColor: AppColors.primary,
              color: const Color(0xFFAED489),
              activeColor: AppColors.white,
              tabBackgroundColor: AppColors.white.withAlpha(45),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              gap: 6.w,
              iconSize: 22.sp,
              textStyle: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                GButton(
                  icon: Icons.home,
                  leading: SvgPicture.asset(
                    'assets/icons/home.svg',
                    height: 22.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 0
                          ? AppColors.white
                          : const Color(0xFFAED489),
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'الرئيسية',
                ),
                GButton(
                  icon: Icons.receipt_long,
                  leading: SvgPicture.asset(
                    'assets/icons/my_orders.svg',
                    height: 22.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 1
                          ? AppColors.white
                          : const Color(0xFFAED489),
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'طلباتي',
                ),
                GButton(
                  icon: Icons.notifications,
                  leading: SvgPicture.asset(
                    'assets/icons/notification_bell.svg',
                    height: 22.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 2
                          ? AppColors.white
                          : const Color(0xFFAED489),
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'الإشعارات',
                ),
                GButton(
                  icon: Icons.favorite,
                  leading: SvgPicture.asset(
                    'assets/icons/heart.svg',
                    height: 22.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 3
                          ? AppColors.white
                          : const Color(0xFFAED489),
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'المفضلة',
                ),
                GButton(
                  icon: Icons.person,
                  leading: SvgPicture.asset(
                    'assets/icons/my_account.svg',
                    height: 22.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 4
                          ? AppColors.white
                          : const Color(0xFFAED489),
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'حسابي',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
