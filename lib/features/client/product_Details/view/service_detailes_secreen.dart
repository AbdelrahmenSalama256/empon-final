import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/update_product_buisniss_account.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/price_display.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_description.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_image.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_info.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_share_bar.dart';
import 'package:embone/features/client/product_Details/view/widgets/service_features.dart';
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
        'avatar': comment.userImage ?? 'assets/images/default_avatar.png',
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
                        : service?.id == null
                            ? Expanded(
                                child: EmptyMessageWidget(
                                  message: 'no_service_data'.tr(context),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ProductImageSection(
                                        images: [
                                          service?.mainImage.isNotEmpty == true
                                              ? service!.mainImage
                                              : 'assets/default_image.png',
                                          ...(service?.listImages
                                                  .where((img) =>
                                                      img.isNotEmpty == true)
                                                  .map((img) => img) ??
                                              []),
                                        ],
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                      ),
                                      SizedBox(height: 15.h),
                                      BlocProvider(
                                        create: (context) =>
                                            ServiceCubit(sl<ServiceRepo>()),
                                        child: InteractionBar(
                                          isActive:
                                              service?.active == true ? 1 : 0,
                                          onActive: () {
                                            cubit.updateServiceStatus(
                                                service!.id ?? 0);
                                                
                                          setState(() {
                                            service.active = service.active == true ? false : true;
                                          });
                                          },
                                          isVendor: widget.isVendor,
                                          likeCount: service?.likes ?? 0,
                                          onEdit: () {
                                            navigateTo(
                                                context,
                                                UpdateProductPage(
                                                    isService: true,
                                                    serviceData:
                                                        cubit.serviceModel,
                                                    businessAccountId: int.parse(
                                                        sl<CacheHelper>().getData(
                                                            key: AppConstants
                                                                .businessAccountId))));
                                          },
                                          onDelete: () {
                                            CustomPopup.show(
                                              context: context,
                                              type: PopupType.alert,
                                              title:
                                                  'delete_product'.tr(context),
                                              titleColor:
                                                  const Color(0xffEC4B4B),
                                              message: 'confirmation_message'
                                                  .tr(context),
                                              primaryButtonText:
                                                  "yes".tr(context),
                                              secondaryButtonText:
                                                  "no".tr(context),
                                                onPrimaryButtonPressed: () async {
                                                Navigator.of(context).pop(); // Close popup
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) => const Center(
                                                    child: CustomLoadingIndicator()),
                                                );
                                                final serviceIdToDelete = service?.id;
                                                try {
                                                  await cubit.deleteService(serviceIdToDelete ?? 0);
                                                  Navigator.of(context, rootNavigator: true).pop(); // Close loading
                                                  showToast(
                                                  context,
                                                  message: 'service_deleted_successfully'.tr(context),
                                                  state: ToastStates.success,
                                                  );
                                                  Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const HomeStoreScreen(isVendor: true,),
                                                  ),
                                                  (route) => false,
                                                  );
                                                } catch (e) {
                                                  Navigator.of(context, rootNavigator: true).pop(); // Close loading
                                                  showToast(
                                                  context,
                                                  message: 'delete_failed'.tr(context),
                                                  state: ToastStates.error,
                                                  );
                                                }
                                                },
                                            );
                                          },
                                          commentCount:
                                              cubit.commentResponse?.total ?? 0,
                                          isLoved: false,

                                          isThumbsUp: service?.isLiked ?? false,

                                          avatarUrls: const [], // Populate if needed
                                          onShare: () {
                                            final serviceId = service?.id ?? 0;
                                            final serviceName =
                                                service?.name ?? "Service";
                                            final deepLink =
                                                "myapp://service/$serviceId";
                                            Share.share(
                                              "Check out this service: $serviceName\n$deepLink",
                                              subject:
                                                  "Awesome Service on Our App",
                                            );
                                          },

                                          onComment: () {
                                            final context =
                                                reviewSectionKey.currentContext;
                                            if (context != null) {
                                              Scrollable.ensureVisible(
                                                context,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                          },
                                          onThumbsUp: () {
                                            cubit.toggleServiceLike(
                                                serviceId: service?.id ?? 0);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      PriceDisplay(
                                        currency: "currency".tr(context),
                                        currentPrice: double.tryParse(
                                                service?.price ?? '0') ??
                                            0.0,
                                      ),
                                      SizedBox(height: 15.h),
                                      ProductInfoSection(
                                        name:
                                            service?.name ?? 'Unknown Service',
                                        price: double.tryParse(
                                                service?.price ?? '0') ??
                                            0.0,
                                        currency: "currency".tr(context),
                                        sellerName:
                                            service?.name ?? 'Unknown Seller',
                                        productId:
                                            service?.id.toString() ?? 'N/A',
                                        sizes: const [
                                          '0'
                                        ], // No sizes for services
                                        type: "services",
                                      ),
                                      SizedBox(height: 15.h),
                                      FeaturesSection(
                                          features: service?.features),
                                      ServiceReviewsSection(
                                        key: reviewSectionKey,
                                        reviews: cubit.comments,
                                        commentController:
                                            cubit.commentController,
                                        isVendor: widget.isVendor,
                                        cubit: cubit,
                                        serviceId: widget.serviceId,
                                      ),
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
