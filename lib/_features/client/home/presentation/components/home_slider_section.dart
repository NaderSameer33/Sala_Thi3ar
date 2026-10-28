import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/slider_content.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeSliderSection extends StatefulWidget {
  const HomeSliderSection({super.key});

  @override
  State<HomeSliderSection> createState() => _HomeSliderSectionState();
}

class _HomeSliderSectionState extends State<HomeSliderSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.slidersState != curr.slidersState ||
          prev.sliders != curr.sliders,
      builder: (context, state) {
        if (state.slidersState == RequestState.error) {
          return _buildErrorState(context, state.slidersMessage);
        }

        if (state.sliders.isEmpty &&
            state.slidersState == RequestState.success) {
          return const SizedBox.shrink();
        }
        final isLLoading = state.slidersState == RequestState.loading;

        return Skeletonizer(
          enabled: isLLoading,
          child: SliderContent(
            sliders: isLLoading ? _dummySlider() : state.sliders,
          ),
        );
      },
    );
  }

  List<SliderModel> _dummySlider() {
    return [SliderModel(id: 1, media: '')];
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
