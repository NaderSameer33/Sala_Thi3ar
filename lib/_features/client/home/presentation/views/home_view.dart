import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_header.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_search_bar.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_slider_section.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..getSliders(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeader(),
              16.verticalSpacing,
              HomeSearchBar() , 
              18.verticalSpacing,
              // Slider is full-width — no horizontal padding
              const HomeSliderSection(),
              20.verticalSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
 