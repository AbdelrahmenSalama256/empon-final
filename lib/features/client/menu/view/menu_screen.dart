import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/contacts/view/contact_tree/followers_screen.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/menu/view/inner_screens/settings_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/accounts_bottom_sheet.dart';
import 'package:embone/features/client/menu/view/inner_screens/help_support.dart';
import 'package:embone/features/client/menu/view/inner_screens/wishlist_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/store_screen.dart';
import 'package:embone/features/client/menu/view/widgets/approval_item.dart';
import 'package:embone/features/client/menu/view/widgets/buisniss_account.dart';
import 'package:embone/features/client/menu/view/widgets/menu_item.dart';
import 'package:embone/features/client/menu/view/widgets/most_visited.dart';
import 'package:embone/features/client/menu/view/widgets/quick_access.dart';
import 'package:embone/features/client/menu/view/widgets/sign_out.dart';
import 'package:embone/features/client/order/view/my_order_screen.dart';
import 'package:embone/features/client/product_Details/view/service_detailes_secreen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
              return SafeArea(
                child: Column(
                  children: [
                    // SizedBox(height: 16.h),
                    isVendor != true
                        ? AppHeader(
                            title: "menu".tr(context),
                            centerTitle: false,
                            leadingPosition: MainAxisAlignment.end,
                            alignment: HeaderAlignment.spaceBetween,
                            titleStyle: TextStyle(fontSize: 20.sp),
                            showBackButton: false,
                            style: HeaderStyle.standard,
                            onBackPressed: () {
                              context
                                  .read<GlobalCubit>()
                                  .changeBottomNavIndex(0);
                            },
                            automaticallyImplyLeading: false,
                            // padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
                            leading: Row(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/images/svg/search.svg",
                                      width: 24.w,
                                      height: 24.h),
                                  onPressed: () {
                                    navigateTo(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            SearchCubit(sl<SearchRepo>())
                                              ..init(),
                                        child: const SearchPage(),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/images/svg/heart.svg",
                                      width: 24.w,
                                      height: 24.h),
                                  onPressed: () {
                                    navigateTo(context, const WishlistScreen());
                                  },
                                ),
                                IconButton(
                                  icon: Container(
                                    width: 27.w,
                                    height: 27.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF0F2F9),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 24.w,
                                    ),
                                  ),
                                  onPressed: () {
                                    showAccountsBottomSheet(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Container(
                                    width: 35.w,
                                    height: 35.w,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.h),
                                      border: Border.all(
                                          color: AppColors.grey, width: 0.2.w),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      size: 20.h,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<GlobalCubit>()
                                        .changeBottomNavIndex(0);
                                  },
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200.r),
                                        child: accountData != null
                                            ? accountData.logo!
                                                    .startsWith('http')
                                                ? Image.network(
                                                    accountData.logo!,
                                                    width: 74.w,
                                                    height: 74.w,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/brand-logo.png',
                                                    width: 74.w,
                                                    height: 74.w,
                                                  )
                                            : Image.asset(
                                                'assets/images/brand-logo.png',
                                                width: 74.w,
                                                height: 74.w,
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      accountData?.name ?? '',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(flex: 2),
                              ],
                            ),
                          ),

                    Expanded(
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
                                      userName: cubit.userName ?? '',
                                      userImageUrl: cubit.userAvatar ??
                                          'assets/images/profile.png',
                                      subtitle: 'user_account'.tr(context),
                                      isVendor: isVendor!,
                                      onTap: () {
                                        if (cubit.userType == UserType.client) {
                                          navigateTo(
                                              context, const SettingsScreen());
                                        } else {
                                          showAccountsBottomSheet(context);
                                        }
                                        // cubit.setUserType(UserType.client);
                                      },
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ProfileSection(
                                          userName: cubit.userName ?? '',
                                          userImageUrl: cubit.userAvatar ??
                                              'assets/images/profile.png',
                                          subtitle: 'user_account'.tr(context),
                                          isVendor: isVendor!,
                                          onTap: () {
                                            context
                                                .read<GlobalCubit>()
                                                .setUserType(UserType.client);
                                          },
                                        ),
                                        SizedBox(width: 15.w),
                                        ProfileSection(
                                          userName: accountData?.name ??
                                              'business_account'.tr(context),
                                          userImageUrl: accountData?.logo ??
                                              'assets/images/brand-logo.png',
                                          isVendor: true,
                                          subtitle:
                                              'business_account'.tr(context),
                                          borderColor: Colors.green,
                                          onTap: () {
                                            navigateTo(context,
                                                const HomeStoreScreen());
                                          },
                                        ),
                                        SizedBox(width: 15.w),
                                        ProfileSection(
                                          userName: 'add_new_buisniss_account'
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
                                  ? Column(
                                      children: [
                                        SectionHeader(
                                          backgroundColor: Colors.white,
                                          title: "most_visited".tr(context),
                                          padding: const EdgeInsets.all(0),
                                          showCloseButton: false,
                                        ),
                                        SizedBox(height: 16.h),
                                        SizedBox(
                                          height: 90.h,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              VisitedItem(
                                                name: "Comfort Shoes",
                                                imageUrl:
                                                    "assets/images/brand-two.png",
                                                onTap: () {
                                                  navigateTo(
                                                      context,
                                                      BlocProvider(
                                                        create: (context) =>
                                                            SearchCubit(sl<SearchRepo>()),
                                                              
                                                        child:
                                                            const ServiceDetailPage(
                                                          isVendor: false,
                                                          serviceId: 1,//!todo: replace with actual service id
                                                        ),
                                                      ));
                                                },
                                              ),
                                              SizedBox(width: 16.w),
                                              VisitedItem(
                                                name: "Pixy Style",
                                                imageUrl:
                                                    "assets/images/brand-logo.png",
                                                onTap: () {
                                                  navigateTo(context,
                                                      const StoreScreen());
                                                },
                                              ),
                                              SizedBox(width: 16.w),
                                              VisitedItem(
                                                name: "Golden Scent",
                                                imageUrl:
                                                    "assets/images/brand-logo.png",
                                                onTap: () {
                                                  navigateTo(context,
                                                      const StoreScreen());
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 24.h),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 0.h,
                                    ),
                              isVendor != false
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: QuickAccessButton(
                                            onTap: () {
                                              context
                                                  .read<GlobalCubit>()
                                                  .changeBottomNavIndex(0);
                                            },
                                            title: "home".tr(context),
                                            icon: "assets/images/home.png",
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: QuickAccessButton(
                                            onTap: () {
                                              context
                                                  .read<GlobalCubit>()
                                                  .changeBottomNavIndex(1);
                                            },
                                            title: "nav_info".tr(context),
                                            icon: "assets/images/dashboard.png",
                                            color: Colors.red.shade100,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: QuickAccessButton(
                                            onTap: () {},
                                            title: "offers".tr(context),
                                            icon: "assets/images/discount.png",
                                            color: Colors.red.shade100,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: QuickAccessButton(
                                            onTap: () {
                                              navigateTo(context,
                                                  const FollowersPage());
                                            },
                                            title: "friends".tr(context),
                                            icon:
                                                "assets/images/leadership.png",
                                            color: Colors.blue.shade100,
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 32.h.h),

                              isVendor != true
                                  ? const SizedBox()
                                  : Wrap(
                                      children: [
                                        ApprovalItem(
                                          title: 'convert_business_to_store'
                                              .tr(context),
                                          status: ApprovalStatus.processing,
                                          icon: Image.asset(
                                            "assets/images/cycle-circle.png",
                                            width: 24.w,
                                            height: 24.h,
                                          ),
                                          onApprove: () => CustomPopup.show(
                                            context: context,
                                            type: PopupType.success,
                                            title: "request_sent_successfully"
                                                .tr(context),
                                            message: "request_under_review"
                                                .tr(context),
                                          ),
                                        ),

                                        // Second approval item example
                                        ApprovalItem(
                                          title: 'identity_verification_request'
                                              .tr(context),
                                          status: ApprovalStatus.approved,
                                          icon: Image.asset(
                                            "assets/images/verify.png",
                                            width: 24.w,
                                            height: 24.h,
                                          ),
                                          onApprove: () => CustomPopup.show(
                                            context: context,
                                            type: PopupType.success,
                                            title: "request_sent_successfully"
                                                .tr(context),
                                            message: "request_under_review"
                                                .tr(context),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 50.h),
                              MenuItem(
                                ontap: () {
                                  navigateTo(context, const HelpSupportPage());
                                },
                                title: "help_support".tr(context),
                                icon: "assets/images/help.png",
                                iconColor: Colors.transparent,
                              ),
                              SizedBox(height: 16.h),
                              MenuItem(
                                ontap: () {
                                  navigateTo(
                                      context,
                                      SettingsScreen(
                                        isVendor: isVendor,
                                      ));
                                },
                                title: "settings_privacy".tr(context),
                                icon: "assets/images/settings.png",
                                iconColor: Colors.transparent,
                              ),
                              SizedBox(height: 16.h),

                              // const Spacer(),
                              isVendor != true
                                  ? const BusinessAccountSection()
                                  : const SizedBox(),
                              isVendor != true
                                  ? SizedBox(height: 30.h)
                                  : const SizedBox(),
                              state is LogoutLoading
                                  ? const Center(
                                      child: CustomLoadingIndicator())
                                  : SignOutButton(
                                      onPressed: () {
                                        // Show confirmation popup
                                        CustomPopup.show(
                                          type: PopupType.alert,
                                          context: context,
                                          titleColor: const Color(0xffEC4B4B),
                                          title: "sign_out".tr(context),
                                          message: "sign_out_confirmation"
                                              .tr(context),
                                          primaryButtonText: "yes".tr(context),
                                          secondaryButtonText: "no".tr(context),
                                          onPrimaryButtonPressed: () {
                                            cubit.logout();
                                          },
                                          onSecondaryButtonPressed: () {
                                            // Dismiss the popup if user cancels
                                            Navigator.of(context,
                                                    rootNavigator: true)
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
