// ignore_for_file: deprecated_member_use

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_account_categorey.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'cubit/account_state.dart';

class CreateBusinessAccountTypePage extends StatelessWidget {
  const CreateBusinessAccountTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountCubit(sl<AccountRepo>()),
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          final cubit = context.read<AccountCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
                child: Column(
              children: [
                // Header
                AppHeader(
                  title: 'create_business_account'.tr(context),
                  centerTitle: true,
                  showBackButton: true,
                  onBackPressed: () => Navigator.pop(context),
                  style: HeaderStyle.standard,
                ),
                SizedBox(height: 24.h),
                //! Business account title and description
                Container(
                  margin: EdgeInsets.all(10.w),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F8F8),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'business_account_title'.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // Subtitle
                            Text(
                              'business_account_subtitle'.tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Description
                            Text(
                              'business_account_description'.tr(context),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/svg/create_bussins.svg",
                        width: 106.w,
                        height: 116.h,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.h),
                          // Business account name section
                          Text(
                            'business_account_name_question'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Subtitle
                          Text(
                            'business_account_name_instructions'.tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff7C7C7C),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          // Business name field
                          AppTextField(
                            controller: cubit.nameController,
                            labelText:
                                'business_account_name_label'.tr(context),
                            hintText: 'business_account_name_hint'.tr(context),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(13.w),
                              child: SvgPicture.asset(
                                "assets/images/svg/store.svg",
                                width: 20.w,
                                height: 20.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            onChanged: (value) => cubit.updateName(value),
                          ),
                          SizedBox(height: 18.h),
                          // Bottom buttons
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.h),
                            child: Column(
                              children: [
                                AppButton(
                                  text: 'next'.tr(context),
                                  onPressed: () {
                                    if (cubit.nameController.text.isEmpty) {
                                      return;
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) => AccountCubit(
                                                  sl<AccountRepo>(),
                                                  name: cubit
                                                      .nameController.text),
                                              child:
                                                  const CreateBusinessAccountDetailsPage(),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      ),
    );
  }
}
