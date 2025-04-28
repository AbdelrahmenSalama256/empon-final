// ignore: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';
// import 'package:embone/core/constants/widgets/custom-shimmer.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.h,
    this.w,
    this.borderRadius,
    this.fit,
  });

  final String? imageUrl;
  final double? h, w, borderRadius;
  final BoxFit? fit;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  late String imageKey;
  @override
  void initState() {
    super.initState();
    imageKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void reloadImage() {
    setState(() {
      imageKey = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.h,
      width: widget.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20.r),
        child: Image.network(
          "${widget.imageUrl}",
          key: ValueKey(imageKey),
          height: widget.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  reloadImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.replay_outlined,
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
