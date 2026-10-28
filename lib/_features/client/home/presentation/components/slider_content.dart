import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/slider_indecator.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/slider_item.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';

class SliderContent extends StatefulWidget {
  const SliderContent({
    super.key,
    required this.sliders,
    this.isLoading = false,
  });

  final List<SliderModel> sliders;
  final bool isLoading;

  @override
  State<SliderContent> createState() => _SliderContentState();
}

class _SliderContentState extends State<SliderContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: widget.sliders.length,
            options: CarouselOptions(
              height: 170.h,
              viewportFraction: 1.0,
              autoPlay: !widget.isLoading && widget.sliders.length > 1,
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
              return SlliderItem(slider: widget.sliders[index]);
            },
          ),
          10.verticalSpacing,
          SliderIndecator(
            count: widget.sliders.length,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }
}
