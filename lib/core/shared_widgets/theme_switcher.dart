import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../di/service_locator.dart';
import '../theme/app_colors.dart';
import '../theme/logic/theme_cubit.dart';
import '../theme/logic/theme_state.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      bloc: getIt<ThemeCubit>(),
      builder: (context, state) {
        final isDark = state.isDark;

        return GestureDetector(
          onTap: () => getIt<ThemeCubit>().toggleTheme(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 68.w,
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.secondary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : AppColors.primary).withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        size: 16.r,
                        color: isDark ? AppColors.subtitleGray : Colors.amber,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        Icons.nightlight_round,
                        size: 16.r,
                        color: isDark ? Colors.amberAccent : AppColors.subtitleGray,
                      ),
                    ),
                  ],
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.primary : AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      size: 16.r,
                      color: isDark ? AppColors.white : Colors.amber.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
