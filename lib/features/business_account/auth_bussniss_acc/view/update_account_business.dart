// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_state.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/business_account_settings.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/contact_info_step.dart';

class UpdateBusinessAccount extends StatefulWidget {
 final Account accountData;



  const UpdateBusinessAccount({
    super.key,
    required this.accountData,
  });

  @override
  State<UpdateBusinessAccount> createState() => _UpdateBusinessAccountState();
}

class _UpdateBusinessAccountState extends State<UpdateBusinessAccount> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        context.read<AccountCubit>().initControllers(
          model: widget.accountData
        );
        final cubit = context.read<AccountCubit>();
        PrintUtil.debug(cubit.selectedCityId);
        PrintUtil.debug(cubit.nameController.text);
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: 'edit_business_profile'.tr(context),
                  centerTitle: true,
                  showBackButton: true,
                  onBackPressed: () => Navigator.pop(context),
                  style: HeaderStyle.standard,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BusinessAccountSettings(
                          cubit: cubit,
                          isUpdate: true,
                        ),
                        ContactInfoStep(
                          cubit: cubit,
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: AppButton(
                            text: 'update'.tr(context),
                            onPressed: () {
                              cubit.updateDescription(
                                  cubit.descriptionController.text);
                              cubit.updateVideoUrl(
                                  cubit.videoUrlController.text);
                              cubit.updateAccount(accountId:context.read<GlobalCubit>().businessId!);
                              Navigator.pop(context);
                            },
                          ),
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