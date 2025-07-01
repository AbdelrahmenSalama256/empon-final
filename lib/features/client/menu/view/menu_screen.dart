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
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_state.dart';
import 'package:embone/features/business_account/dashboard/data/repo/statistics_repo.dart';
import 'package:embone/features/business_account/dashboard/view/cubit/statistics_cubit.dart';
import 'package:embone/features/business_account/dashboard/view/dashboard_screen.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/contacts/view/contact_tree/followers_screen.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/menu/data/repo/business_repo.dart';
import 'package:embone/features/client/menu/data/repo/packages_repo.dart';
import 'package:embone/features/client/menu/view/cubit/business_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/business_state.dart';
import 'package:embone/features/client/menu/view/cubit/packages_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/packages_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/help_support.dart';
import 'package:embone/features/client/menu/view/inner_screens/offers_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/settings_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/accounts_bottom_sheet.dart';
import 'package:embone/features/client/menu/view/inner_screens/wishlist_screen.dart';
import 'package:embone/features/client/menu/view/widgets/approval_item.dart';
import 'package:embone/features/client/menu/view/widgets/buisniss_account.dart';
import 'package:embone/features/client/menu/view/widgets/menu_item.dart';
import 'package:embone/features/client/menu/view/widgets/most_visited.dart';
import 'package:embone/features/client/menu/view/widgets/plan_screen.dart';
import 'package:embone/features/client/menu/view/widgets/quick_access.dart';
import 'package:embone/features/client/menu/view/widgets/sign_out.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
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
                                // SizedBox(height: 16.h),

                                isVendor != true
                                    ? Directionality(
                                        textDirection: cubit.language == "ar"
                                            ? TextDirection.rtl
                                            : TextDirection.rtl,
                                        child: AppHeader(
                                          title: "menu".tr(context),
                                          centerTitle: false,
                                          leadingPosition:
                                              cubit.language == "ar"
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          alignment:
                                              HeaderAlignment.spaceBetween,
                                          titleStyle:
                                              TextStyle(fontSize: 20.sp),
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
                                                          SearchCubit(
                                                              sl<SearchRepo>())
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
                                                  navigateTo(context,
                                                      const WishlistScreen());
                                                },
                                              ),
                                              IconButton(
                                                icon: Container(
                                                  width: 27.w,
                                                  height: 27.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffF0F2F9),
                                                  ),
                                                  child: Icon(
                                                    cubit.userAccount!.isEmpty
                                                        ? CupertinoIcons.gear
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: Colors.black,
                                                    size: 24.w,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  cubit.userAccount!.isEmpty
                                                      ? navigateTo(
                                                          context,
                                                          SettingsScreen(
                                                            isVendor: isVendor,
                                                          ))
                                                      : showAccountsBottomSheet(
                                                          context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Container(
                                                width: 35.w,
                                                height: 35.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.h),
                                                  border: Border.all(
                                                      color: AppColors.grey,
                                                      width: 0.2.w),
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
                                            SizedBox(width: 85.w),
                                            Column(
                                              children: [
                                                Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200.r),
                                                    child: accountData != null
                                                        ? Image.network(
                                                            accountData.logo!,
                                                            width: 74.w,
                                                            height: 74.w,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Image
                                                                  .asset(
                                                                'assets/images/placholder.jpg',
                                                                width: 74.w,
                                                                height: 74.w,
                                                              );
                                                            },
                                                          )
                                                        : Image.asset(
                                                            'assets/images/placholder.jpg',
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
                                            const Spacer(flex: 1),
                                          ],
                                        ),
                                      ),

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
                                                      // cubit.setUserType(UserType.client);
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
                                                ? Column(
                                                    children: [
                                                      SectionHeader(
                                                        backgroundColor:
                                                            Colors.white,
                                                        title: "most_visited"
                                                            .tr(context),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        showCloseButton: false,
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      state is BusinessLoading
                                                          ? const Center(
                                                              child:
                                                                  CustomLoadingIndicator(),
                                                            )
                                                          : businessCubit
                                                                  .businesses
                                                                  .isEmpty
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 16
                                                                              .h),
                                                                  child: Text(
                                                                    "no_brands_found"
                                                                        .tr(context),
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .red,
                                                                      fontSize:
                                                                          14.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  height: 90.h,
                                                                  child:
                                                                      ListView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    children: businessCubit
                                                                        .businesses
                                                                        .map(
                                                                            (business) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            VisitedItem(
                                                                          name:
                                                                              business.name,
                                                                          imageUrl:
                                                                              business.imageUrl,
                                                                          onTap:
                                                                              () {
                                                                            navigateTo(
                                                                              context,
                                                                              HomeStoreScreen(
                                                                                businessAccountId: business.id,
                                                                                isVendor: false,
                                                                                businessAccountname: business.name,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                      SizedBox(height: 24.h),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    height: 0.h,
                                                  ),
                                            isVendor != false
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        GlobalCubit>()
                                                                    .changeBottomNavIndex(
                                                                        0);
                                                              },
                                                              title: "home"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/home.png",
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        GlobalCubit>()
                                                                    .changeBottomNavIndex(
                                                                        1);
                                                              },
                                                              title: "nav_info"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/dashboard.png",
                                                              color: Colors
                                                                  .red.shade100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                navigateTo(
                                                                    context,
                                                                    SettingsScreen(
                                                                      isVendor:
                                                                          isVendor,
                                                                    ));
                                                              },
                                                              title: "settings_privacy"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/settings.png",
                                                              color: Colors
                                                                  .red.shade100,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              needSubTitle:
                                                                  true,
                                                              onTap: () {
                                                                navigateTo(
                                                                  context,
                                                                  BlocProvider(
                                                                    create: (context) => StatisticsCubit(sl<
                                                                        StatisticsRepo>())
                                                                      ..fetchStatistics(
                                                                          cubit
                                                                              .businessId),
                                                                    child:
                                                                        const DashboardScreen(),
                                                                  ),
                                                                );
                                                              },

                                                              title: "current_plan"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/plan_brand.png",
                                                              color: Colors
                                                                  .red.shade100,
                                                              subTitle:
                                                                  "الخطة الاساسية", //todo : will get from backend
                                                              subTitleColor: Colors
                                                                  .lightGreenAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                navigateTo(
                                                                    context,
                                                                    const OffersScreen());
                                                              },
                                                              title: "offers"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/discount.png",
                                                              color: Colors
                                                                  .red.shade100,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                navigateTo(
                                                                    context,
                                                                    const FollowersPage());
                                                              },
                                                              title: "friends"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/leadership.png",
                                                              color: Colors.blue
                                                                  .shade100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 16.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                QuickAccessButton(
                                                              onTap: () {
                                                                navigateTo(
                                                                    context,
                                                                    SettingsScreen(
                                                                      isVendor:
                                                                          isVendor,
                                                                    ));
                                                              },
                                                              title: "settings_privacy"
                                                                  .tr(context),
                                                              icon:
                                                                  "assets/images/settings.png",
                                                              color: Colors
                                                                  .red.shade100,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(height: 32.h.h),

                                            isVendor != true
                                                ? const SizedBox()
                                                : Wrap(
                                                    children: [
                                                      accountData!.type ==
                                                              'business'
                                                          ? ApprovalItem(
                                                              title: 'identity_store_request'
                                                                  .tr(context),
                                                              status:
                                                                  ApprovalStatus
                                                                      .approved,
                                                              icon: Image.asset(
                                                                "assets/images/cycle-circle.png",
                                                                width: 24.w,
                                                                height: 24.h,
                                                              ),
                                                              onApprove: () {
                                                                context
                                                                    .read<
                                                                        AccountCubit>()
                                                                    .sendStoreRequest(
                                                                        accountId:
                                                                            cubit.businessId!);
                                                                CustomPopup
                                                                    .show(
                                                                  context:
                                                                      context,
                                                                  type: PopupType
                                                                      .success,
                                                                  title: "request_sent_successfully"
                                                                      .tr(context),
                                                                  message:
                                                                      "request_under_review"
                                                                          .tr(context),
                                                                );
                                                              })
                                                          : const SizedBox(),
                                                      // Second approval item example

                                                      ApprovalItem(
                                                        title:
                                                            'identity_verification_request'
                                                                .tr(context),
                                                        status: ApprovalStatus
                                                            .approved,
                                                        icon: Image.asset(
                                                          "assets/images/verify.png",
                                                          width: 24.w,
                                                          height: 24.h,
                                                        ),
                                                        onApprove: () {
                                                          context
                                                              .read<
                                                                  AccountCubit>()
                                                              .sendVerficationRequest(
                                                                  accountId: cubit
                                                                      .businessId!);

                                                          CustomPopup.show(
                                                            context: context,
                                                            type: PopupType
                                                                .success,
                                                            title:
                                                                "request_sent_successfully"
                                                                    .tr(context),
                                                            message:
                                                                "request_under_review"
                                                                    .tr(context),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                            isVendor == true
                                                ? ExpansionTile(
                                                    //leading:const
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

                                            // const Spacer(),
                                            isVendor != true
                                                ? const BusinessAccountSection()
                                                : const SizedBox(),
                                            isVendor != true
                                                ? SizedBox(height: 30.h) //todo
                                                : const SizedBox(),
                                            state is LogoutLoading
                                                ? const Center(
                                                    child:
                                                        LinearProgressIndicator())
                                                : SignOutButton(
                                                    onPressed: () {
                                                      // Show confirmation popup
                                                      CustomPopup.show(
                                                        type: PopupType.alert,
                                                        context: context,
                                                        titleColor: const Color(
                                                            0xffEC4B4B),
                                                        title: "sign_out"
                                                            .tr(context),
                                                        message:
                                                            "sign_out_confirmation"
                                                                .tr(context),
                                                        primaryButtonText:
                                                            "yes".tr(context),
                                                        secondaryButtonText:
                                                            "no".tr(context),
                                                        onPrimaryButtonPressed:
                                                            () {
                                                          cubit.logout();
                                                        },
                                                        onSecondaryButtonPressed:
                                                            () {
                                                          // Dismiss the popup if user cancels
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
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
