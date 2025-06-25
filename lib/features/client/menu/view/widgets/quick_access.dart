import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickAccessButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback? onTap;
  final bool? needSubTitle;
  final String? subTitle;
  final Color ? subTitleColor;


  const QuickAccessButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap, 
    this.needSubTitle, 
    this.subTitle, this.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          // ignore: deprecated_member_use
          border: Border.all(color: const Color(0xff000000).withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              // decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Image.asset(icon, width: 24.w, height: 24.h),
            ),
            SizedBox(width: 8.w),
            needSubTitle == true ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              title,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              
            ),
            SizedBox(height: 4.h),
            Text(
              subTitle!,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: subTitleColor,
              ),
            ),

              ]

            )
            
            :Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
