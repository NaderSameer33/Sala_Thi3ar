import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_details_model.dart';

class OrderDetailsAddressCard extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsAddressCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'عنوان التوصيل',
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.verticalSpacing,
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.border,
              width: 1.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.addressTitle.isNotEmpty ? order.addressTitle : 'المنزل',
                      style: AppStyles.font14BoldDark.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    2.verticalSpacing,
                    if (order.addressDescription.isNotEmpty)
                      Text(
                        order.addressDescription,
                        style: AppStyles.font12RegularGray.copyWith(
                          color: AppColors.textLightGray,
                        ),
                      ),
                    2.verticalSpacing,
                    Text(
                      order.addressLocation.isNotEmpty
                          ? order.addressLocation
                          : 'شارع العليا الرياض 12521 السعودية',
                      style: AppStyles.font12RegularGray,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              14.horizontalSpace,
              _buildMiniMap(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniMap() {
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(72.r, 72.r),
            painter: _MapGridPainter(),
          ),
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 4.r,
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              size: 18.r,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD6DBDF)
      ..strokeWidth = 4;

    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width * 0.6, size.height), roadPaint);

    final greenAreaPaint = Paint()
      ..color = const Color(0xFFD4E6D2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 4, size.width * 0.35, size.height * 0.3),
        const Radius.circular(4),
      ),
      greenAreaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

