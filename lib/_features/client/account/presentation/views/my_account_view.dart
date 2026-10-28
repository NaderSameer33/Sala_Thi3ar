import 'package:flutter/material.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حسابي',
          style: AppStyles.font18BoldDark,
        ),
      ),
      body: Center(
        child: Text(
          'حسابي',
          style: AppStyles.font18BoldPrimary,
        ),
      ),
    );
  }
}
