import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class AppLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;

  const AppLoading({
    super.key,
    this.size,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.threeArchedCircle(
            color: color ?? AppColors.primary,
            size: size ?? 38.r,
          ),
          if (message != null) ...[
            12.verticalSpacing,
            Text(
              message!,
              style: AppStyles.font14RegularGray,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}