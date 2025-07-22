import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/menu/data/repo/offer_repo.dart';
import 'package:embone/features/client/menu/view/cubit/offers_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/offers_state.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ScrollController _scrollController = ScrollController();
  late OffersCubit _offersCubit;

  @override
  void initState() {
    super.initState();
    _offersCubit = OffersCubit(sl<OfferRepo>())..init();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _offersCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      if (!_offersCubit.isLoadingMore && _offersCubit.hasMoreOffers) {
        _offersCubit.fetchOffers(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _offersCubit),
        BlocProvider(create: (context) => GlobalCubit()),
        BlocProvider(create: (context) => CartCubit(sl<CartRepo>())),
      ],
      child: BlocListener<GlobalCubit, GlobalState>(
        listener: (context, globalState) {
          if (globalState is WishlistSuccess) {
            showToast(
              context,
              message: globalState.message,
              state: ToastStates.success,
            );
          }
          if (globalState is WishlistError) {
            showToast(
              context,
              message: 'unexpected_error'.tr(context),
              state: ToastStates.error,
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
                message: 'unexpected_error'.tr(context),
                state: ToastStates.error,
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    title: "special_offers".tr(context),
                    onBackPressed: () => Navigator.pop(context),
                    centerTitle: true,
                    actions: [
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
                    ],
                  ),
                  Expanded(
                    child: _buildOffersList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffersList() {
    return BlocBuilder<OffersCubit, OffersState>(
      builder: (context, state) {
        final cubit = context.read<OffersCubit>();
        if (state is OfferLoading && cubit.offers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return state is OfferLoading
            ? const Center(child: CircularProgressIndicator())
            : cubit.offers.isEmpty
                ? Center(
                    child: EmptyMessageWidget(
                      message: "no_offers".tr(context),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      itemCount: cubit.offers.length +
                          (cubit.hasMoreOffers && state is OfferLoadingMore
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index == cubit.offers.length &&
                            cubit.hasMoreOffers &&
                            state is OfferLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final offer = cubit.offers[index];
                        final offerable = offer.offerable;
                        return Column(
                          children: [
                            ProductCard(
                              imageUrl: "${offerable?.image}",
                              title: offerable?.name ?? '',
                              isOffer: true,
                              price: double.tryParse(offer.offerPrice) ?? 0.0,
                              originalPrice:
                                  double.tryParse(offer.originalPrice),
                              badge: offer.status.tr(context) ==
                                      'pending'.tr(context)
                                  ? 'pending'.tr(context)
                                  : offer.status.tr(context),
                              actionText: 'add_to_cart'.tr(context),
                              isFavorite: GlobalState is WishlistError
                                  ? false
                                  : GlobalState is WishlistSuccess
                                      ? true
                                      : false,
                              discountPercentage: offer.originalPrice != null &&
                                      offer.offerPrice != null
                                  ? ((double.parse(offer.originalPrice) -
                                              double.parse(offer.offerPrice)) /
                                          double.parse(offer.originalPrice) *
                                          100)
                                      .round()
                                  : null,
                              onFavoriteToggle: () {
                                context
                                    .read<GlobalCubit>()
                                    .addProductToWishlist(
                                      offer.id,
                                    );
                              },
                              onActionTap: () {
                                context.read<CartCubit>().addProductToCart(
                                      productId: offer.id,
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
                                    child:
                                        ProductDetailPage(productId: offer.id),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                          ],
                        );
                      },
                    ),
                  );
      },
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Divider(height: 1, color: Colors.grey[300]),
        SizedBox(height: 16.h),
      ],
    );
  }
}
