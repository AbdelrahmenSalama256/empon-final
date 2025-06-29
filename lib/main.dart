import 'package:device_preview/device_preview.dart';
import 'package:embone/core/app/embone.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/notification/notification_handler.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';

import 'core/notification/local_notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp();
  Future.wait(
    [
      NotificationHandler.init(),
      LocalNotificationService.init(),
    ],
  );

  //! Orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //! Status Bar Settings
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //! Service Locator
  initServiceLocator();
  //! Update Checker
  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }
  //! Cache Helper
  await sl<CacheHelper>().init();
  //! Application Starts From here.
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalCubit>()..init(),
        ),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,

        // enabled: false,
        builder: (context) => UpgradeAlert(
            upgrader: Upgrader(
              // minAppVersion: "1.0.1",
              //  debugLogging: true,
              debugDisplayAlways: true,
            ),
            // navigatorKey: AppRouter.router.routerDelegate
            // .navigatorKey, // Provide a fallback for child
            dialogStyle: UpgradeDialogStyle.cupertino,
            child: const Embone()),
      ),
    ),
  );
}
