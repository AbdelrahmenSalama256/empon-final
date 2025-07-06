import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/custom_cached_image.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreFollowers extends StatelessWidget {
  final int followersCount;
  final BusinessAccountCubit?
      businessAccountCubit; // Optional cubit for dynamic data
  const HomeStoreFollowers({
    super.key,
    required this.followersCount,
    this.businessAccountCubit,
  });

  @override
  Widget build(BuildContext context) {
    final accountCubit =
        businessAccountCubit ?? context.read<BusinessAccountCubit>();
    final followers = accountCubit.accountData?.data.followers ?? [];

    return Row(
      children: [
        Visibility(
          visible: followersCount > 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main logo (first follower or account logo if no followers)
              if (followers.isNotEmpty)
                CustomCachedImage(
                  imageUrl: followers[0].user.image ??
                      accountCubit.accountData?.data.logo ??
                      '',
                  h: 36.h,
                  w: 36.w,
                  borderRadius: 100.r,
                  fit: BoxFit.cover,
                )
              else if (accountCubit.accountData?.data.logo != null)
                Image.network(
                  accountCubit.accountData!.data.logo!,
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
              else
                Container(
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
              // Additional follower logos (up to 3)
              for (int i = 1; i < followers.length && i < 4; i++)
                Positioned.directional(
                  start: (i - 1) * 25.w,
                  textDirection: context.read<GlobalCubit>().language == "ar"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: CustomCachedImage(
                    imageUrl: followers[0].user.image ??
                        accountCubit.accountData?.data.logo ??
                        '',
                    h: 36.h,
                    w: 36.w,
                    borderRadius: 100.r,
                    fit: BoxFit.cover,
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
