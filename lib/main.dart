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

import 'features/client/notifications/data/repo/notifications_repo.dart';
import 'features/client/notifications/view/cubit/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp();
  Future.wait(
    [
      NotificationHandler.init(),
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
        BlocProvider<NotificationsCubit>(
          create: (context) =>
              NotificationsCubit(sl<NotificationsRepo>())..init(),
        ),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const Embone(),
      ),
    ),
  );
}
