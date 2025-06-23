import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_svg/svg.dart';

class ServiceDetailsSection extends StatefulWidget {
  const ServiceDetailsSection({super.key});

  @override
  State<ServiceDetailsSection> createState() => _ServiceDetailsSectionState();
}

class _ServiceDetailsSectionState extends State<ServiceDetailsSection> {
  List<Map<String, TextEditingController>> serviceDetailsControllers = [];

  void addServiceDetail() {
    serviceDetailsControllers.add({

    });
    setState(() {});
  }

  @override
  void initState() {
    context.read<ServiceCubit>().getServiceCategories();
    super.initState();
  }

  @override
  void dispose() {
    for (var item in serviceDetailsControllers) {
      item['price']?.dispose();
      item['description']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        final cubit = context.read<ServiceCubit>();

        return Column(
          children: [
            /// Price Field
            AppTextField(
              controller: cubit.priceController,
              hintText: 'price_hint'.tr(context),
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: SvgPicture.asset(
                  "assets/images/svg/price.svg",
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              validator: (value) => Validators.validateRequired(
                  value, 'price_hint'.tr(context), context),
            ),
            SizedBox(height: 20.h),

            /// Product Details
            AppTextField(
              controller: cubit.detailsController,
              hintText: 'service_details'.tr(context),
              maxLines: 5,
              keyboardType: TextInputType.text,
              validator: (value) => Validators.validateRequired(
                  value, 'service_details'.tr(context), context),
            ),
            SizedBox(height: 20.h),

            /// Category Dropdown
            if (cubit.categories.isNotEmpty)
              AppDropdownField(
                hint: 'category'.tr(context),
                value: cubit.categoryServiceId != null
                    ? cubit.categories
                        .firstWhere((c) => c.id == cubit.categoryServiceId)
                        .name
                    : null,
                isMultiSelect: false,
                items: cubit.categories.map((c) => c.name).toList(),
                selectedValues: cubit.categories
                    .where((c) => cubit.selectedCategoryIds.contains(c.id))
                    .map((c) => c.name)
                    .toList(),
                onChanged: (value) {
                  final selected =
                      cubit.categories.firstWhere((c) => c.name == value);
                  cubit.categoryServiceId = selected.id;
                  setState(() {});
                },
                validator: (value) {
                  if (cubit.categoryServiceId == null) {
                    return 'please_select_category'.tr(context);
                  }
                  return null;
                },
                showErrorBorder: true,
              ),

            SizedBox(height: 20.h),
                Text("additional_service_Details".tr(context),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold)), //todo: make localized
            SizedBox(height: 10.h),
            Column(
              children: [
                ...List.generate(serviceDetailsControllers.length, (index) {
                  final item = serviceDetailsControllers[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Expanded(
                        child: AppTextField(
                          controller: item['price']!,
                          hintText: 'price_hint'.tr(context),
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.validateRequired(
                              value, 'price_hint'.tr(context), context),
                        ),
                      ),
                    ),
                  );
                }),

                // "+" Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addServiceDetail,
                        icon: const Icon(Icons.add),
                        label: Text('add_section'.tr(context)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    if (serviceDetailsControllers.isNotEmpty)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            serviceDetailsControllers.last['price']!.dispose();
                            serviceDetailsControllers.last['description']!
                                .dispose();
                            serviceDetailsControllers.removeLast();
                            setState(() {});
                          },
                          icon: const Icon(Icons.undo),
                          label: Text('undo'.tr(context)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
