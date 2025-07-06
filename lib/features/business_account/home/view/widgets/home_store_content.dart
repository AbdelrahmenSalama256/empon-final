import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
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
  final bool? isVendor;
  const HomeStoreContent({
    super.key,
    required this.id,
    required this.globalCubit,
    required this.businessAccountCubit,
    this.isVendor = false,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      builder: (context, state) {
        final accountData = context.read<BusinessAccountCubit>();
        if (accountData.accountData == null) {
          return const Center(child: CustomLoadingIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeStoreHero(
                storeLogo: accountData.accountData?.data.logo,
                storeCover: accountData.accountData?.data.cover,
              ),
              SizedBox(height: 16.h),
              HomeStoreNameSection(
                name: "${accountData.accountData?.data.name}",
                onTap: () {
                  businessAccountCubit.launchLocationUrl(
                    latitude: double.parse(accountData.accountData!.data.lat!),
                    longitude: double.parse(accountData.accountData!.data.lng!),
                  );
                },
                isVerified: accountData.accountData?.data.verified ?? false,
              ),
              SizedBox(height: 16.h),
              HomeStoreFollowers(
                followersCount:
                    accountData.accountData?.data.totalFollowers ?? 0,
                businessAccountCubit:
                    accountData, // Pass the cubit for dynamic data
              ),
              SizedBox(height: 16.h),
              isVendor != true
                  ? ActionButtonsRow(
                      isFavorite:
                          accountData.accountData?.data.isFavourited ?? false,
                      isLiked:
                          accountData.accountData?.data.isFollowed ?? false,
                      showChat: true,
                      showWhatsApp: true,
                      showFavorite: true,
                      showLike: true,
                      recivereId: accountData.accountData?.data.id,
                      recivereName: accountData.accountData?.data.name,
                      recivereImage: accountData.accountData?.data.logo,
                      onWhatsAppPressed: () => _launchUrl(
                          'https://wa.me/+2${accountData.accountData?.data.phone ?? ''}'),
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
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 300),
                          ),
                        );
                      },
                      onLikePressed: () {
                        globalCubit.followAccount(
                            accountData.accountData?.data.id ?? 0);
                      },
                      onFavoritePressed: () {
                        globalCubit.addAccountToWishlist(
                            accountData.accountData?.data.id ?? 0);
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
              HomeVideoGridImages(
                businessAccountId: id,
                videoUrl: accountData.accountData?.data.videoUrl,
                isVendor: isVendor,
                businessAccountCubit: businessAccountCubit,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}
