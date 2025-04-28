import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/cubit/global_cubit.dart';

class HomeStoreFollowers extends StatelessWidget {
  const HomeStoreFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              'assets/images/profile.png',
              width: 36.w,
              height: 36.h,
            ),
            for (int i = 0; i < 3; i++)
              Positioned.directional(
                start: i * 20.w,
                textDirection: context.read<GlobalCubit>().language == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.w),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/brand-logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 50.w),
        Text(
          'followers_count'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff1E2644),
          ),
        ),
        SizedBox(width: 10.w),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '512 ألف',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1E2644),
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? "Beiruti"
                      : "Poppins",
                ),
              ),
              TextSpan(
                text: 'followers'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xff1E2644),
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? "Beiruti"
                      : "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
