import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart'
    show HomeStoreNameSection;
import 'package:embone/features/business_account/home/view/widgets/home_videos.dart';
import 'package:embone/features/client/chat/view/chat_conversation_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/action_button_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_store_description.dart';
import 'home_store_followers.dart';
import 'home_store_hero.dart';
import 'home_store_products.dart';

class HomeStoreContent extends StatelessWidget {
  final int id;
  final BusinessAccountCubit businessAccountCubit;
  final GlobalCubit globalCubit;
  // isvendor case
  final bool? isVendor;
  const HomeStoreContent(
      {super.key,
      required this.id,
      required this.globalCubit,
      required this.businessAccountCubit,
      this.isVendor = false});

  @override
  Widget build(BuildContext context) {
    final accountData = context.read<BusinessAccountCubit>();
    PrintUtil.success(accountData.accountData?.name);
    if (accountData.accountData == null) {
      return const Center(
        child: CustomLoadingIndicator(),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeStoreHero(
                storeLogo: accountData.accountData?.logo,
                storeCover: accountData.accountData?.cover),
            SizedBox(height: 16.h),
            HomeStoreNameSection(
              name: "${accountData.accountData?.name}",
              onTap: () {
                businessAccountCubit.launchLocationUrl(
                    latitude: double.parse(accountData.accountData!.lat),
                    longitude: double.parse(accountData.accountData!.lng));
              },
              isVerified: accountData.accountData?.verified ?? false,
            ),
            SizedBox(height: 16.h),
            HomeStoreFollowers(
                followersCount: accountData.accountData?.totalFollowers ?? 0,
                logo: "${accountData.accountData?.logo}"),
            SizedBox(height: 16.h),
            isVendor != true
                ? ActionButtonsRow(
                    isFavorite: false,
                    isLiked: false,
                    showChat: true,
                    showWhatsApp: true,
                    showFavorite: true,
                    showLike: true,
                    recivereId: accountData.accountData?.id,
                    recivereName: accountData.accountData?.name,
                    recivereImage: accountData.accountData?.logo,
                    onChatPressed: () {
                      navigatorKey.currentState!.push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ChatConversationScreen(
                            receiverId: accountData.accountData?.id ?? 0,
                            name: accountData.accountData?.name ?? '',
                            image: accountData.accountData?.logo ?? '',
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    onFavoritePressed: () {
                      globalCubit.addAccountToWishlist(
                        accountData.accountData?.id ?? 0,
                      );
                    },
                  )
                : HomeStoreProducts(
                    id: accountData.accountData?.id ?? 0,
                    isVendor: isVendor,
                    totalProduct: accountData.accountData?.totalProducts ?? 0,
                  ),
            SizedBox(height: 16.h),
            HomeStoreDescription(
              description: "${accountData.accountData?.description}",
              name: "${accountData.accountData?.name}",
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 500.h,
              child: HomeVideoGridImages(
                businessAccountId: id,
                isVendor: isVendor,
                businessAccountCubit: businessAccountCubit,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
