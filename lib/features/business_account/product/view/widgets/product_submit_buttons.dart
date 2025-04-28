import 'package:embone/core/cubit/global_cubit.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSubmitButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ProductSubmitButtons({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'add_product_button'.tr(context),
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
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
