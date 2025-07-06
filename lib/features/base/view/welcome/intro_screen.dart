import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:embone/features/client/auth/view/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svg/welcome.svg',
                          width: 326.w,
                          height: 244.h,
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'welcome'.tr(context),
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'profile_welcome_message'.tr(context),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Column(
                          children: [
                            AppButton(
                              text: 'login'.tr(context),
                              onPressed: () {
                                navigateTo(context, const LoginPage());
                              },
                            ),
                            SizedBox(height: 16.h),
                            AppButton(
                              text: 'register'.tr(context),
                              type: AppButtonType.secondary,
                              onPressed: () {
                                navigateTo(
                                    context,
                                    BlocProvider(
                                      create: (context) =>
                                          RegisterCubit(sl<RegisterRepo>()),
                                      child: const RegisterPage(),
                                    ));
                              },
                            ),
                            SizedBox(height: 16.h),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                    context,
                                    const BaseScreen(
                                      isGuest: true,
                                    ));
                              },
                              child: Text('guest_login'.tr(context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.grey,
                                      )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
