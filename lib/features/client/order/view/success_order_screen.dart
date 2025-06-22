import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessOrderScreen extends StatelessWidget {
  const SuccessOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/svg/bags.svg',
                      width: 208.w,
                      height: 213.h,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'success_order_title'.tr(context),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'success_order_subtitle'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.h),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   'success_order_number_label'.tr(context),
                        //   style: TextStyle(
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.primary,
                        //   ),
                        // ),
                        // SizedBox(width: 4.h),
                        // Text(
                        //   '1947034', // Hardcoded for now; can be dynamic
                        //   style: TextStyle(
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.primary,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'thanks_for_using_embone'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: AppButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<GlobalCubit>().changeBottomNavIndex(0);
                  },
                  text: 'success_order_back_to_home_button'.tr(context),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
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
