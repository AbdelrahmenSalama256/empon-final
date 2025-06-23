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
import 'package:video_player/video_player.dart';

class HomeVideoGridImages extends StatefulWidget {
  final String? videoUrl;
  final bool? isVendor;
  final int? businessAccountId;
  final BusinessAccountCubit? businessAccountCubit; // Optional Cubit instance
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
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _currentPosition = 0;
  String _currentPositionText = "0:00";
  String _totalDurationText = "0:00";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final videoUrl = widget.videoUrl ??
        (widget.businessAccountCubit?.accountData?.videoUrl ??
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(() {
          if (_controller.value.isPlaying) {
            setState(() {
              _currentPosition = _controller.value.position.inMilliseconds /
                  _controller.value.duration.inMilliseconds;
              final position = _controller.value.position;
              final duration = _controller.value.duration;
              _currentPositionText =
                  "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}";
              _totalDurationText =
                  "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
            });
          }
        });
      });
    if (widget.businessAccountId != null &&
        widget.businessAccountCubit != null) {
      widget.businessAccountCubit!
          .fetchBusinessAccount(widget.businessAccountId!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      bloc: widget.businessAccountCubit,
      builder: (context, state) {
        final accountCubit =
            widget.businessAccountCubit ?? context.read<BusinessAccountCubit>();
        final account = accountCubit.accountData;

        return SafeArea(
          child: Column(
            children: [
              // Video Player Component
              state is BusinessAccountLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _controller.value.isInitialized
                                ? VideoPlayer(_controller)
                                : Container(
                                    color: Colors.black,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color.fromRGBO(0, 0, 0, 0.7),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 4.h,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.r),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 14.r),
                                        activeTrackColor: Colors.red,
                                        inactiveTrackColor: Colors.grey[600],
                                        thumbColor: Colors.red,
                                        overlayColor: const Color.fromRGBO(
                                            255, 0, 0, 0.2),
                                      ),
                                      child: Slider(
                                        value: _currentPosition.isFinite
                                            ? _currentPosition.clamp(0.0, 1.0)
                                            : 0.0,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentPosition = value;
                                            final newPosition = value *
                                                _controller.value.duration
                                                    .inMilliseconds;
                                            _controller.seekTo(Duration(
                                                milliseconds:
                                                    newPosition.round()));
                                          });
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _currentPositionText,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                        ),
                                        Text(
                                          _totalDurationText,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 10.h),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.white,
                unselectedLabelColor: const Color(0xff152354),
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
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

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGridView(
                      account?.products.map((p) => p.image).toList() ?? [],
                      account?.products.map((p) => p.id).toList() ?? [],
                      account?.products.length ?? 0,
                      (index) {
                        if (account?.products.isNotEmpty ?? false) {
                          navigateTo(
                            context,
                            BlocProvider(
                              create: (context) =>
                                  SearchCubit(sl<SearchRepo>()),
                              child: ProductDetailPage(
                                isVendor:
                                    widget.isVendor != true ? false : true,
                                productId: account!.products[index].id,
                              ),
                            ),
                          );
                        }
                      },
                      account?.services.map((s) => s.approved).toList() ?? [],
                    ),
                    _buildGridView(
                      account?.services.map((s) => s.mainImage).toList() ?? [],
                      account?.services.map((s) => s.id).toList() ?? [],
                      account?.services.length ?? 0,
                      (index) {
                        if (account?.services.isNotEmpty ?? false) {
                          navigateTo(
                            context,
                            BlocProvider(
                              create: (context) =>
                                  SearchCubit(sl<SearchRepo>()),
                              child: ServiceDetailPage(
                                isVendor:
                                    widget.isVendor != true ? false : true,
                                serviceId: account!.services[index].id,
                              ),
                            ),
                          );
                        }
                      },
                      account?.services.map((s) => s.approved).toList() ?? [],
                    ),
                  ],
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
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
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
                            Image.asset(
                          'assets/images/test-product-1.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/test-product-1.png',
                        fit: BoxFit.cover,
                      ),
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
                              color: hastag[index] ? Colors.green : Colors.red,
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
    );
  }
}
