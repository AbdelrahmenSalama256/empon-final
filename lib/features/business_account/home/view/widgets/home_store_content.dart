import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart'
    show HomeStoreNameSection;
import 'package:embone/features/business_account/home/view/widgets/home_videos.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_store_description.dart';
import 'home_store_followers.dart';
import 'home_store_hero.dart';
import 'home_store_products.dart';

class HomeStoreContent extends StatelessWidget {
  final int id;
  const HomeStoreContent({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();
    int index =
        cubit.userAccount?.indexWhere((element) => element.id == id) ?? -1;

    final accountData = index != -1 ? cubit.userAccount![index] : null;
    //! todo :hanle this case account id not cashed
    PrintUtil.success(accountData!.name ?? 'No account data found');
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeStoreHero(
              storeLogo: accountData.logo, storeCover: accountData.cover),
          SizedBox(height: 16.h),
          HomeStoreNameSection(
              name: accountData.name!,
              isVerified: accountData.verified ?? false),
          SizedBox(height: 16.h),
          HomeStoreFollowers(
              followersCount: accountData.totalFollowers ?? 0,
              logo: "${accountData.logo}"),
          SizedBox(height: 16.h),
          HomeStoreProducts(
            id: accountData.id ?? 0,
            totalProduct: accountData.totalProducts ?? 0,
          ),
          SizedBox(height: 16.h),
          HomeStoreDescription(
            description: accountData.description!,
            name: accountData.name!,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 500.h,
            child: SingleChildScrollView(
              child: HomeVideoGridImages(
                videoUrl: accountData.videoUrl ??
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                gridItemCount: accountData.totalProducts ?? 0,
                images: accountData.products ?? [],
                // ignore: avoid_print
                onProductTap: (index) => navigateTo(
                  context,
                  BlocProvider(
                    create: (context) => SearchCubit(sl<SearchRepo>()),
                    child: ProductDetailPage(
                      isVendor: true,
                      productId: accountData.products?[index].id ?? 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
