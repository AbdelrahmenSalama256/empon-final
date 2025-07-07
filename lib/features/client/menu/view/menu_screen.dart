import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app/embone.dart';
import '../../../../core/component/custom_loading_indicator.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/constants/custom_popup.dart';
import '../../../../core/constants/navigation.dart';
import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/cubit/global_state.dart';
import '../../../../core/locale/app_loacl.dart';
import '../../../../core/network/local_network.dart';
import '../../../../core/services/service_locator.dart';
import '../../../base/view/welcome/intro_screen.dart';
import '../../../business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import '../../../business_account/auth_bussniss_acc/view/create_business_account.dart';
import '../../../business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import '../../../business_account/auth_bussniss_acc/view/cubit/account_state.dart';
import '../../../client/menu/data/repo/business_repo.dart';
import '../../../client/menu/data/repo/packages_repo.dart';
import '../../../client/menu/view/cubit/business_cubit.dart';
import '../../../client/menu/view/cubit/business_state.dart';
import '../../../client/menu/view/cubit/packages_cubit.dart';
import '../../../client/menu/view/cubit/packages_state.dart';
import '../../../client/menu/view/inner_screens/help_support.dart';
import '../../../client/menu/view/inner_screens/settings_screen.dart';
import '../../../client/menu/view/widgets/buisniss_account.dart';
import '../../../client/menu/view/widgets/menu_item.dart';
import '../../../client/menu/view/widgets/plan_screen.dart';
import '../../../client/menu/view/widgets/sign_out.dart';
import '../../../client/menu/view/widgets/user_type_loading.dart';
import 'inner_screens/widgets/accounts_bottom_sheet.dart';
import 'widgets/menu_approval_items.dart';
// Import the new widgets
import 'widgets/menu_header.dart';
import 'widgets/menu_most_visited.dart';
import 'widgets/menu_quick_access.dart';
import 'widgets/profile_section.dart';

class MenuScreen extends StatelessWidget {
  final bool? isVendor;
  const MenuScreen({super.key, this.isVendor = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();
    int index = cubit.userAccount?.indexWhere((element) =>
            element.id ==
            int.parse(sl<CacheHelper>()
                    .getData(key: AppConstants.businessAccountId) ??
                "0")) ??
        -1;

    final accountData = index != -1 ? cubit.userAccount![index] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          if (state is UserTypeSwitchingState) {
            return const Scaffold(
                backgroundColor: Colors.white, body: UserTypeSwitchLoader());
          }
          return BlocConsumer<GlobalCubit, GlobalState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.of(context).pop();
                navigatorKey.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const IntroPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                  (Route<dynamic> route) => false,
                );
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              }
            },
            builder: (context, state) {
              final cubit = context.read<GlobalCubit>();
              return BlocProvider(
                create: (context) => BusinessCubit(sl<BusinessRepo>())..init(),
                child: BlocBuilder<BusinessCubit, BusinessState>(
                  builder: (context, businessState) {
                    final businessCubit = context.read<BusinessCubit>();
                    return BlocProvider(
                      create: (context) => AccountCubit(sl<AccountRepo>()),
                      child: BlocBuilder<AccountCubit, AccountState>(
                        builder: (context, accountState) {
                          return SafeArea(
                            child: Column(
                              children: [
                                MenuHeader(isVendor: isVendor, cubit: cubit),
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      return businessCubit
                                          .fetchBusinesses()
                                          .whenComplete(
                                        () {
                                          cubit.getUserProfile();
                                        },
                                      );
                                    },
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 8.h),
                                        child: Column(
                                          crossAxisAlignment: isVendor != true
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                          children: [
                                            isVendor != true
                                                ? SizedBox(height: 0.h)
                                                : SizedBox(height: 24.h),
                                            isVendor != true
                                                ? ProfileSection(
                                                    userName:
                                                        cubit.userName ?? '',
                                                    userImageUrl:
                                                        "${cubit.userAvatar}",
                                                    subtitle: 'user_account'
                                                        .tr(context),
                                                    isVendor: isVendor!,
                                                    onTap: () {
                                                      if (cubit.userType ==
                                                          UserType.client) {
                                                        navigateTo(context,
                                                            const SettingsScreen());
                                                      } else {
                                                        showAccountsBottomSheet(
                                                            context);
                                                      }
                                                    },
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ProfileSection(
                                                        userName:
                                                            cubit.userName ??
                                                                '',
                                                        userImageUrl: cubit
                                                                .userAvatar ??
                                                            'assets/images/logo.png',
                                                        subtitle: 'user_account'
                                                            .tr(context),
                                                        isVendor: isVendor!,
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                  GlobalCubit>()
                                                              .setUserType(
                                                                  UserType
                                                                      .client);
                                                        },
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      ProfileSection(
                                                        userName: accountData
                                                                ?.name ??
                                                            'business_account'
                                                                .tr(context),
                                                        userImageUrl:
                                                            "${accountData?.logo}",
                                                        isVendor: true,
                                                        subtitle:
                                                            'business_account'
                                                                .tr(context),
                                                        borderColor:
                                                            Colors.green,
                                                        onTap: () {
                                                          navigateTo(
                                                              context,
                                                              SettingsScreen(
                                                                isVendor:
                                                                    isVendor,
                                                              ));
                                                        },
                                                      ),
                                                      SizedBox(width: 15.w),
                                                      ProfileSection(
                                                        userName:
                                                            'add_new_buisniss_account'
                                                                .tr(context),
                                                        userImageUrl: '',
                                                        isVendor: isVendor!,
                                                        onTap: () {
                                                          navigateTo(
                                                            context,
                                                            const CreateBusinessAccountTypePage(),
                                                          );
                                                        },
                                                        isAddNew: true,
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(height: 32.h.h),
                                            isVendor != true
                                                ? MenuMostVisited(
                                                    isVendor: isVendor,
                                                    businessCubit:
                                                        businessCubit,
                                                  )
                                                : SizedBox(height: 0.h),
                                            MenuQuickAccess(
                                              isVendor: isVendor,
                                              cubit: cubit,
                                              accountData: accountData,
                                            ),
                                            SizedBox(height: 32.h.h),
                                            isVendor == true
                                                ? MenuApprovalItems(
                                                    accountData: accountData,
                                                    cubit: cubit,
                                                  )
                                                : SizedBox(height: 0.h),
                                            isVendor == true
                                                ? ExpansionTile(
                                                    title: Text(
                                                      'store_plans'.tr(context),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp),
                                                    ),
                                                    children: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            PackagesCubit(sl<
                                                                PackagesRepo>())
                                                              ..fetchPackages(),
                                                        child: BlocBuilder<
                                                            PackagesCubit,
                                                            PackagesState>(
                                                          builder: (context,
                                                              packageState) {
                                                            return packageState
                                                                    is PackagesLoading
                                                                ? const Center(
                                                                    child:
                                                                        CustomLoadingIndicator())
                                                                : const PlanSection();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: 15.h),
                                            MenuItem(
                                              onTap: () {
                                                navigateTo(context,
                                                    const HelpSupportPage());
                                              },
                                              title: "help_support".tr(context),
                                              icon: "assets/images/help.png",
                                            ),
                                            SizedBox(height: 16.h),
                                            isVendor != true
                                                ? const BusinessAccountSection()
                                                : const SizedBox(),
                                            isVendor != true
                                                ? SizedBox(height: 30.h)
                                                : const SizedBox(),
                                            state is LogoutLoading
                                                ? const Center(
                                                    child:
                                                        LinearProgressIndicator())
                                                : SignOutButton(
                                                    onPressed: () {
                                                      if (cubit.userType ==
                                                          UserType.business) {
                                                        context
                                                            .read<GlobalCubit>()
                                                            .setUserType(
                                                                UserType
                                                                    .client);
                                                      } else {
                                                        cubit.userType ==
                                                                UserType.client
                                                            ? CustomPopup.show(
                                                                type: PopupType
                                                                    .alert,
                                                                context:
                                                                    context,
                                                                titleColor:
                                                                    const Color(
                                                                        0xffEC4B4B),
                                                                title: "sign_out"
                                                                    .tr(context),
                                                                message:
                                                                    "sign_out_confirmation"
                                                                        .tr(context),
                                                                primaryButtonText:
                                                                    "yes".tr(
                                                                        context),
                                                                secondaryButtonText:
                                                                    "no".tr(
                                                                        context),
                                                                onPrimaryButtonPressed:
                                                                    () {
                                                                  cubit
                                                                      .logout();
                                                                },
                                                                onSecondaryButtonPressed:
                                                                    () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                },
                                                              )
                                                            : context
                                                                .read<
                                                                    GlobalCubit>()
                                                                .setUserType(
                                                                    UserType
                                                                        .client);
                                                      }
                                                    },
                                                  ),
                                            SizedBox(height: 30.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
