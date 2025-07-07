import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/component/widgets/app_header.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constant.dart';
import '../../../../../core/constants/navigation.dart';
import '../../../../../core/cubit/global_cubit.dart';
import '../../../../../core/network/local_network.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../search/data/repo/search_repo.dart';
import '../../../search/view/cubit/search_cubit.dart';
import '../../../search/view/search_page.dart';
import '../inner_screens/settings_screen.dart';
import '../inner_screens/widgets/accounts_bottom_sheet.dart';
import '../inner_screens/wishlist_screen.dart';

class MenuHeader extends StatelessWidget {
  final bool? isVendor;
  final GlobalCubit cubit;

  const MenuHeader({
    super.key,
    required this.isVendor,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return isVendor != true
        ? Directionality(
            textDirection:
                cubit.language == "ar" ? TextDirection.rtl : TextDirection.rtl,
            child: AppHeader(
              title: "menu".tr(context),
              centerTitle: false,
              leadingPosition: cubit.language == "ar"
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              alignment: HeaderAlignment.spaceBetween,
              titleStyle: TextStyle(fontSize: 20.sp),
              showBackButton: false,
              style: HeaderStyle.standard,
              onBackPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
              automaticallyImplyLeading: false,
              leading: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/svg/search.svg",
                      width: 24.w,
                      height: 24.h,
                    ),
                    onPressed: () {
                      navigateTo(
                        context,
                        BlocProvider(
                          create: (context) =>
                              SearchCubit(sl<SearchRepo>())..init(),
                          child: const SearchPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/svg/heart.svg",
                      width: 24.w,
                      height: 24.h,
                    ),
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
                        cubit.userAccount!.isEmpty
                            ? CupertinoIcons.gear
                            : Icons.keyboard_arrow_down,
                        color: Colors.black,
                        size: 24.w,
                      ),
                    ),
                    onPressed: () {
                      cubit.userAccount!.isEmpty
                          ? navigateTo(
                              context,
                              SettingsScreen(isVendor: isVendor),
                            )
                          : showAccountsBottomSheet(context);
                    },
                  ),
                ],
              ),
            ),
          )
        : _VendorHeader(cubit: cubit);
  }
}

class _VendorHeader extends StatelessWidget {
  final GlobalCubit cubit;

  const _VendorHeader({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final index = cubit.userAccount?.indexWhere((element) =>
            element.id ==
            int.parse(sl<CacheHelper>()
                    .getData(key: AppConstants.businessAccountId) ??
                "0")) ??
        -1;
    final accountData = index != -1 ? cubit.userAccount![index] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.h),
                border: Border.all(color: AppColors.grey, width: 0.2.w),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20.h,
                color: AppColors.black,
              ),
            ),
            onPressed: () {
              context.read<GlobalCubit>().changeBottomNavIndex(0);
            },
          ),
          SizedBox(width: 85.w),
          Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200.r),
                  child: accountData != null
                      ? Image.network(
                          accountData.logo!,
                          width: 74.w,
                          height: 74.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
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
    );
  }
}
