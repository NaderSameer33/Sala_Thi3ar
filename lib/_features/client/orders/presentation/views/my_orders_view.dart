import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'طلباتي',
          style: AppStyles.font18BoldDark,
        ),
      ),
      body: Center(
        child: Text(
          'طلباتي',
          style: AppStyles.font18BoldPrimary,
        ),
      ),
    );
  }
}
