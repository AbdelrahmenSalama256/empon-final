import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_item.dart';
import 'package:embone/features/client/menu/data/repo/wishlist_repo.dart';
import 'package:embone/features/client/menu/view/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/services/service_locator.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WishlistCubit(sl<WishlistRepo>())..fetchFavorites(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              final cubit = context.read<WishlistCubit>();
              final globalCubit = context.read<GlobalCubit>();
              final products = cubit.wishlistData?.data?.products ?? [];
              final accounts = cubit.wishlistData?.data?.accounts ?? [];
              return BlocListener<GlobalCubit, GlobalState>(
                listener: (context, globalState) {
                  if (globalState is WishlistSuccess) {
                    cubit.fetchFavorites();
                  }
                },
                child: Column(
                  children: [
                    AppHeader(
                      title: 'favorite_product'.tr(context),
                      showBackButton: true,
                      centerTitle: true,
                      style: HeaderStyle.standard,
                    ),
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.white,
                        unselectedLabelColor: const Color(0xff152354),
                        indicator: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        dividerColor: Colors.transparent,
                        dividerHeight: 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 7.h),
                        tabs: [
                          Tab(
                            child: Text(
                              "favorite_stores".tr(context),
                              style: TextStyle(
                                fontFamily:
                                    context.read<GlobalCubit>().language == "ar"
                                        ? 'Beiruti'
                                        : "Poppins",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "favorite_products".tr(context),
                              style: TextStyle(
                                fontFamily:
                                    context.read<GlobalCubit>().language == "ar"
                                        ? 'Beiruti'
                                        : "Poppins",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    state is WishlistsLoading
                        ? const Expanded(
                            child: Center(child: CustomLoadingIndicator()))
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await cubit.fetchFavorites();
                              },
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Favorite Stores Tab
                                  accounts.isEmpty
                                      ? Center(
                                          child: Text(
                                            "no_favorite_stores".tr(context),
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(16.w),
                                          itemCount: accounts.length,
                                          itemBuilder: (context, index) {
                                            final account = accounts[index];
                                            return WishlistItemCard(
                                              item: account,
                                              isBrand: true,
                                              onRemove: () {},
                                              onToggleFavorite: () {
                                                globalCubit
                                                    .addAccountToWishlist(
                                                        account.id ?? 0);
                                              },
                                            );
                                          },
                                        ),
                                  // Favorite Products Tab
                                  products.isEmpty
                                      ? Center(
                                          child: Text(
                                            "no_favorite_products".tr(context),
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(16.w),
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            final product = products[index];
                                            return WishlistItemCard(
                                              item: product,
                                              isBrand: false,
                                              onRemove: () {},
                                              onToggleFavorite: () {
                                                globalCubit
                                                    .addProductToWishlist(
                                                        product.id ?? 0);
                                              },
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
