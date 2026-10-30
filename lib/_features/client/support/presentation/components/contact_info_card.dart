import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/contact_info_model.dart';

class ContactInfoCard extends StatelessWidget {
  final ContactInfoModel contactInfo;

  const ContactInfoCard({super.key, required this.contactInfo});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(contactInfo.lat, contactInfo.lng);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 180.h,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: position,
                    zoom: 14,
                  ),
                  liteModeEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 42.r,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              children: [
                if (contactInfo.location.isNotEmpty) ...[
                  _buildInfoRow(
                    icon: Icons.location_on_rounded,
                    text: contactInfo.location,
                  ),
                  SizedBox(height: 10.h),
                ],
                if (contactInfo.phone.isNotEmpty) ...[
                  _buildInfoRow(
                    icon: Icons.phone_rounded,
                    text: contactInfo.phone,
                  ),
                  SizedBox(height: 10.h),
                ],
                if (contactInfo.email.isNotEmpty)
                  _buildInfoRow(
                    icon: Icons.mail_outline_rounded,
                    text: contactInfo.email,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.r,
          color: AppColors.primary,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: AppStyles.font14RegularDark.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

