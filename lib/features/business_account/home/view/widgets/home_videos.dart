import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class HomeVideoGridImages extends StatefulWidget {
  final String videoUrl; // Customizable video URL
  final List<Widget>? gridItems; // Optional custom grid items
  final int gridItemCount; // Number of items if using default grid
  final void Function(int)? onProductTap; // Callback for grid item taps
  final double aspectRatio; // Customizable video aspect ratio
  final List images;

  const HomeVideoGridImages(
    {
    super.key,
    this.videoUrl =
        'https://www.youtube.com/watch?v=HdEzeiSR5eU',
    this.gridItems,
    this.images =const[],
    this.gridItemCount = 12,
    this.onProductTap,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<HomeVideoGridImages> createState() => _HomeVideoGridImagesState();
}

class _HomeVideoGridImagesState extends State<HomeVideoGridImages> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _currentPosition = 0;
  String _currentPositionText = "0:00";
  String _totalDurationText = "0:00";

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        // Video Player Component
        ClipRRect(
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
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: const BoxDecoration(
                      // Replace withOpacity with Color.fromRGBO
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          // Replace withOpacity with Color.fromRGBO
                          Color.fromRGBO(0, 0, 0, 0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4.h,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 6.r),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 14.r),
                            activeTrackColor: Colors.red,
                            inactiveTrackColor: Colors.grey[600],
                            thumbColor: Colors.red,
                            // Replace withOpacity with Color.fromRGBO
                            overlayColor: const Color.fromRGBO(255, 0, 0, 0.2),
                          ),
                          child: Slider(
                            value: _currentPosition.isFinite
                                ? _currentPosition.clamp(0.0, 1.0)
                                : 0.0,
                            onChanged: (value) {
                              setState(() {
                                _currentPosition = value;
                                final newPosition = value *
                                    _controller.value.duration.inMilliseconds;
                                _controller.seekTo(Duration(
                                    milliseconds: newPosition.round()));
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentPositionText,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                            Text(
                              _totalDurationText,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
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
        SizedBox(
          height: 20.h,
        ),
        // Product Grid
        widget.gridItems != null
            ? GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                children: widget.gridItems!,
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: widget.gridItemCount,
                itemBuilder: (context, index) {
                  final hasSaleTag = index == 2;
                  return InkWell(
                    onTap: widget.onProductTap != null
                        ? () => widget.onProductTap!(index)
                        : null,
                    borderRadius: BorderRadius.circular(8.r),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.images.isNotEmpty
                              ? Image.network(
                                  widget.images[index].image,
                                  fit: BoxFit.cover,
                                )
                              : // Fallback image if no images are provided
                          Image.asset(
                            'assets/images/test-product-1.png',
                            fit: BoxFit.cover,
                          ),
                          if (hasSaleTag)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
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
      ],
    );
  }
}
