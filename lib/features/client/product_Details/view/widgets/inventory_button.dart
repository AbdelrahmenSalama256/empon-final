import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InventoryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InventoryButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'available_qunatity_from_this_product'.tr(context),
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      prefixIcon: SvgPicture.asset(
        "assets/images/svg/categorys.svg",
        width: 24.w,
        height: 24.h,
      ),
    );
  }
}
