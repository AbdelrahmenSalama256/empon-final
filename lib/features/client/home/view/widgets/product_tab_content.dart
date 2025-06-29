import 'package:embone/core/component/widgets/skeleton_loader.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductTabContent extends StatefulWidget {
  final HomeCubit cubit;
  final HomeState state;

  const ProductTabContent(
      {super.key, required this.cubit, required this.state});

  @override
  State<ProductTabContent> createState() => _ProductTabContentState();
}

class _ProductTabContentState extends State<ProductTabContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      if (!widget.cubit.productsIsLoadingMore && widget.cubit.productsHasMore) {
        widget.cubit.loadMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is HomeLoading && widget.cubit.homeModel == null) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ShimmerEffect(
            isLoading: true,
            child: Column(
              children: [
                SkeletonLoader(
                  width: double.infinity,
                  height: 40.h,
                  borderRadius: 8.0,
                  margin: EdgeInsets.only(bottom: 10.h),
                ),
                SizedBox(
                  height: 360.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, itemIndex) {
                      return SkeletonLoader(
                        width: 200.w,
                        height: 300.h,
                        borderRadius: 12.0,
                        margin: EdgeInsets.all(10.w),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final accounts = widget.cubit.homeModel?.accounts ?? [];
        PrintUtil.info(accounts.toString());
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollDetails) {
            // This is a fallback; _onScroll handles the main logic
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            key: const PageStorageKey<String>("product"),
            padding: EdgeInsets.only(bottom: 0.h, left: 0.w, right: 0.w),
            itemCount:
                accounts.length + (widget.cubit.productsIsLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == accounts.length &&
                  widget.cubit.productsIsLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (widget.cubit.homeModel == null || accounts.isEmpty) {
                return Center(child: Text('no_product'.tr(context)));
              }
              final account = accounts[index];
              final productsToList = account.products;
              if (productsToList.isEmpty) return const SizedBox.shrink();
              return ShimmerEffect(
                isLoading: state is HomeLoading,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
                        child: SectionHeader(
                          backgroundColor: const Color(0xffF6F6F6),
                          title: account.name,
                          imageUrl: account.image,
                          onTap: () {
                            PrintUtil.debug("Account tapped: ${account.name}");
                            navigateTo(
                                context,
                                HomeStoreScreen(
                                  businessAccountId: account.id,
                                  isVendor: false,
                                ));
                          },
                          isNetworkImage: true,
                          subtitle: "sponsored".tr(context),
                          showCloseButton: true,
                          onClose: () {
                            if (kDebugMode) {
                              print(
                                  "Close button tapped for account: ${account.name}");
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 360.h,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: productsToList.length,
                          itemBuilder: (context, productIndex) {
                            final product = productsToList[productIndex];
                            return ProductCard(
                              imageUrl: product.imageUrl,
                              title: product.name,
                              price: double.tryParse(product.price) ?? 0.0,
                              badge: 'best_seller'.tr(context),
                              actionText: 'shop_now'.tr(context),
                              isFavorite: product.isFavourite,
                              onFavoriteToggle: () {
                                context
                                    .read<GlobalCubit>()
                                    .addProductToWishlist(product.id);
                              },
                              onActionTap: () {
                                context.read<CartCubit>().addProductToCart(
                                      productId: product.id,
                                      variationId: 6,
                                      quantity: 1,
                                    );
                              },
                              onCardTap: () {
                                navigateTo(
                                  context,
                                  BlocProvider(
                                    create: (context) =>
                                        SearchCubit(sl<SearchRepo>()),
                                    child: ProductDetailPage(
                                        productId: product.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
