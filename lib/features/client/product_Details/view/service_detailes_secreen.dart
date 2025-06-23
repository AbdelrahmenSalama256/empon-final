import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/inventory_button.dart';
import 'package:embone/features/client/product_Details/view/widgets/price_display.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_description.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_image.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_info.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_share_bar.dart';
import 'package:embone/features/client/product_Details/view/widgets/service_review_section.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class ServiceDetailPage extends StatefulWidget {
  final bool isVendor;
  final int serviceId;

  const ServiceDetailPage({
    super.key,
    this.isVendor = false,
    required this.serviceId,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().goToService(id: widget.serviceId);
  }

  List<Map<String, dynamic>> _convertCommentsToMap(
      List<CommentModel> comments) {
    return comments.map((comment) {
      return {
        'commentId': comment.commentId,
        'avatar': comment.userImage ??
            'assets/images/default_avatar.png', // Add default avatar
        'name': comment.userName,
        'date': comment.time,
        'comment': comment.comment,
        'likes': comment.likesCount,
        'isLiked': comment.isLiked,
        'replies': comment.replies
                ?.map((reply) => {
                      'commentId': reply.commentId,
                      'avatar':
                          reply.userImage ?? 'assets/images/default_avatar.png',
                      'name': reply.userName,
                      'date': reply.time,
                      'comment': reply.comment,
                      'likes': reply.likesCount,
                      'isLiked': reply.isLiked,
                    })
                .toList() ??
            [],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final GlobalKey reviewSectionKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            final cubit = context.read<SearchCubit>();
            final service = cubit.serviceModel?.data;

            _convertCommentsToMap(cubit.commentResponse?.data.comments ?? []);

            return BlocBuilder<GlobalCubit, GlobalState>(
              builder: (context, state) {
                return Column(
                  children: [
                    AppHeader(
                      title: 'service_details'.tr(context),
                      centerTitle: true,
                      onBackPressed: () => Navigator.pop(context),
                    ),
                    searchState is GoToProductLoading
                        ? const Expanded(
                            child: Center(child: CustomLoadingIndicator()))
                        : Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ProductImageSection(
                                    images: [
                                      service?.mainImage ?? '',
                                      ...?(service?.listImages
                                          .map((img) => img))
                                    ],
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 4),
                                  ),
                                  SizedBox(height: 15.h),
                                  InteractionBar(
                                    isVendor: widget.isVendor,
                                    // likeCount: service?.price ?? 0,
                                    onEdit: () {
                                      navigateTo(
                                          context,
                                          AddProductPage(
                                              businessAccountId: int.parse(
                                                  sl<CacheHelper>().getData(
                                                      key: AppConstants
                                                          .businessAccountId))));
                                    },
                                    onDelete: () => CustomPopup.show(
                                      context: context,
                                      type: PopupType.alert,
                                      title: 'delete_product'.tr(context),
                                      titleColor: const Color(0xffEC4B4B),
                                      message:
                                          'confirmation_message'.tr(context),
                                      primaryButtonText: "yes".tr(context),
                                      secondaryButtonText: "no".tr(context),
                                      onPrimaryButtonPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    ),
                                    commentCount:
                                        cubit.commentResponse?.total ?? 0,
                                    onShare: () {
                                      final serviceId =
                                          cubit.serviceModel?.data?.id ?? 0;
                                      final serviceName =
                                          cubit.serviceModel?.data?.name ??
                                              "Product";
                                      final deepLink =
                                          "myapp://product/$serviceId";

                                      Share.share(
                                        "Check out this product: $serviceName\n$deepLink",
                                        subject: "Awesome Product on Our App",
                                      );
                                    },
                                    // onLike: () {
                                    //   context
                                    //       .read<GlobalCubit>()
                                    //       .addProductToWishlist(
                                    //           cubit.productModel?.data?.id ??
                                    //               0);
                                    // },
                                    onComment: () {
                                      final context =
                                          reviewSectionKey.currentContext;
                                      if (context != null) {
                                        Scrollable.ensureVisible(
                                          context,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    onThumbsUp: () {
                                      cubit.toggleServiceLike(
                                        serviceId:
                                            cubit.serviceModel?.data?.id ?? 0,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 15.h),
                                  if (widget.isVendor)
                                    InventoryButton(
                                      onPressed: () {},
                                    ),
                                  SizedBox(height: 15.h),
                                  PriceDisplay(
                                    currency: "",
                                    currentPrice: double.tryParse(
                                            service?.price ?? '0') ??
                                        0.0,
                                    //originalPrice: service?. == 1.0
                                    // ? (double.tryParse(
                                    //             product?.price ?? '0') ??
                                    //         0.0) *
                                    //     1.5
                                    // : null,
                                  ),
                                  SizedBox(height: 15.h),
                                  ProductInfoSection(
                                    name: service?.name ?? 'Unknown Product',
                                    price: double.tryParse(
                                            service?.price ?? '0') ??
                                        0.0,
                                    currency: "EGP",
                                    sellerName:
                                        service?.name ?? 'Unknown Seller',
                                    productId: service?.id.toString() ?? 'N/A',
                                    sizes: const ['10'],
                                  ),
                                  SizedBox(height: 15.h),
                                  BlocBuilder<SearchCubit, SearchState>(
                                      builder: (context, state) {
                                    final cubit = context.read<SearchCubit>();

                                    if (state is CommentLoading) {
                                      return const Center(
                                          child: CustomLoadingIndicator());
                                    }

                                    return ServiceReviewsSection(
                                      key: reviewSectionKey,
                                      reviews: cubit.comments,
                                      commentController:
                                          cubit.commentController,
                                      isVendor: widget.isVendor,
                                      cubit: cubit,
                                      serviceId: widget.serviceId,
                                    );
                                  }),
                                  SizedBox(height: 15.h),

                                  ProductDescriptionSection(
                                    description: service?.details ??
                                        'No description available.',
                                  ),
                                  SizedBox(height: 15.h),

                                ],
                              ),
                            ),
                          ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
