import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/slider_model.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SlliderItem extends StatelessWidget {
  const SlliderItem({super.key, required this.slider});
  final SliderModel slider; 

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: CachedNetworkImage(
          imageUrl: slider.media,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => Skeletonizer(
            enabled: true,
            child: Container(
              color: AppColors.inputFill,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.primaryTint,
            child: const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
