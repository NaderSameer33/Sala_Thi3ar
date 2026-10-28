import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeSliderSection extends StatefulWidget {
  const HomeSliderSection({super.key});

  @override
  State<HomeSliderSection> createState() => _HomeSliderSectionState();
}

class _HomeSliderSectionState extends State<HomeSliderSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeSlidersLoading || state is HomeInitial) {
          return _buildLoadingSkeleton();
        }

        if (state is HomeSlidersError) {
          return _buildErrorState(context, state.message);
        }

        final sliders = (state as HomeSlidersSuccess).sliders;

        if (sliders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: sliders.length,
                options: CarouselOptions(
                  height: 170.h,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 600),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return _buildSliderItem(sliders[index]);
                },
              ),
              10.verticalSpacing,
              _buildIndicators(sliders.length),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliderItem(SliderModel slider) {
    return Container(
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

  Widget _buildIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 18.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryTint,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            Container(
              height: 170.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            10.verticalSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: AppColors.inputBorder,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpacing,
            InkWell(
              onTap: () => context.read<HomeCubit>().getSliders(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
