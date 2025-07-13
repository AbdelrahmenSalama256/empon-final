import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app/embone.dart';
import '../../../../core/cubit/global_cubit.dart';

class GuestRestrictedScreen extends StatelessWidget {
  final String message;
  final Widget child;
  final bool isGuest;

  const GuestRestrictedScreen({
    super.key,
    required this.message,
    required this.child,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 50.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    message.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  AppButton(
                    onPressed: () {
                      context.read<GlobalCubit>().changeBottomNavIndex(0);

                      navigatorKey.currentState!.push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    text: 'login'.tr(context),
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () {
                      navigateTo(context, const IntroPage());
                    },
                    child: Text(
                      'continue_browsing'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return child;
  }
}
