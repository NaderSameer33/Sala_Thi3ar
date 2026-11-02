import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/rating/data/repos/rating_repo.dart';
import 'package:sala_thimar/_features/client/rating/presentation/components/rate_success_dialog.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/helper/helper_method.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';

class RateProductBottomSheet extends StatefulWidget {
  final int productId;
  final String productTitle;
  final String? productImage;
  final String? productPrice;
  final VoidCallback? onRatingSuccess;

  const RateProductBottomSheet({
    super.key,
    required this.productId,
    required this.productTitle,
    this.productImage,
    this.productPrice,
    this.onRatingSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required int productId,
    required String productTitle,
    String? productImage,
    String? productPrice,
    VoidCallback? onRatingSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RateProductBottomSheet(
        productId: productId,
        productTitle: productTitle,
        productImage: productImage,
        productPrice: productPrice,
        onRatingSuccess: onRatingSuccess,
      ),
    );
  }

  @override
  State<RateProductBottomSheet> createState() => _RateProductBottomSheetState();
}

class _RateProductBottomSheetState extends State<RateProductBottomSheet> {
  int _rating = 5;
  late final TextEditingController _commentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 5:
        return 'ممتاز جداً 🌟';
      case 4:
        return 'جيد جداً 👍';
      case 3:
        return 'جيد 🙂';
      case 2:
        return 'مقبول 😐';
      case 1:
      default:
        return 'سيء 🙁';
    }
  }

  Future<void> _submitRating() async {
    setState(() => _isLoading = true);

    final repo = getIt<RatingRepo>();
    final result = await repo.rateProduct(
      productId: widget.productId,
      value: _rating,
      comment: _commentController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        showToast(
          context: context,
          message: failure.message,
          isError: true,
        );
      },
      (_) {
        Navigator.of(context).pop();
        RateSuccessDialog.show(
          context,
          onDismiss: widget.onRatingSuccess,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              12.verticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تقييم المنتج',
                    style: AppStyles.font18BoldPrimary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textGray),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              10.verticalSpacing,
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryVeryLight,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.primaryTint),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: widget.productImage != null &&
                              widget.productImage!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.productImage!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/tomato.png',
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              'assets/images/tomato.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productTitle,
                            style: AppStyles.font14BoldDark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.productPrice != null &&
                              widget.productPrice!.isNotEmpty) ...[
                            4.verticalSpacing,
                            Text(
                              '${widget.productPrice} ر.س',
                              style: AppStyles.font14BoldPrimary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpacing,
              Center(
                child: Text(
                  'ما هو تقييمك لهذا المنتج؟',
                  style: AppStyles.font14BoldDark,
                ),
              ),
              8.verticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isSelected = starIndex <= _rating;

                  return GestureDetector(
                    onTap: () => setState(() => _rating = starIndex),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        isSelected
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isSelected
                            ? AppColors.orange
                            : AppColors.inputBorder,
                        size: 38.r,
                      ),
                    ),
                  );
                }),
              ),
              6.verticalSpacing,
              Center(
                child: Text(
                  _ratingLabel,
                  style: AppStyles.font14BoldPrimary,
                ),
              ),
              16.verticalSpacing,
              Text(
                'تعليقك على المنتج',
                style: AppStyles.font14BoldDark,
              ),
              8.verticalSpacing,
              TextField(
                controller: _commentController,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                style: AppStyles.font14RegularDark,
                decoration: InputDecoration(
                  hintText: 'اكتب رأيك وتجربتك مع هذا المنتج...',
                  hintStyle: AppStyles.font12RegularGray,
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: EdgeInsets.all(12.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              20.verticalSpacing,
              AppButton(
                text: 'إرسال التقييم',
                isLoading: _isLoading,
                backgroundColor: AppColors.primary,
                onPressed: _submitRating,
              ),
              10.verticalSpacing,
            ],
          ),
        ),
      ),
    );
  }
}
