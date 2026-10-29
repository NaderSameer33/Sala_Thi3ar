import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المفضلة',
          style: AppStyles.font18BoldDark,
        ),
      ),
      body: Center(
        child: Text(
          'المفضلة',
          style: AppStyles.font18BoldPrimary,
        ),
      ),
    );
  }
}
