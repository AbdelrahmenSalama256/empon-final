import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/widgets/update_product_form.dart';
import 'package:embone/features/business_account/product/view/widgets/update_service_form.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UpdateProductPage extends StatelessWidget {
  ProductModel? productData;
  ServiceModel? serviceData;
  bool isService = false;
  final int businessAccountId;
  UpdateProductPage({
    super.key,
    required this.businessAccountId,
    this.productData,
    required this.isService,
    this.serviceData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => ProductCubit(sl<ProductRepo>()),
        child: SafeArea(
          child: Column(
            children: [
              isService == false
                  // Header
                  ? AppHeader(
                      title: 'update_product_title'.tr(context),
                      centerTitle: true,
                      showBackButton: true,
                      onBackPressed: () => Navigator.pop(context),
                    )
                  : AppHeader(
                      title: 'update_Service_title'.tr(context),
                      centerTitle: true,
                      showBackButton: true,
                      onBackPressed: () => Navigator.pop(context),
                    ),
              isService == false
                  ? Expanded(
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
                            UpdateProductForm(
                              productData: productData,
                              accountId: businessAccountId,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  'service_add_button'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Divider(height: 1.h),

                                // Main form content
                                 UpdateServiceForm(
                                  serviceData: serviceData,
                                ),
                              ],
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
