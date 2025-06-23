import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart'
    show HomeStoreNameSection;
import 'package:embone/features/business_account/home/view/widgets/home_videos.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/product_Details/view/service_detailes_secreen.dart';
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
    final accountData = context.read<BusinessAccountCubit>();
    final serviceCubit = context.read<ServiceCubit>();
    final productCubit = context.read<ProductCubit>();
    //! todo :hanle this case account id not cashed
    PrintUtil.success(accountData.accountData.name );
    return  SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeStoreHero(
                    storeLogo: accountData.accountData.logo, storeCover: accountData.accountData.cover),
                SizedBox(height: 16.h),
                HomeStoreNameSection(
                    name: accountData.accountData.name,
                    isVerified: accountData.accountData.verified),
                SizedBox(height: 16.h),
                HomeStoreFollowers(
                    followersCount: accountData.accountData.totalFollowers,
                    logo: accountData.accountData.logo),
                SizedBox(height: 16.h),
                HomeStoreProducts(
                  id: accountData.accountData.id,
                  totalProduct: accountData.accountData.totalProducts,
                ),
                SizedBox(height: 16.h),
                HomeStoreDescription(
                  description: accountData.accountData.description,
                  name: accountData.accountData.name,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 500.h,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return state is ProductLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : BlocBuilder<ServiceCubit, ServiceState>(
                              builder: (context, state) {
                                return state is ServiceLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : HomeVideoGridImages(
                                        videoUrl: accountData.accountData.videoUrl ??
                                            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                                        gridItemCountservice:
                                            serviceCubit.services.length,
                                        gridItemCount:
                                            productCubit.products.length,
                                        images: productCubit.products
                                            .map((e) => e.image)
                                            .toList(),
                                        imagesService: serviceCubit.services
                                            .map((e) => e.mainImage)
                                            .toList(),

                                        // ignore: avoid_print
                                        onProductTap: (index) => navigateTo(
                                          context,
                                          BlocProvider(
                                            create: (context) =>
                                                SearchCubit(sl<SearchRepo>()),
                                            child: ProductDetailPage(
                                              isVendor: true,
                                              productId: productCubit
                                                  .products[index].id,
                                            ),
                                          ),
                                        ),
                                        hastag: serviceCubit.services
                                            .map((e) => e.approved)
                                            .toList(),
                                        onServiceTap: (index) => navigateTo(
                                          context,
                                          BlocProvider(
                                            create: (context) =>
                                                SearchCubit(sl<SearchRepo>()),
                                            child: ServiceDetailPage(
                                              isVendor: true,
                                              serviceId: serviceCubit
                                                  .services[index].id,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            );
                    },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );

  }
}
