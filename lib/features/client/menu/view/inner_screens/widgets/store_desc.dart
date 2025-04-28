import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreDescription extends StatelessWidget {
  const StoreDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store name
          Text(
            'عن كومفرت شورا',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),

          // Store description
          Text(
            'أديداس هي شركة ماليس رياضية مقرها ألمانيا، ونعد جزءاً من مجموعة أديداس التي تتألف من شركة ريبوك للماليس الرياضية وشركة تابلورميد لمنتجات الجواف. وشركة روكبورت للأحدية الرياضية التي باعتها أديداس سنة 2015 لشركة نيو بالانس.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
