import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../favorites/logic/favorites_cubit.dart';
import '../../../favorites/logic/favorites_state.dart';
import '../../../home/data/models/product_model.dart';
import '../../../home/presentation/components/slider_indecator.dart';

class ProductImagesSlider extends StatefulWidget {
  final ProductModel product;
  final String heroTag;

  const ProductImagesSlider({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  State<ProductImagesSlider> createState() => _ProductImagesSliderState();
}

class _ProductImagesSliderState extends State<ProductImagesSlider> {
  int _currentIndex = 0;

  List<String> get _allImages {
    final list = <String>[];
    if (widget.product.mainImage.isNotEmpty) {
      list.add(widget.product.mainImage);
    }
    for (final img in widget.product.images) {
      if (img.url.isNotEmpty && !list.contains(img.url)) {
        list.add(img.url);
      }
    }
    if (list.isEmpty) {
      list.add('');
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final images = _allImages;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 320.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: images.length == 1
              ? _buildSingleImage(images.first)
              : CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    height: 320.h,
                    viewportFraction: 1.0,
                    autoPlay: images.length > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    if (index == 0) {
                      return _buildSingleImage(images[index]);
                    }
                    return _buildNetworkImage(images[index]);
                  },
                ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: SliderIndecator(
              currentIndex: _currentIndex,
              count: images.length,
            ),
          ),
        Positioned(
          top: 12.h,
          right: 16.w,
          child: _buildCircleButton(
            icon: Icons.arrow_back_ios,
            onTap: () => context.pop(),
          ),
        ),
        Positioned(
          top: 12.h,
          left: 16.w,
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            buildWhen: (prev, curr) =>
                (prev.isProductFavorite(widget.product.id)) !=
                    (curr.isProductFavorite(widget.product.id)) ||
                (prev.togglingProductId == widget.product.id) !=
                    (curr.togglingProductId == widget.product.id),
            builder: (context, state) {
              final isFav = state.favoriteProductIds.contains(widget.product.id)
                  ? true
                  : (state.status == FavoritesStatus.initial
                      ? widget.product.isFavorite
                      : false);

              return _buildCircleButton(
                icon: isFav ? Icons.favorite : Icons.favorite_border,
                iconColor: isFav ? AppColors.red : AppColors.primary,
                onTap: () {
                  context.read<FavoritesCubit>().toggleFavorite(widget.product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImage(String url) {
    return Hero(tag: widget.heroTag, child: _buildNetworkImage(url));
  }

  Widget _buildNetworkImage(String url) {
    if (url.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textLightGray,
          size: 60,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      width: double.infinity,
      height: 320.h,
      placeholder: (_, _) => Container(color: AppColors.inputFill),
      errorWidget: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textLightGray,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: AppColors.primaryTint,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(child: Icon(icon, color: iconColor, size: 20)),
      ),
    );
  }
}
