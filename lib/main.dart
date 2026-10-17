import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_styles.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const SalaThimarApp(),
    ),
  );
}

class SalaThimarApp extends StatelessWidget {
  const SalaThimarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'سلة ثمار',
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context) ?? const Locale('ar'),
          builder: DevicePreview.appBuilder,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: child,
        );
      },
      child: Scaffold(
        body: Center(
          child: Text(
            'سلة ثمار',
            style: AppStyles.font24BoldPrimary,
          ),
        ),
      ),
    );
  }
}
