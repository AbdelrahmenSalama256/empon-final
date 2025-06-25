import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreFollowers extends StatelessWidget {
  final int followersCount;
  final String logo;
  const HomeStoreFollowers(
      {super.key, required this.followersCount, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: followersCount > 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              logo != null
                  ? Image.network(
                      logo,
                      width: 36.w,
                      height: 36.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                            color: AppColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
              for (int i = 0; i < 3; i++)
                Positioned.directional(
                  start: i * 25.w,
                  textDirection: context.read<GlobalCubit>().language == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
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
        ),
        Visibility(visible: followersCount > 0, child: SizedBox(width: 100.w)),
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
                text: " $followersCount ",
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
