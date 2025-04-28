// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class StoreVideoGridImages extends StatefulWidget {
  const StoreVideoGridImages({super.key});

  @override
  State<StoreVideoGridImages> createState() =>
      StoreVideoGridImages_VideoPlayerState();
}

class StoreVideoGridImages_VideoPlayerState
    extends State<StoreVideoGridImages> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _currentPosition = 0;
  String _currentPositionText = "0:02";
  String _totalDurationText = "0:05";

  @override
  void initState() {
    super.initState();
    // Initialize with a sample video
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    )..initialize().then((_) {
        setState(() {});
        // Set up listener for position updates
        _controller.addListener(() {
          if (_controller.value.isPlaying) {
            setState(() {
              _currentPosition = _controller.value.position.inMilliseconds /
                  _controller.value.duration.inMilliseconds;

              // Format position text
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            // Video Player Component
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video
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

                      // Play button overlay
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),

                      // Progress bar and timing
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              // Progress bar
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 4.h,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 6.r,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 14.r,
                                  ),
                                  activeTrackColor: Colors.red,
                                  inactiveTrackColor: Colors.grey[600],
                                  thumbColor: Colors.red,
                                  overlayColor: Colors.red.withOpacity(0.2),
                                ),
                                child: Slider(
                                  value: _currentPosition.clamp(
                                    0.0,
                                    1.0,
                                  ), // Ensure value is between 0 and 1
                                  onChanged: (value) {
                                    setState(() {
                                      _currentPosition = value;
                                      final newPosition = value *
                                          _controller
                                              .value.duration.inMilliseconds;
                                      _controller.seekTo(
                                        Duration(
                                          milliseconds: newPosition.round(),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),

                              // Timing text
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _currentPositionText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    _totalDurationText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
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
            ),

            // Product Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  // Add SALE tag to one item
                  final hasSaleTag = index == 2;

                  return GestureDetector(
                    onTap: () {
                      // Handle product tap
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Product image
                          Image.asset(
                            'assets/images/test-product-1.png',
                            fit: BoxFit.cover,
                          ),

                          // Sale tag
                          if (hasSaleTag)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  "SALE",
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
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
