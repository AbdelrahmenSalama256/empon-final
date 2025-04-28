// ignore_for_file: deprecated_member_use

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isVoice;
  final String time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isVoice,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment:
            !isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isMe && !isVoice)
            Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(isMe ? 0 : 16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (isMe)
                  //   Padding(
                  //     padding: EdgeInsets.only(bottom: 4.h),
                  //     child: Text(
                  //       'you'.tr(context),
                  //       style: TextStyle(
                  //         fontSize: 12.sp,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xffF0F2F9)),
                  ),
                  if (isMe && !isVoice)
                    Padding(
                      padding: EdgeInsets.only(
                        right: isRTL ? 0 : 8.w,
                        left: isRTL ? 8.w : 0,
                      ),
                      child: Text(
                        time,
                        style:
                            TextStyle(fontSize: 10.sp, color: AppColors.white),
                      ),
                    ),
                ],
              ),
            ),
          if (!isMe && !isVoice)
            Container(
              // alignment: !isRTL ? Alignment.centerRight : Alignment.centerLeft,
              constraints: BoxConstraints(maxWidth: 250.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xffF7F7FC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isMe ? 16.r : 0),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  if (!isMe && !isVoice)
                    Padding(
                      padding: EdgeInsets.only(
                        left: isRTL ? 0 : 8.w,
                        right: isRTL ? 8.w : 0,
                      ),
                      child: Text(
                        time,
                        style:
                            TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
          if (isVoice)
            Container(
              constraints: BoxConstraints(maxWidth: 200.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildAudioWaveform()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAudioWaveform() {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          20,
          (index) => Container(
            width: 2.w,
            height: (index % 3 == 0)
                ? 16.h
                : (index % 2 == 0)
                    ? 12.h
                    : 8.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      ),
    );
  }
}
