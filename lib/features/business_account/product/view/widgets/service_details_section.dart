import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
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
  @override
  void initState() {
    context.read<ServiceCubit>().getServiceCategories();
    super.initState();
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
            if (state is ServiceCategoriesLoaded)
              AppDropdownField(
                hint: 'category'.tr(context),
                value: cubit.categoryServiceId != null
                    ? state.categories
                        .firstWhere((c) => c.id == cubit.categoryServiceId)
                        .name
                    : null,
                isMultiSelect: false,
                items: state.categories.map((c) => c.name).toList(),
                selectedValues: state.categories
                    .where((c) => cubit.selectedCategoryIds.contains(c.id))
                    .map((c) => c.name)
                    .toList(),
                onChanged: (value) {
                  final selected =
                      state.categories.firstWhere((c) => c.name == value);
                  cubit.categoryServiceId = selected.id;
                  setState(() {
                    
                  });
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
          ],
        );
      },
    );
  }
}
