// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_hero.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/checkout/view/empon_wallet_screen.dart';
import 'package:embone/features/client/menu/data/repo/wallet_repo.dart';
import 'package:embone/features/client/menu/view/cubit/packages_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/packages_state.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableGridScreen extends StatefulWidget {
  int accountId;
  int planId;
  SelectableGridScreen({
    super.key,
    required this.accountId,
    required this.planId,
  });

  @override
  State<SelectableGridScreen> createState() => _SelectableGridScreenState();
}

class _SelectableGridScreenState extends State<SelectableGridScreen> {
  DateTime? selectedStartDate;

  String get selectedStartDateString {
    if (selectedStartDate == null) return '';
    return '${selectedStartDate!.year}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate!.day.toString().padLeft(2, '0')}';
  }

  DateTime? selectedEndDate;

  String get selectedEndDateString {
    if (selectedEndDate == null) return '';
    return '${selectedEndDate!.year}-${selectedEndDate!.month.toString().padLeft(2, '0')}-${selectedEndDate!.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final accountCubit = context.read<BusinessAccountCubit>();
    final citiesCubit = context.read<PackagesCubit>();
    final List<String> items = [
      'all',
      'male',
      'female',
    ];

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
                                  storeLogo:
                                      accountCubit.accountData?.data.logo,
                                  storeCover:
                                      accountCubit.accountData?.data.cover),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HomeStoreNameSection(
                                  isVerified:
                                      accountCubit.accountData!.data.verified!,
                                  name:
                                      "${accountCubit.accountData?.data.name}",
                                  onTap: () {
                                    accountCubit.launchLocationUrl(
                                        latitude: double.parse(accountCubit
                                            .accountData!.data.lat!),
                                        longitude: double.parse(accountCubit
                                            .accountData!.data.lng!));
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
                                    .accountData!.data.products!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemBuilder: (context, index) {
                                  bool isSelected = citiesCubit.selectedItems
                                      .contains(accountCubit.accountData!.data
                                          .products![index].id);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          citiesCubit.selectedItems.remove(
                                              accountCubit.accountData!.data
                                                  .products![index].id);
                                        } else {
                                          citiesCubit.selectedItems.add(
                                              accountCubit.accountData!.data
                                                  .products![index].id);
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                              accountCubit.accountData!.data
                                                  .products![index].image,
                                              fit: BoxFit.cover),
                                        ),
                                        if (isSelected)
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.4),
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
                                        controller: citiesCubit.minAge!,
                                        hintText: "min_age".tr(context),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: AppTextField(
                                        hintText: "max_age".tr(context),
                                        controller: citiesCubit.maxAge!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: selectedStartDate ??
                                                DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              selectedStartDate = picked;
                                              citiesCubit.startDate =
                                                  selectedStartDateString;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 12),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            selectedStartDateString.isEmpty
                                                ? "start_date".tr(context)
                                                : selectedStartDateString,
                                            style: TextStyle(
                                              color: selectedStartDateString
                                                      .isEmpty
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: selectedEndDate ??
                                                DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              selectedEndDate = picked;
                                              citiesCubit.endDate =
                                                  selectedEndDateString;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 12),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            selectedEndDateString.isEmpty
                                                ? "end_date".tr(context)
                                                : selectedEndDateString,
                                            style: TextStyle(
                                              color:
                                                  selectedEndDateString.isEmpty
                                                      ? Colors.grey
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return AppDropdownField(
                                    hint: 'gender'.tr(context),
                                    items: items
                                        .map((item) => item.tr(context))
                                        .toList(),
                                    value:
                                        citiesCubit.slectedGander?.tr(context),
                                    onChanged: (String? value) {
                                      final originalValue = items.firstWhere(
                                        (item) => item.tr(context) == value,
                                        orElse: () => items.first,
                                      );
                                      setState(() {
                                        citiesCubit.slectedGander =
                                            originalValue;
                                      });
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),
                              AppDropdownField(
                                hint: 'city'.tr(context),
                                items: citiesCubit.cities
                                    .map((city) => city.name)
                                    .toList(),
                                onChanged: (String? value) {
                                  if (citiesCubit.cities.isNotEmpty) {
                                    final selectedCity =
                                        citiesCubit.cities.firstWhere(
                                      (city) => city.name == value,
                                      orElse: () => citiesCubit.cities.first,
                                    );
                                    setState(() {
                                      citiesCubit.selectedCityId =
                                          selectedCity.id;
                                    });
                                  }
                                },
                                value: citiesCubit.cities.isNotEmpty
                                    ? citiesCubit.cities
                                        .firstWhere(
                                          (city) =>
                                              city.id ==
                                              citiesCubit.selectedCityId,
                                          orElse: () =>
                                              citiesCubit.cities.first,
                                        )
                                        .name
                                    : null,
                              ),
                              // _buildDropdowns(),
                              SizedBox(height: 12.h),
                              BlocConsumer<PackagesCubit, PackagesState>(
                                listener: (context, state) {
                                  if (state is PackageAdsLoaded) {
                                    showToast(context,
                                        message: "succ_ads".tr(context),
                                        state: ToastStates.error);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (_) =>
                                              WalletCubit(sl<WalletRepo>()),
                                          child: EmponWalletScreen(
                                            grandTotal: double.tryParse(state
                                                    .res
                                                    .userPackage
                                                    .packageInfo
                                                    .price) ??
                                                0.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (state is PackagesError) {
                                    showToast(context,
                                        message: state.message,
                                        state: ToastStates.error);
                                  }
                                },
                                builder: (context, state) {
                                  return AppButton(
                                    text: "chose".tr(context),
                                    isLoading: state is PackageAdsLoading,
                                    onPressed: () {
                                      context
                                          .read<PackagesCubit>()
                                          .createPackageAds(
                                            packageId: widget.planId,
                                            accountId: widget.accountId,
                                          );
                                    },
                                  );
                                },
                              ),
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
