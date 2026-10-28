import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.searchKeyword != curr.searchKeyword,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AppInput(
              controller: _controller,
              hintText: 'ابحث عن ماتريد؟',
              onChanged: (value) =>
                  context.read<HomeCubit>().onSearchChanged(value),
              suffixIcon: state.isSearching
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textLightGray,
                        size: 20,
                      ),
                      onPressed: () {
                        _controller.clear();
                        context.read<HomeCubit>().clearSearch();
                      },
                    )
                  : null,
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: Image.asset(
                  'assets/images/Search.png',
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
