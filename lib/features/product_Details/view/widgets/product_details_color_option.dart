import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorOptionsSection extends StatelessWidget {
  final List<Color> availableColors;
  final int selectedColorIndex;
  final Function(int) onColorSelected;

  const ColorOptionsSection({
    Key? key,
    required this.availableColors,
    required this.selectedColorIndex,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Label
          Text(
            'اللون المختار',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.end,
          ),

          SizedBox(height: 8.h),

          // Color options
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              availableColors.length,
              (index) => GestureDetector(
                onTap: () => onColorSelected(index),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: availableColors[index],
                    border: Border.all(
                      color: selectedColorIndex == index
                          ? Colors.black
                          : Colors.transparent,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
