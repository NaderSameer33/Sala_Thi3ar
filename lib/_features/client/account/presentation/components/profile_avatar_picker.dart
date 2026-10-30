import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String imageUrl;
  final File? localImage;
  final ValueChanged<File> onImagePicked;

  const ProfileAvatarPicker({
    super.key,
    required this.imageUrl,
    this.localImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  void _showPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.white,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                16.verticalSpacing,
                Text(
                  'اختيار صورة الملف الشخصي',
                  style: AppStyles.font16BoldDark,
                ),
                16.verticalSpacing,
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                  title: Text('الكاميرا', style: AppStyles.font14MediumDark),
                  onTap: () => _pickImage(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  title: Text('المعرض', style: AppStyles.font14MediumDark),
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPickerBottomSheet(context),
      child: Center(
        child: Container(
          width: 88.r,
          height: 88.r,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withAlpha(60),
              width: 1.5.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (localImage != null)
                  Image.file(
                    localImage!,
                    fit: BoxFit.cover,
                  )
                else if (imageUrl.isNotEmpty)
                  CachedNetworkImage(
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
                else
                  Image.asset(
                    'assets/images/User.png',
                    fit: BoxFit.contain,
                  ),
                Container(
                  color: Colors.black.withAlpha(60),
                ),
                Center(
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withAlpha(100),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.white,
                      size: 18.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

