import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductAvailabilityToggle extends StatelessWidget {
  final bool isAvailable;
  final ValueChanged<bool> onChanged;

  const ProductAvailabilityToggle({
    super.key,
    required this.isAvailable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'متوفر',
          style: TextStyle(
            fontSize: 9.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        CupertinoSwitch(
          value: isAvailable,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}
