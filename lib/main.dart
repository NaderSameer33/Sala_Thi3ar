import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/logic/theme_cubit.dart';
import 'core/theme/logic/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

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
        return BlocBuilder<ThemeCubit, ThemeState>(
          bloc: getIt<ThemeCubit>(),
          builder: (context, themeState) {
            return MaterialApp.router(
              title: 'سلة ثمار',
              debugShowCheckedModeBanner: false,
              locale: const Locale('ar'),
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, routerChild) {
                final previewChild = DevicePreview.appBuilder(context, routerChild);
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: previewChild,
                );
              },
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
