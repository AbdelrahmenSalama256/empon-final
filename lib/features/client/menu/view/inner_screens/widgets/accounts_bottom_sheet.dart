import 'dart:developer';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAccountsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => const AccountsBottomSheetContent(),
  );
}

class AccountsBottomSheetContent extends StatefulWidget {
  const AccountsBottomSheetContent({super.key});

  @override
  State<AccountsBottomSheetContent> createState() =>
      _AccountsBottomSheetContentState();
}

class _AccountsBottomSheetContentState
    extends State<AccountsBottomSheetContent> {
  late int _selectedAccountIndex; // Initialize dynamically

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GlobalCubit>();
    // Initialize _selectedAccountIndex based on current userType and businessId
    _selectedAccountIndex = cubit.userType == UserType.business &&
            cubit.businessId != null &&
            cubit.userAccount != null
        ? cubit.userAccount!
            .indexWhere((account) => account.id == cubit.businessId)
        : -1; // -1 for personal account
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();
    final accounts = cubit.userAccount ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),

            // User profile section
            GestureDetector(
              onTap: () {
                cubit.setUserType(UserType.client);
                cubit.setBusinessId(
                    null); // Clear businessId when switching to client
                setState(() {
                  _selectedAccountIndex = -1;
                });
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundImage: cubit.userAvatar != null
                            ? NetworkImage(cubit.userAvatar!)
                            : const AssetImage('assets/images/logo.png')
                                as ImageProvider,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        cubit.userName ?? 'User',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedAccountIndex == -1)
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Business accounts title
            if (accounts.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'business_accounts_title'.tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            SizedBox(height: accounts.isNotEmpty ? 16.h : 0),

            // Business accounts list
            ...List.generate(
              accounts.length,
              (index) => BusinessAccountOption(
                name: accounts[index].name ?? 'Business Account',
                imagePath: accounts[index].logo != null
                    ? accounts[index].logo!
                    : 'assets/images/logo.png',
                labelText: (accounts[index].status ?? false)
                    ? 'active'.tr(context)
                    : 'inactive'.tr(context),
                labelColor: (accounts[index].status ?? false)
                    ? AppColors.secondary
                    : AppColors.red,
                isSelected: _selectedAccountIndex == index,
                onTap: () {
                  if (accounts[index].status == true) {
                    setState(() {
                      _selectedAccountIndex = index;
                    });
                    cubit.setUserType(UserType.business);
                    cubit
                        .setBusinessId(accounts[index].id); // Update businessId
                    sl<CacheHelper>().setData(AppConstants.businessAccountId,
                        accounts[index].id.toString());
                    log('Selected businessId: ${accounts[index].id}');
                    setState(() {
                      Navigator.pop(context);
                    });
                  } else {
                    CustomPopup.show(
                      context: context,
                      title: 'inactive_account_title'.tr(context),
                      message: 'inactive_account_message'.tr(context),
                      type: PopupType.alert,
                      primaryButtonText: 'ok'.tr(context),
                      onPrimaryButtonPressed: () {
                        cubit.setUserType(UserType.client);
                        cubit.setBusinessId(null); // Clear businessId
                        setState(() {
                          _selectedAccountIndex = -1;
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // Close the popup
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),

            // Add store option
            AddStoreOption(
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet first
                navigateTo(context, const CreateBusinessAccountTypePage());
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class BusinessAccountOption extends StatelessWidget {
  final String name;
  final String imagePath;
  final bool isSelected;
  final String labelText;
  final Color labelColor;
  final VoidCallback onTap;

  const BusinessAccountOption({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isSelected,
    required this.labelText,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Store logo
            imagePath.startsWith('http')
                ? CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(imagePath),
                  )
                : CircleAvatar(
                    radius: 30.r,
                    backgroundImage: const AssetImage('assets/images/logo.png')
                        as ImageProvider,
                  ),
            SizedBox(width: 12.w),
            // Store name
            Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              width: 70.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                color: Colors.white,
              ),
              child: isSelected
                  ? Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class AddStoreOption extends StatelessWidget {
  final VoidCallback onTap;

  const AddStoreOption({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add icon
            Container(
              width: 22.w,
              height: 22.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffF0F2F9),
              ),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 16.sp,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            // Text
            Text(
              "create_business_account".tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Empty space to maintain alignment
            SizedBox(width: 24.w),
          ],
        ),
      ),
    );
  }
}
