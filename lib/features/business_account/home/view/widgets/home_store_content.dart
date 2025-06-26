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
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> openWhatsApp(String phoneNumber, {String message = ''}) async {
    final uri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountData = context.read<BusinessAccountCubit>();
    PrintUtil.success(accountData.accountData?.data.name);
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
                storeLogo: accountData.accountData?.data.logo,
                storeCover: accountData.accountData?.data.cover),
            SizedBox(height: 16.h),
            HomeStoreNameSection(
              name: "${accountData.accountData?.data.name}",
              onTap: () {
                businessAccountCubit.launchLocationUrl(
                    latitude: double.parse(accountData.accountData!.data.lat),
                    longitude: double.parse(accountData.accountData!.data.lng));
              },
              isVerified: accountData.accountData?.data.verified ?? false,
            ),
            SizedBox(height: 16.h),
            HomeStoreFollowers(
                followersCount:
                    accountData.accountData?.data.totalFollowers ?? 0,
                logo: "${accountData.accountData?.data.logo}"),
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
                    onWhatsAppPressed: () {
                      openWhatsApp(context.read<GlobalCubit>().userPhone ?? '');
                    },
                    onChatPressed: () {
                      navigatorKey.currentState!.push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ChatConversationScreen(
                            receiverId: accountData.accountData?.data.id ?? 0,
                            name: accountData.accountData?.data.name ?? '',
                            image: accountData.accountData?.data.logo ?? '',
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
                        accountData.accountData?.data.id ?? 0,
                      );
                    },
                  )
                : HomeStoreProducts(
                    id: accountData.accountData?.data.id ?? 0,
                    isVendor: isVendor,
                    totalProduct:
                        accountData.accountData?.data.totalProducts ?? 0,
                  ),
            SizedBox(height: 16.h),
            HomeStoreDescription(
              description: "${accountData.accountData?.data.description}",
              name: "${accountData.accountData?.data.name}",
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
