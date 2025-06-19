import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';

import 'widgets/add_product_form.dart';

class AddProductPage extends StatelessWidget {
  final int businessAccountId;
  const AddProductPage({super.key, required this.businessAccountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'add_product_title'.tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'product_add_button'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 1.h),

                    // Main form content
                    const AddProductForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
