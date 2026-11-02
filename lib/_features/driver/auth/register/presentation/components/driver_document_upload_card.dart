import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class DriverDocumentUploadCard extends StatelessWidget {
  final String label;
  final File? imageFile;
  final ValueChanged<ImageSource> onSelectSource;

  const DriverDocumentUploadCard({
    super.key,
    required this.label,
    required this.imageFile,
    required this.onSelectSource,
  });

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetContext) {
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
                  label,
                  style: AppStyles.font16BoldDark,
                ),
                16.verticalSpacing,
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                  title: Text('الكاميرا', style: AppStyles.font14MediumDark),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelectSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  title: Text('معرض الصور', style: AppStyles.font14MediumDark),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelectSource(ImageSource.gallery);
                  },
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
    final hasImage = imageFile != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _showSourceSheet(context),
          child: Container(
            width: 78.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: hasImage ? Colors.transparent : const Color(0xFFF9FBF8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: hasImage ? AppColors.primary : const Color(0xFFC7D3C5),
                style: BorderStyle.solid,
                width: 1.2,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withAlpha(50),
                        ),
                        const Center(
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
          ),
        ),
        6.verticalSpacing,
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: hasImage ? AppColors.primary : AppColors.textLightGray,
            fontWeight: hasImage ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
