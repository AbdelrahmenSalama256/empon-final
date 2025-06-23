import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceSubmitButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;


  const ServiceSubmitButtons({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceCubit>();
    return  Column(
          children: [
            AppButton(
              text: 'service_add_subtitle'.tr(context),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  cubit.accountId = int.parse(sl<CacheHelper>().getDataString(key: AppConstants.businessAccountId) ?? '0');
                  cubit.createService();
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
