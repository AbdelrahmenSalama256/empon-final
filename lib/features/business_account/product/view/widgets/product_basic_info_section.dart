import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProductBasicInfoSection extends StatelessWidget {
  const ProductBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product Name Field
        AppTextField(
          controller: TextEditingController(),
          hintText: 'product_name_hint'.tr(context),
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
