import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account_add_settings.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/menu/view/inner_screens/help_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BusinessAccountSuccessPage extends StatelessWidget {
  const BusinessAccountSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    //PrintUtil.debug(context.read<AccountCubit>().nameController.text);

    return BlocProvider(
      create: (context) => AccountCubit(sl<AccountRepo>()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocProvider(
          create: (context) => AccountCubit(sl<AccountRepo>()),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Success icon
                          Center(
                            child: SvgPicture.asset(
                              'assets/images/svg/success_icon.svg',
                              width: double.infinity,
                              height: 253.h,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            'business_account_created'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            '•  ${'compliance_requirement'.tr(context)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff7C7C7C),
                              height: 2.0.h,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '•  ${'account_note'.tr(context)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff7C7C7C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons
                  Column(
                    children: [
                      AppButton(
                        text: 'continue'.tr(context),
                        onPressed: () {
                          navigateTo(
                              context,
                              BlocProvider.value(
                                value: context.read<AccountCubit>(),
                                child: const CreateBusinessAccountSettings(),
                              ));
                        },
                      ),
                      SizedBox(height: 12.h),
                      AppButton(
                        text: 'help_support'.tr(context),
                        type: AppButtonType.secondary,
                        onPressed: () {
                          navigateTo(
                              context,
                              BlocProvider.value(
                                value: context.read<AccountCubit>(),
                                child: const HelpSupportPage(),
                              ));
                        },
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
