import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSubmitButtons extends StatelessWidget {
  final int accountId;
  final bool isUpdate;
  final ProductModel? productData;
  final GlobalKey<FormState> formKey;

  const ProductSubmitButtons(
      {super.key,
      required this.formKey,
      required this.accountId,
      required this.isUpdate,
      this.productData});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductLoading) {
          const Center(child: CircularProgressIndicator());
        }
        if (state is ProductSuccess) {
          showToast(context,
              message: state.product.message!, state: ToastStates.success);
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
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
      }),
    );
  }
}
