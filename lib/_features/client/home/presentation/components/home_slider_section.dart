import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'build_home_error_state.dart';
import 'slider_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeSliderSection extends StatefulWidget {
  const HomeSliderSection({super.key});

  @override
  State<HomeSliderSection> createState() => _HomeSliderSectionState();
}

class _HomeSliderSectionState extends State<HomeSliderSection> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.slidersState != curr.slidersState ||
          prev.sliders != curr.sliders,
      builder: (context, state) {
        if (state.slidersState == RequestState.error) {
          return BuildHomeErrorState(
            message: state.sliderFailureMessage,
            onTap: () => cubit.getSliders(),
          );
        }

        if (state.sliders.isEmpty &&
            state.slidersState == RequestState.success) {
          return const SizedBox.shrink();
        }
        final isLoading = state.slidersState == RequestState.loading;
        final dummySlider = cubit.dummySlider();

        return Skeletonizer(
          enabled: isLoading,
          child: SliderContent(
            sliders: isLoading ? dummySlider : state.sliders,
          ),
        );
      },
    );
  }
}
