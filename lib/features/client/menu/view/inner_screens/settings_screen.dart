// ignore_for_file: deprecated_member_use

import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account_add_settings.dart';
import 'package:embone/features/client/menu/view/inner_screens/edit_profile.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/edit_profile.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/language_selector.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/notifications_toggle.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/settings_header.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wallet.dart';
import 'package:embone/features/client/menu/view/widgets/sign_out.dart';
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
                  // color: Colors.red,
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<GlobalCubit>();
              return SafeArea(
                child: Column(
                  children: [
                    // Header
                    SizedBox(height: 16.h),
                    const SettingsHeader(),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              SizedBox(height: 24.h),
                              if (state is ProfileLoading)
                                const Center(child: CircularProgressIndicator())
                              else
                                ProfileSection(
                                  userName:
                                      "${cubit.userName ?? ''} ${cubit.userLastName ?? ''}"
                                          .trim(),
                                  userImageUrl: cubit.userAvatar ??
                                      'assets/images/profile.png',
                                  subtitle: cubit.userEmail ?? '',
                                  isVendor: isVendor ?? false,
                                  onTap: () {},
                                ),
                              // Edit Profile
                              SizedBox(height: 16.h),
                              EditProfile(
                                onTap: () {
                                  isVendor != true
                                      ? navigateTo(
                                          context, const EditProfilePage())
                                      : navigateTo(
                                          context,
                                          const CreateBusinessAccountSettings(
                                            isFromSetting: true,
                                          ));
                                },
                              ),
                              SizedBox(height: 16.h),
                              Divider(
                                // ignore: use_full_hex_values_for_flutter_colors
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),

                              // Notifications Toggle
                              SizedBox(height: 16.h),
                              const NotificationsToggle(),
                              SizedBox(height: 16.h),
                              Divider(
                                // ignore: use_full_hex_values_for_flutter_colors
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),
                              // Edit Profile
                              SizedBox(height: 16.h),
                              const Wallet(),
                              SizedBox(height: 16.h),
                              Divider(
                                // ignore: use_full_hex_values_for_flutter_colors
                                color:
                                    const Color(0xffe3e3e380).withOpacity(0.3),
                                height: 1.h,
                              ),
                              // Language Selector
                              SizedBox(height: 16.h),
                              const LanguageSelector(),

                              // Menu Items
                              SizedBox(height: 24.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7.w),
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF0F2F9),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  children: [
                                    MenuItem(
                                      icon: "assets/images/orders.png",
                                      title: "orders".tr(context),
                                      onTap: () {
                                        navigateTo(
                                            context, const MyOrdersScreen());
                                      },
                                    ),
                                    Divider(
                                        height: 1.h,
                                        color: const Color(0xffE3E3E3)),
                                    MenuItem(
                                      icon: "assets/images/chatting.png",
                                      title: "chat_with_friends".tr(context),
                                    ),
                                    Divider(
                                        height: 1.h,
                                        color: const Color(0xffE3E3E3)),
                                    MenuItem(
                                      icon: "assets/images/mony_bag.png",
                                      title: "total_sales".tr(context),
                                      onTap: () {},
                                    ),
                                    Divider(
                                        height: 1.h,
                                        color: const Color(0xffE3E3E3)),
                                    MenuItem(
                                      icon: "assets/images/terms.png",
                                      title: "terms_conditions".tr(context),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Sign Out Button
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
                                      navigatorKey.currentState!
                                          .pushAndRemoveUntil(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              const IntroPage(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    onSecondaryButtonPressed: () {
                                      Navigator.of(context).pop();
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
