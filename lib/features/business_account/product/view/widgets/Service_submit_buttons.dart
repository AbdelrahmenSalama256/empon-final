import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceSubmitButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ServiceSubmitButtons({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listener: (context, state) {
        if (state is ServiceSuccess) {
          showToast(
            context,
            message: state.model.message ?? 'Success',
            state: ToastStates.success,
          );
          Navigator.pop(context);
        } else if (state is ServiceError) {
          showToast(
            context,
            message: state.error,
            state: ToastStates.error,
          );
        }
      },
      child: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          final globalCubit = context.read<GlobalCubit>();
          final cubit = context.read<ServiceCubit>();

          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              AppButton(
                text: 'service_add_subtitle'.tr(context),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    cubit.accountId = globalCubit.businessId;
                    cubit.createService();
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
        },
      ),
    );
  }
}
