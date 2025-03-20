import 'package:embone/core/component/widgets/app_theme.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/localization_settings.dart';
import 'package:embone/features/auth/view/pages/splash_screen.dart';
import 'package:embone/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/service_locator.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Embone extends StatelessWidget {
  const Embone({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              key: navigatorKey,
              theme: AppTheme.getLightTheme(sl<GlobalCubit>().language),

              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaler
                    .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: scale),
                  child: child!,
                );
              },
              debugShowCheckedModeBanner: false,
              //!Localization Settings
              localizationsDelegates: localizationsDelegatesList,
              supportedLocales: supportedLocalesList,
              locale: Locale(sl<GlobalCubit>().language),

              //!App Scroll Behavior
              scrollBehavior: ScrollConfiguration.of(context)
                  .copyWith(physics: const ClampingScrollPhysics()),
              //! Theme

              //!Routing
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
}
