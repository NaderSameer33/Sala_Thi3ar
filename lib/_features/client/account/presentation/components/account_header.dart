import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/user_profile_model.dart';

class AccountHeader extends StatelessWidget {
  final UserProfileModel? profile;

  const AccountHeader({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile?.fullname.isNotEmpty == true
        ? profile!.fullname
        : 'محمد علي';
    final rawPhone = profile?.phone ?? '96654787856';
    final formattedPhone = rawPhone.startsWith('+') ? rawPhone : '+$rawPhone';
    final imageUrl = profile?.image ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32.r),
        bottomRight: Radius.circular(32.r),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -40.h,
              right: -30.w,
              child: Container(
                width: 170.r,
                height: 170.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(14),
                ),
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -30.w,
              child: Container(
                width: 150.r,
                height: 150.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(14),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'حسابي',
                      style: AppStyles.font18BoldDark.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    16.verticalSpacing,
                    Container(
                      width: 74.r,
                      height: 74.r,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.white.withAlpha(200),
                          width: 2.r,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 10.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.primaryTint,
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/User.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                'assets/images/User.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    10.verticalSpacing,
                    Text(
                      name,
                      style: AppStyles.font16BoldDark.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpacing,
                    Text(
                      formattedPhone,
                      style: AppStyles.font14RegularGray.copyWith(
                        color: AppColors.white.withAlpha(220),
                        fontFamily: AppStyles.fontFamily,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    12.verticalSpacing,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

