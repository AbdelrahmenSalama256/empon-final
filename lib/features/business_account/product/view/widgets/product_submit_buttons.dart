import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSubmitButtons extends StatelessWidget {
  final int accountId;
  final GlobalKey<FormState> formKey;

  const ProductSubmitButtons({super.key, required this.formKey, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      final cubit = context.read<ProductCubit>();

      return Column(
        children: [
          AppButton(
            text: 'add_product_button'.tr(context),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
              cubit.addProduct(accountId);
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
    });
  }
}
