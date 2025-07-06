import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/product_Details/view/service_detailes_secreen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeVideoGridImages extends StatefulWidget {
  final String? videoUrl;
  final bool? isVendor;
  final int? businessAccountId;
  final BusinessAccountCubit? businessAccountCubit;
  const HomeVideoGridImages({
    super.key,
    this.videoUrl,
    this.businessAccountId,
    this.businessAccountCubit,
    this.isVendor = false,
  });

  @override
  State<HomeVideoGridImages> createState() => _HomeVideoGridImagesState();
}

class _HomeVideoGridImagesState extends State<HomeVideoGridImages>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Initialize with 2 tabs by default
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      bloc: widget.businessAccountCubit,
      builder: (context, state) {
        final accountCubit =
            widget.businessAccountCubit ?? context.read<BusinessAccountCubit>();
        final account = accountCubit.accountData;
        final filteredProducts = widget.isVendor != true
            ? account?.data.products!.where((p) => p.active == 1).toList() ?? []
            : account?.data.products ?? [];
        final filteredServices = widget.isVendor != true
            ? account?.data.services!
                    .where((s) => s.active && s.approved)
                    .toList() ??
                []
            : account?.data.services ?? [];

        // Determine tab visibility and controller length based on data
        final hasProducts = filteredProducts.isNotEmpty;
        final hasServices = filteredServices.isNotEmpty;
        final tabCount = (hasProducts ? 1 : 0) + (hasServices ? 1 : 0);

        // Update tab controller length dynamically if needed
        if (_tabController.length != tabCount && tabCount > 0) {
          _tabController.dispose();
          _tabController = TabController(length: tabCount, vsync: this);
        }

        return SafeArea(
          child: Column(
            children: [
              state is BusinessAccountLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor),
                    )
                  : VideosTab(videoUrl: widget.videoUrl),
              SizedBox(height: 10.h),

              // Conditionally show TabBar based on content
              if (hasProducts || hasServices)
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
                    labelStyle:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    dividerColor: Colors.transparent,
                    dividerHeight: 0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                    tabs: [
                      if (hasProducts)
                        Tab(
                          child: Center(
                            widthFactor: 15.w,
                            child: Text(
                              "products".tr(context),
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
                        ),
                      if (hasServices)
                        Tab(
                          child: Center(
                            widthFactor: 15.w,
                            child: Text(
                              "services".tr(context),
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
                        ),
                    ],
                  ),
                ),

              // Conditionally show TabBarView or empty message
              if (hasProducts || hasServices)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      if (hasProducts)
                        _buildGridView(
                          filteredProducts.map((p) => p.image).toList(),
                          filteredProducts.map((p) => p.id).toList(),
                          filteredProducts.length,
                          (index) {
                            if (filteredProducts.isNotEmpty) {
                              navigateTo(
                                context,
                                BlocProvider(
                                  create: (context) =>
                                      SearchCubit(sl<SearchRepo>()),
                                  child: ProductDetailPage(
                                    isVendor: widget.isVendor ?? false,
                                    productId: filteredProducts[index].id,
                                  ),
                                ),
                              );
                            }
                          },
                          filteredProducts.map((p) => p.active == 1).toList(),
                        ),
                      if (hasServices)
                        _buildGridView(
                          filteredServices.map((s) => s.mainImage).toList(),
                          filteredServices.map((s) => s.id).toList(),
                          filteredServices.length,
                          (index) {
                            if (filteredServices.isNotEmpty) {
                              navigateTo(
                                context,
                                BlocProvider(
                                  create: (context) =>
                                      SearchCubit(sl<SearchRepo>()),
                                  child: ServiceDetailPage(
                                    isVendor: widget.isVendor ?? false,
                                    serviceId: filteredServices[index].id,
                                  ),
                                ),
                              );
                            }
                          },
                          filteredServices.map((s) => s.approved).toList(),
                        ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Text(
                      "no_products_or_services".tr(context),
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridView(
    List<String>? images,
    List<int>? ids,
    int itemCount,
    void Function(int)? onTap, [
    List<bool>? hastag,
  ]) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.4, // Match TabBarView height
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Disable scrolling if inside a scrollable
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: onTap != null ? () => onTap(index) : null,
            borderRadius: BorderRadius.circular(8.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  images != null && images.isNotEmpty && index < images.length
                      ? Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/test-product-1.png',
                                  fit: BoxFit.cover),
                        )
                      : Image.asset('assets/images/test-product-1.png',
                          fit: BoxFit.cover),
                  if (hastag != null &&
                      hastag.isNotEmpty &&
                      index < hastag.length)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: widget.isVendor != true
                          ? const SizedBox()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color:
                                    hastag[index] ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                hastag[index]
                                    ? "available".tr(context)
                                    : "pending".tr(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideosTab extends StatelessWidget {
  final String? videoUrl;
  const VideosTab({super.key, this.videoUrl});

  @override
  Widget build(BuildContext context) {
    String? videoId =
        videoUrl != null ? YoutubePlayer.convertUrlToId(videoUrl!) : null;

    if (videoId == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: const Center(child: Text('لا توجد فيديوهات')),
      );
    }

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        showLiveFullscreenButton: true,
      ),
    );

    return AspectRatio(
      aspectRatio: 16 / 9, // Standard YouTube aspect ratio
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: YoutubePlayer(
          progressColors: const ProgressBarColors(
              handleColor: AppColors.red, playedColor: AppColors.red),
          progressIndicatorColor: AppColors.red,
          controller: controller,
          liveUIColor: AppColors.primary,
        ),
      ),
    );
  }
}
