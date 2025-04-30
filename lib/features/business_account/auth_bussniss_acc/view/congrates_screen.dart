import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CongratesScreen extends StatelessWidget {
  const CongratesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'congrates'.tr(context),
                        style: TextStyle(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                      SizedBox(height: 32.h.h),

                      // Success icon
                      SvgPicture.asset(
                        'assets/images/svg/congrates.svg',
                        width: double.infinity,
                        height: 324.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 16.h),
                      Text(
                        'store_note'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffA0A0A0),
                          height: 1.5.h,
                        ),
                      ),

                      // SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'home'.tr(context),
                      type: AppButtonType.secondary,
                      onPressed: () {
                        context
                            .read<GlobalCubit>()
                            .setUserType(UserType.business);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      text: 'add_product'.tr(context),
                      onPressed: () {
                        navigateTo(context, const AddProductPage());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h.h),
            ],
          ),
        ),
      ),
    );
  }
}
