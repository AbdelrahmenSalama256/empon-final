import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';
import 'package:embone/features/client/chat/view/massages_screen.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/skeleton_loader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<CartRepo>()),
      child: BlocProvider(
        create: (context) => HomeCubit(sl<HomeRepo>())..init(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            final cartCubit = context.read<CartCubit>();

            return BlocListener<GlobalCubit, GlobalState>(
              listener: (context, globalState) {
                if (globalState is WishlistSuccess) {
                  showToast(
                    context,
                    message: globalState.message,
                    state: ToastStates.success,
                  );
                }
              },
              child: BlocListener<CartCubit, CartState>(
                listener: (context, cartState) {
                  if (cartState is AddToCartSuccess) {
                    showToast(
                      context,
                      message: cartState.message.tr(context),
                      state: ToastStates.success,
                    );
                  } else if (cartState is CartError) {
                    showToast(
                      context,
                      message: cartState.error.tr(context),
                      state: ToastStates.error,
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    cubit.init();
                  },
                  child: SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        children: [
                          AppHeader(
                            title: "menu".tr(context),
                            centerTitle: false,
                            showLogo: true,
                            leadingPosition: MainAxisAlignment.end,
                            alignment: HeaderAlignment.spaceBetween,
                            titleStyle: TextStyle(fontSize: 20.sp),
                            showBackButton: false,
                            style: HeaderStyle.standard,
                            automaticallyImplyLeading: false,
                            leading: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.chat_bubble_text,
                                    size: 28.h,
                                    color: const Color(0xff000000),
                                  ),
                                  onPressed: () {
                                    navigateTo(context, const MassagesScreen());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.search,
                                    size: 28.h,
                                    color: const Color(0xff000000),
                                  ),
                                  onPressed: () {
                                    navigateTo(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            SearchCubit(sl<SearchRepo>())
                                              ..init(),
                                        child: const SearchPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          state is HomeLoading
                              ? Expanded(
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    itemCount: 3, // Simulate 3 sections
                                    itemBuilder: (context, index) {
                                      return ShimmerEffect(
                                        isLoading: true,
                                        child: Column(
                                          children: [
                                            SkeletonLoader(
                                              width: double.infinity,
                                              height: 40.h,
                                              borderRadius: 8.0,
                                              margin:
                                                  EdgeInsets.only(bottom: 10.h),
                                            ),
                                            SizedBox(
                                              height: 360.h,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    5, // Simulate 5 products per section
                                                itemBuilder:
                                                    (context, itemIndex) {
                                                  return SkeletonLoader(
                                                    width: 200.w,
                                                    height: 300.h,
                                                    borderRadius: 12.0,
                                                    margin:
                                                        EdgeInsets.all(10.w),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 20.h),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : cubit.homeModel == null
                                  ? const Center(
                                      child: Text('No data available'))
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: cubit.homeModel!.accounts
                                              .map((account) {
                                            return account.products.isEmpty
                                                ? const SizedBox.shrink()
                                                : ShimmerEffect(
                                                    isLoading:
                                                        state is HomeLoading,
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: Color(
                                                                  0xffF6F6F6)),
                                                      child: Column(
                                                        children: [
                                                          SectionHeader(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffF6F6F6),
                                                            title: account.name,
                                                            imageUrl:
                                                                account.image,
                                                            isNetworkImage:
                                                                true,
                                                            subtitle:
                                                                "sponsored".tr(
                                                                    context),
                                                            showCloseButton:
                                                                true,
                                                            onClose: () {
                                                              context
                                                                  .read<
                                                                      GlobalCubit>()
                                                                  .changeBottomNavIndex(
                                                                      0);
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 360.h,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: account
                                                                  .products
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final product =
                                                                    account.products[
                                                                        index];
                                                                return ProductCard(
                                                                  imageUrl: product
                                                                      .imageUrl,
                                                                  title: product
                                                                      .name,
                                                                  price: double
                                                                      .parse(product
                                                                          .price),
                                                                  badge: 'best_seller'
                                                                      .tr(context),
                                                                  actionText:
                                                                      'shop_now'
                                                                          .tr(context),
                                                                  isFavorite:
                                                                      product
                                                                          .isFavourite,
                                                                  onFavoriteToggle:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            GlobalCubit>()
                                                                        .addProductToWishlist(
                                                                            product.id);
                                                                  },
                                                                  onActionTap:
                                                                      () {
                                                                    cartCubit
                                                                        .addProductToCart(
                                                                      productId:
                                                                          product
                                                                              .id,
                                                                      variationId:
                                                                          6,
                                                                    );
                                                                  },
                                                                  onCardTap:
                                                                      () {
                                                                    navigateTo(
                                                                        context,
                                                                        BlocProvider(
                                                                          create: (context) =>
                                                                              SearchCubit(sl<SearchRepo>()),
                                                                          child:
                                                                              ProductDetailPage(
                                                                            productId:
                                                                                product.id,
                                                                          ),
                                                                        ));
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
