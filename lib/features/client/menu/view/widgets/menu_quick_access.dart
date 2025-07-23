import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/widgets/quick_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/navigation.dart';
import '../../../../../core/cubit/global_cubit.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../business_account/dashboard/data/repo/statistics_repo.dart';
import '../../../../business_account/dashboard/view/cubit/statistics_cubit.dart';
import '../../../../business_account/dashboard/view/dashboard_screen.dart';
import '../../../contacts/view/contact_tree/followers_screen.dart';
import '../inner_screens/offers_screen.dart';
import '../inner_screens/settings_screen.dart';

class MenuQuickAccess extends StatelessWidget {
  final bool? isVendor;
  final GlobalCubit cubit;
  final dynamic accountData;

  const MenuQuickAccess({
    super.key,
    required this.isVendor,
    required this.cubit,
    this.accountData,
  });

  @override
  Widget build(BuildContext context) {
    return isVendor != false
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: QuickAccessButton(
                      onTap: () {
                        context.read<GlobalCubit>().changeBottomNavIndex(0);
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
                        context.read<GlobalCubit>().changeBottomNavIndex(1);
                      },
                      title: "nav_info".tr(context),
                      icon: "assets/images/dashboard.png",
                      color: Colors.red.shade100,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: QuickAccessButton(
                        onTap: () {
                          navigateTo(
                              context,
                              SettingsScreen(
                                isVendor: isVendor,
                              ));
                        },
                        title: "settings_privacy".tr(context),
                        icon: "assets/images/settings.png",
                        color: Colors.red.shade100),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: QuickAccessButton(
                      needSubTitle: true,
                      onTap: () {
                        context.read<GlobalCubit>().changeBottomNavIndex(1);
                        // navigateTo(
                        //   context,
                        //   BlocProvider(
                        //     create: (context) =>
                        //         StatisticsCubit(sl<StatisticsRepo>())
                        //           ..fetchStatistics(cubit.businessId),
                        //     child: const DashboardScreen(),
                        //   ),
                        // );
                      },
                      title: "current_plan".tr(context),
                      icon: "assets/images/plan_brand.png",
                      color: Colors.red.shade100,
                      subTitle:
                          accountData?.packageName ?? 'nopack'.tr(context),
                      subTitleColor: Colors.lightGreenAccent,
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
                    child: QuickAccessButton(
                      onTap: () {
                        navigateTo(context, const OffersScreen());
                      },
                      title: "offers".tr(context),
                      icon: "assets/images/discount.png",
                      color: Colors.red.shade100,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: QuickAccessButton(
                      onTap: () {
                        navigateTo(context, const FollowersPage());
                      },
                      title: "friends".tr(context),
                      icon: "assets/images/leadership.png",
                      color: Colors.blue.shade100,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: QuickAccessButton(
                        onTap: () {
                          navigateTo(
                              context,
                              SettingsScreen(
                                isVendor: isVendor,
                              ));
                        },
                        title: "settings_privacy".tr(context),
                        icon: "assets/images/settings.png",
                        color: Colors.red.shade100),
                  ),
                ],
              ),
            ],
          );
  }
}
