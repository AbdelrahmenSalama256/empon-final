import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
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
  int _selectedAccountIndex = 0;

  final List<Map<String, dynamic>> _accounts = [
    {
      'name': 'كومفرت شوز',
      'image': 'assets/images/brand-logo.png',
      'isSelected': false,
    },
    {
      'name': 'كومفرت شوز',
      'image': 'assets/images/brand-logo.png',
      'isSelected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                context.read<GlobalCubit>().setUserType(UserType.client);
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
                        backgroundImage:
                            const AssetImage('assets/images/profile.png'),
                        // You can replace with NetworkImage if needed
                        // backgroundImage: NetworkImage('https://example.com/profile.jpg'),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'صوفيا',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
            SizedBox(height: 16.h),

            // Business accounts list
            ...List.generate(
              _accounts.length,
              (index) => BusinessAccountOption(
                name: _accounts[index]['name'],
                imagePath: _accounts[index]['image'],
                isSelected: _selectedAccountIndex == index,
                onTap: () {
                  setState(() {
                    _selectedAccountIndex = index;
                  });
                  context.read<GlobalCubit>().setUserType(UserType.business);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 16.h),

            // Add store option
            AddStoreOption(
              onTap: () {
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
  final VoidCallback onTap;

  const BusinessAccountOption({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isSelected,
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
              color: Color(0x0F000000), // نفس #0000000F
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
            CircleAvatar(
              radius: 30.r,
              child: Image.asset(
                imagePath,
                width: 100.w,
                height: 100.h,
              ),
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
