import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/first_name_page.dart';
import 'package:embone/features/client/auth/view/pages/searching_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/logo_text.png',
                        height: 32.h,
                        width: 118.w,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'join_empon'.tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/images/svg/welcome.svg',
                width: 326.w,
                height: 244.h,
              ),
              SizedBox(height: 32.h),
              Text(
                'welcome_to_empon'.tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'welcome_subtitle'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              AppButton(
                text: 'join_and_use'.tr(context),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => RegisterCubit(sl<RegisterRepo>()),
                        child: FirstNamePage(
                          onNextStep: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              AppButton(
                type: AppButtonType.secondary,
                text: 'search_my_account'.tr(context),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
                        child: const SearchingAccountPage(),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
