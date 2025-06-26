import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_hero.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/menu/data/repo/packages_repo.dart';
import 'package:embone/features/client/menu/view/cubit/packages_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/packages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableGridScreen extends StatefulWidget {
  const SelectableGridScreen({super.key});

  @override
  State<SelectableGridScreen> createState() => _SelectableGridScreenState();
}

class _SelectableGridScreenState extends State<SelectableGridScreen> {
  List<int> selectedItems = [];
  List<int> selectedCityIds = [];

  String? selectedAudience;
  String? selectedType;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final accountCubit = context.read<BusinessAccountCubit>();
    final cities = context.read<PackagesCubit>();

    return BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: state is BusinessAccountLoading
              ? const Center(child: CircularProgressIndicator())
              : BlocBuilder<PackagesCubit, PackagesState>(
                builder: (context, state) {
                  if (state is PackagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeStoreHeader(
                              isVendor: true,
                              name: accountCubit.accountData!.data.name,
                              onBackPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 8),
                            HomeStoreHero(
                                storeLogo: accountCubit.accountData?.data.logo,
                                storeCover:
                                    accountCubit.accountData?.data.cover),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HomeStoreNameSection(
                                isVerified:
                                    accountCubit.accountData!.data.verified,
                                name: "${accountCubit.accountData?.data.name}",
                                onTap: () {
                                  accountCubit.launchLocationUrl(
                                      latitude: double.parse(
                                          accountCubit.accountData!.data.lat),
                                      longitude: double.parse(
                                          accountCubit.accountData!.data.lng));
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Store name
                                  Text(
                                    'plan_title'.tr(context),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                        
                                  // Store description
                                  Text(
                                    "plan_subtitle".tr(context),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              itemCount: accountCubit
                                  .accountData!.data.products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                bool isSelected = selectedItems.contains(
                                    accountCubit
                                        .accountData!.data.products[index].id);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedItems.remove(accountCubit
                                            .accountData!
                                            .data
                                            .products[index]
                                            .id);
                                      } else {
                                        selectedItems.add(accountCubit
                                            .accountData!
                                            .data
                                            .products[index]
                                            .id);
                                      }
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                            accountCubit.accountData!.data
                                                .products[index].image,
                                            fit: BoxFit.cover),
                                      ),
                                      if (isSelected)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 32),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 12.h),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: cities.minAge!,
                                      hintText:"min Age"
                                      )
                                      ),
                                  SizedBox(width: 12.w,),
                                  Expanded(child: AppTextField(
                                      hintText:"max Age",
                                      controller: cities.maxAge!
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            AppDropdownField(
                              hint: 'gander'.tr(context),
                              items: [
                                'men'.tr(context),
                                'women'.tr(context),
                              ],
                        
                              onChanged: (String? value) {cities.slectedGander = value;},
                            ),
                            SizedBox(height: 12.h),
                            AppDropdownField(
                              hint: 'gander'.tr(context),
                              items: cities.cities
                                  .map((city) => city.name)
                                  .toList(),
                              onChanged: (String? value) { cities.selectedCityId = 
                                cities.cities.where((value)=>value.name == value).first.id
                                ;},
                            ),
                            // _buildDropdowns(),
                            SizedBox(height: 12.h),
                            AppButton(
                              text: "chose".tr(context),
                              onPressed:(){} ,)
                        ,
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
        );
      },
    );
  }
}
