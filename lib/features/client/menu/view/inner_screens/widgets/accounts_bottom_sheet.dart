import 'dart:developer';

import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account_add_settings.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/menu/data/repo/account_repo.dart';
import 'package:embone/features/client/menu/view/cubit/accounts_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/accounts_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/add_store_button.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/business_account_option.dart';
import 'package:embone/features/client/menu/view/widgets/user_type_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../business_account/auth_bussniss_acc/data/repo/account_repo.dart';

void showAccountsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => BlocProvider(
      create: (context) => AccountCubit(sl<AccountRepo>()),
      child: BlocProvider(
        create: (context) => AccountsCubit(sl<AccountsRepo>()),
        child: const AccountsBottomSheetContent(),
      ),
    ),
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
  late int _selectedAccountIndex;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GlobalCubit>();
    _selectedAccountIndex = cubit.userType == UserType.business &&
            cubit.businessId != null &&
            cubit.userAccount != null
        ? cubit.userAccount!
            .indexWhere((account) => account.id == cubit.businessId)
        : -1;
  }

  // Method to handle user type switching with loading
  Future<void> _switchToUserType(UserType userType, {int? businessId}) async {
    setState(() {
      _isLoading = true;
    });

    final cubit = context.read<GlobalCubit>();

    // Add delay for loading animation
    await Future.delayed(const Duration(milliseconds: 800));

    cubit.setUserType(userType);
    cubit.setBusinessId(businessId);

    if (businessId != null) {
      sl<CacheHelper>().setData(
        AppConstants.businessAccountId,
        businessId.toString(),
      );
      log('Selected businessId: $businessId');
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();
    final accounts = cubit.userAccount ?? [];

    // Show loading overlay when switching user types
    if (_isLoading || cubit.state is UserTypeSwitchingState) {
      return const UserTypeSwitchLoader();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      child: BlocConsumer<AccountsCubit, AccountsState>(
        listener: (context, state) {
          if (state is AccountError) {
            showToast(context,
                message: 'unexpected_error'.tr(context),
                state: ToastStates.error);
          }
        },
        builder: (context, state) {
          final accountsCubit = context.read<AccountsCubit>();
          return SingleChildScrollView(
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
                  onTap: () async {
                    setState(() {
                      _selectedAccountIndex = -1;
                    });
                    await _switchToUserType(UserType.client);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: _selectedAccountIndex == -1
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: _selectedAccountIndex == -1
                            ? AppColors.primary
                            : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
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
                ),
                SizedBox(height: 24.h),
                // Business accounts title
                if (accounts.isNotEmpty)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
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
                      showLabel: state is AccountLoading ||
                          accountsCubit.accountStatus?.data != null ||
                          accounts[index].status != null,
                      name: accounts[index].name ?? 'Business Account',
                      imagePath: accounts[index].logo != null
                          ? accounts[index].logo!
                          : 'assets/images/logo.png',
                      labelText: state is AccountLoading
                          ? 'loading'.tr(context)
                          : accountsCubit.accountStatus?.data?.isCompleted ==
                                  false
                              ? 'pending'.tr(context)
                              : accounts[index].status == true
                                  ? 'active'.tr(context)
                                  : 'inactive'.tr(context),
                      labelColor: (accounts[index].status ?? false)
                          ? AppColors.secondary
                          : AppColors.red,
                      isSelected: ((accountsCubit
                                      .accountStatus?.data?.isCompleted ==
                                  false ||
                              accountsCubit.accountStatus?.data?.isVerified ==
                                  false))
                          ? false
                          : _selectedAccountIndex == index,
                      onTap: () async {
                        setState(() {
                          _selectedAccountIndex = index;
                        });
                        await accountsCubit
                            .fetchAccountStatus(accounts[index].id ?? 0);
                        final status = accountsCubit.accountStatus?.data;
                        if (status?.isCompleted == false) {
                          Navigator.pop(context);
                          navigateTo(
                              context,
                              BlocProvider(
                                create: (context) =>
                                    AccountCubit(sl<AccountRepo>())..fetchAllLocations(),
                                child: const CreateBusinessAccountSettings(),
                              ));
                          return;
                        }
                        if (status?.isVerified == false) {
                          CustomPopup.show(
                            context: context,
                            title: 'inactive_account_title'.tr(context),
                            message: 'inactive_account_message'.tr(context),
                            type: PopupType.alert,
                            primaryButtonText: 'ok'.tr(context),
                            onPrimaryButtonPressed: () {
                              setState(() {
                                _selectedAccountIndex = -1;
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                              _switchToUserType(UserType.client);
                            },
                          );
                        } else if (state is AccountError) {
                          showToast(
                            context,
                            message: 'unexpected_error'.tr(context),
                            state: ToastStates.error,
                          );
                        } else if (accounts[index].status == false) {
                          CustomPopup.show(
                            context: context,
                            title: 'inactive_account_title'.tr(context),
                            message: 'inactive_account_message'.tr(context),
                            type: PopupType.alert,
                            primaryButtonText: 'ok'.tr(context),
                            onPrimaryButtonPressed: () {
                              setState(() {
                                _selectedAccountIndex = -1;
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                              _switchToUserType(UserType.client);
                            },
                          );
                        } else {
                          await _switchToUserType(UserType.business,
                              businessId: accounts[index].id);
                        }
                      }),
                ),
                SizedBox(height: 16.h),
                // Add store option
                AddStoreOption(
                  onTap: () {
                    Navigator.pop(context);
                    navigateTo(context, const CreateBusinessAccountTypePage());
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
