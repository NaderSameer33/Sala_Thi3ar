import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '_features/client/cart/logic/cart_cubit.dart';
import '_features/client/cart/logic/cart_state.dart';
import '_features/client/favorites/logic/favorites_cubit.dart';
import 'core/caching/shared_pref_service.dart';
import 'core/routers/app_routes.dart';
import 'core/services/get_it_service.dart';
import 'core/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefService.init();
  setupGetIt();

  final initialRoute = await AppRoutes.getInitialRoute();
  AppRoutes.init(initialRoute);

  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<FavoritesCubit>()..getFavorites()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp.router(
              title: 'سلة ثمار',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: AppRoutes.routeConfig,
              locale: const Locale('ar'),
              supportedLocales: const [Locale('ar'), Locale('en')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, routerChild) {
                return ToastificationWrapper(
                  child: BlocListener<CartCubit, CartState>(
                    listenWhen: (prev, curr) =>
                        curr.mutationMessage.isNotEmpty &&
                        prev.mutationMessage != curr.mutationMessage,
                    listener: (context, state) {
                      if (state.mutationMessage.isNotEmpty) {
                        toastification.show(
                          context: context,
                          title: Text(
                            state.mutationMessage,
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                      }
                    },
                    child: routerChild ?? const SizedBox.shrink(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
