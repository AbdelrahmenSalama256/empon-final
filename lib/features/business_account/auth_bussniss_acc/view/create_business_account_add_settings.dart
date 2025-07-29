import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/business_account_settings.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/contact_info_step.dart';
import 'package:embone/features/business_account/profile/add_profile_buisniss_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/custom_toast.dart';
import 'cubit/account_state.dart';

class CreateBusinessAccountSettings extends StatelessWidget {
  final bool? isFromSetting;
  const CreateBusinessAccountSettings({super.key, this.isFromSetting});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        AccountCubit cubit = context.read<AccountCubit>();
        PrintUtil.debug(cubit.selectedCityId);
        PrintUtil.debug(cubit.nameController.text);
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: isFromSetting == true
                      ? 'edit_business_profile'.tr(context)
                      : 'continue_business_account'.tr(context),
                  centerTitle: true,
                  showBackButton: true,
                  onBackPressed: () => Navigator.pop(context),
                  style: HeaderStyle.standard,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const BusinessAccountSettings(
                          // cubit: cubit,
                          isUpdate: false,
                        ),
                        ContactInfoStep(
                          cubit: cubit,
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: AppButton(
                              text: 'next'.tr(context),
                              onPressed: () async {
                                if (cubit.descriptionController.text.isEmpty ||
                                    cubit.phoneController.text.isEmpty ||
                                    cubit.emailController.text.isEmpty) {
                                  showToast(
                                    context,
                                    message:
                                        'required_fields_missing'.tr(context),
                                    state: ToastStates.error,
                                  );
                                  return;
                                } else  {
                                  cubit.updateDescription(
                                      cubit.descriptionController.text);
                                  cubit.updateVideoUrl(
                                      cubit.videoUrlController.text);
                                 final res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddProfilePhotoForBuisnissAccountPage(
                                        cubit: cubit,
                                      ),
                                    ),
                                  );
                                  cubit = res;
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
