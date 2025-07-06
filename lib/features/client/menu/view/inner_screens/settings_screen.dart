import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/update_account_business.dart';
import 'package:embone/features/business_account/profile/update_profile_buisniss_account.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/chat/view/massages_screen.dart';
import 'package:embone/features/client/menu/data/repo/total_sales_repo.dart';
import 'package:embone/features/client/menu/view/cubit/total_sales_cubit.dart';
import 'package:embone/features/client/menu/view/inner_screens/edit_profile.dart';
import 'package:embone/features/client/menu/view/inner_screens/privacy_policy_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/total_sales_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/addresses_section.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/edit_profile.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/language_selector.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/notifications_toggle.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/settings_header.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wallet.dart';
import 'package:embone/features/client/menu/view/widgets/sign_out.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/order/view/my_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/menu_item.dart';
import 'widgets/profile_section.dart';

class SettingsScreen extends StatelessWidget {
  final bool? isVendor;
  const SettingsScreen({super.key, this.isVendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          return BlocConsumer<GlobalCubit, GlobalState>(
            listener: (context, state) {
              if (state is ProfileError) {
                showToast(
                  context,
                  message: state.message,
                  state: ToastStates.error,
                );
              }
              if (state is LogoutSuccess) {
                navigatorKey.currentState!.pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const IntroPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
              if (state is AccountDeletedSuccess) {
                context.read<GlobalCubit>().logout();
              }
            },
            builder: (context, state) {
              final cubit = context.read<GlobalCubit>();
              return SafeArea(
                child: Column(
                  children: [
                    const SettingsHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              SizedBox(height: 24.h),
                              state is ProfileLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : isVendor != true
                                      ? ProfileSection(
                                          userName:
                                              "${cubit.userName ?? ''} ${cubit.userLastName ?? ''}",
                                          userImageUrl: cubit.userAvatar ??
                                              'assets/images/logo.png',
                                          subtitle: cubit.userEmail ?? '',
                                          isVendor: isVendor ?? false,
                                          onTap: () {},
                                        )
                                      : Row(
                                          children: [
                                            BlocProvider(
                                              create: (context) => AccountCubit(
                                                  sl<AccountRepo>()),
                                              child: Builder(
                                                builder: (context) {
                                                  return CircleAvatar(
                                                    radius: 32.r,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      cubit.userAccount
                                                              ?.where((element) =>
                                                                  element.id ==
                                                                  cubit
                                                                      .businessId)
                                                              .first
                                                              .logo ??
                                                          'assets/images/logo.png',
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (cubit.userAccount
                                                                ?.where((element) =>
                                                                    element
                                                                        .id ==
                                                                    cubit
                                                                        .businessId)
                                                                .first
                                                                .name ??
                                                            '')
                                                        .trim(),
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            BlocProvider(
                                              create: (context) => AccountCubit(
                                                  sl<AccountRepo>()),
                                              child: Builder(
                                                builder: (context) {
                                                  final accountCubit = context
                                                      .read<AccountCubit>();
                                                  return IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () {
                                                      navigateTo(
                                                        context,
                                                        UpdateProfilePhotoForBuisnissAccountPage(
                                                          cubit: accountCubit,
                                                          accountData: cubit
                                                              .userAccount!
                                                              .where((element) =>
                                                                  element.id ==
                                                                  cubit
                                                                      .businessId)
                                                              .first,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                              SizedBox(height: isVendor != true ? 16.h : 30.h),
                              EditProfile(
                                title: isVendor != true
                                    ? "edit_profile"
                                    : "edit_business_profile",
                                onTap: () {
                                  isVendor != true
                                      ? navigateTo(
                                          context, const EditProfilePage())
                                      : navigateTo(
                                          context,
                                          BlocProvider(
                                            create: (context) =>
                                                AccountCubit(sl<AccountRepo>()),
                                            child: cubit.userAccount != null
                                                ? UpdateBusinessAccount(
                                                    accountData: cubit
                                                        .userAccount!
                                                        .where((element) =>
                                                            element.id ==
                                                            cubit.businessId)
                                                        .cast<Account>()
                                                        .first,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        );
                                },
                              ),
                              SizedBox(height: 16.h),
                              Divider(
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),
                              SizedBox(height: 16.h),
                              const NotificationsToggle(),
                              SizedBox(height: 16.h),
                              Divider(
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),
                              if (isVendor != true) ...[
                                SizedBox(height: 16.h),
                                const AddressesSection(),
                                SizedBox(height: 16.h),
                                Divider(
                                  color: const Color(0xffe3e3e380)
                                      .withOpacity(0.3),
                                  height: 1.h,
                                ),
                              ],
                              SizedBox(height: 16.h),
                              const Wallet(),
                              SizedBox(height: 16.h),
                              Divider(
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),
                              SizedBox(height: 16.h),
                              const LanguageSelector(),
                              SizedBox(height: isVendor == true ? 16.h : 24.h),
                              Container(
                                margin: isVendor == true
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(horizontal: 7.w),
                                padding: isVendor == true
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: isVendor == true
                                    ? const BoxDecoration()
                                    : BoxDecoration(
                                        color: const Color(0xffF0F2F9),
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                child: Column(
                                  children: [
                                    MenuItem(
                                      icon: "assets/images/orders.png",
                                      title: "orders".tr(context),
                                      onTap: () {
                                        navigateTo(
                                          context,
                                          BlocProvider(
                                            create: (context) =>
                                                OrdersCubit(sl<OrderRepo>())
                                                  ..fetchOrders(),
                                            child: const MyOrdersScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    Divider(
                                        height: 1.h,
                                        color: const Color(0xffE3E3E3)),
                                    MenuItem(
                                      icon: "assets/images/chatting.png",
                                      onTap: () {
                                        navigateTo(
                                            context, const MassagesScreen());
                                      },
                                      title: isVendor == true
                                          ? "chat".tr(context)
                                          : "chat_with_friends".tr(context),
                                    ),
                                    if (isVendor == true) ...[
                                      Divider(
                                          height: 1.h,
                                          color: const Color(0xffE3E3E3)),
                                      MenuItem(
                                        icon: "assets/images/mony_bag.png",
                                        title: "total_sales".tr(context),
                                        onTap: () {
                                          navigateTo(
                                            context,
                                            BlocProvider(
                                              create: (context) =>
                                                  TotalSalesCubit(
                                                      sl<TotalSalesRepo>()),
                                              child: const SalesStatsPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    Divider(
                                        height: 1.h,
                                        color: const Color(0xffE3E3E3)),
                                    MenuItem(
                                      icon: "assets/images/terms.png",
                                      title: "terms_conditions".tr(context),
                                      onTap: () {
                                        showToast(
                                          context,
                                          message:
                                              "terms_conditions".tr(context),
                                          state: ToastStates.success,
                                        );
                                        navigateTo(context,
                                            const PrivacyPolicyScreen());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              SignOutButton(
                                text: "delete_account".tr(context),
                                onPressed: () {
                                  CustomPopup.show(
                                    type: PopupType.alert,
                                    context: context,
                                    titleColor: const Color(0xffEC4B4B),
                                    title: "delete_account".tr(context),
                                    message:
                                        "delete_account_confirm".tr(context),
                                    primaryButtonText: "yes".tr(context),
                                    secondaryButtonText: "no".tr(context),
                                    onPrimaryButtonPressed: () {
                                      cubit.deleteAccount();
                                    },
                                    onSecondaryButtonPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
