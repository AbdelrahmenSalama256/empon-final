import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentPreview extends StatelessWidget {
  final File file;
  final Function() onRemove;

  const AttachmentPreview({
    super.key,
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              file,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          ),
          PositionedDirectional(
            top: 4,
            start: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
