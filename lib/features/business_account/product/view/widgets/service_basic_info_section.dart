import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ServiceBasicInfoSection extends StatelessWidget {
  const ServiceBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =context.read<ServiceCubit>().nameController;
    return Column(
      children: [
        // Service Name Field
        AppTextField(
            controller: controller ,
          hintText: 'service_name'.tr(context),
          prefixIcon: Padding(
            padding: EdgeInsets.all(13.w),
            child: SvgPicture.asset(
              "assets/images/svg/product_name.svg",
              width: 24.w,
              height: 24.h,
            ),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'field_required'.tr(context) : null,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
