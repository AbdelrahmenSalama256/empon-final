import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class HomeVideoGridImages extends StatefulWidget {
  final String videoUrl; // Customizable video URL
  final List<Widget>? gridItems; // Optional custom grid items
  final List<Widget>? gridItemsService;
  final int gridItemCount;
  final int gridItemCountservice; // Number of items if using default grid
  final void Function(int)? onProductTap;
  final void Function(int)? onServiceTap; // Callback for grid item taps
  final double aspectRatio; // Customizable video aspect ratio
  final List images;
  final List imagesService;
  final List hastag;
  const HomeVideoGridImages({
    super.key,
    this.videoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    this.gridItems,
    this.gridItemsService,
    this.images = const [],
    this.imagesService = const [],
    this.gridItemCount = 12,
    this.onProductTap,
    this.gridItemCountservice = 12,
    this.aspectRatio = 16 / 9,
    this.onServiceTap,
    this.hastag = const [],
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
    // Use VideoPlayerController.networkUrl instead of the deprecated .network
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
  }

  @override
  void dispose() {
    _controller.dispose();
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
    return Scaffold(
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // Video Player Component
        state is ServiceLoading ?const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor,),
        ) :         ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: AspectRatio(
                    aspectRatio: widget.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : Container(
                                color: Colors.black,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
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
                                    overlayColor:
                                        const Color.fromRGBO(255, 0, 0, 0.2),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
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
                          "products".tr(context), // todo: translate
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
                          "services".tr(context), // todo: translate
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
    
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGridView(widget.gridItems, widget.images,
                          widget.gridItemCount, widget.onProductTap),
                      _buildGridView(
                          widget.gridItemsService,
                          widget.imagesService,
                          widget.gridItemCountservice,
                          widget.onServiceTap),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(
    List<Widget>? gridItems,
    List images,
    int itemCount,
    void Function(int)? onTap,
  ) {
    return gridItems != null
        ? GridView(
            padding: EdgeInsets.all(12.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            children: gridItems,
          )
        : GridView.builder(
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
                onTap: widget.hastag[index] ? () => onTap!(index) : null,
                borderRadius: BorderRadius.circular(8.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      images.isNotEmpty
                          ? Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/test-product-1.png',
                              fit: BoxFit.cover,
                            ),
                      if (widget.hastag.isNotEmpty)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: widget.hastag[index]
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              widget.hastag[index] ? "Available" : "pending",
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
