// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';

class ServiceSubmitButtons extends StatelessWidget {
  final bool isUpdate;
  final int? serviceId;
  final GlobalKey<FormState> formKey;


  const ServiceSubmitButtons({
    super.key,
    required this.isUpdate,
    this.serviceId,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final globalCubit = context.read<GlobalCubit>();
    final cubit = context.read<ServiceCubit>();
    return Column(
      children: [
        AppButton(
          text: 'service_add_subtitle'.tr(context),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              cubit.accountId =  globalCubit.businessId;
              // int.parse(sl<CacheHelper>()
              //         .getDataString(key: AppConstants.businessAccountId) ??
              //     '0');
              isUpdate?
              cubit.updateService(serviceId!)

              :cubit.createService();
              // Submit logic
            }
          },
        ),
        SizedBox(height: 8.h),
        AppButton(
          text: 'home'.tr(context),
          type: AppButtonType.secondary,
          onPressed: () {
            context.read<GlobalCubit>().setUserType(UserType.business);
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
