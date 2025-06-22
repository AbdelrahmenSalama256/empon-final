import 'dart:io';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/widgets/message_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageContent extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  const MessageContent({
    super.key,
    required this.message,
    required this.isMe,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    if (message.mediaType == 'image' && message.mediaPath != null) {
      return _buildImageMessage(context);
    } else if (message.mediaType == 'voice') {
      return _buildVoiceMessage(context);
    } else {
      return _buildTextMessage(context);
    }
  }

  Widget _buildTextMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomRight: Radius.circular(isMe ? 16.r : 4.r),
          bottomLeft: Radius.circular(isMe ? 4.r : 16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.message,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: isMe ? Colors.white : Colors.black87,
              height: 1.3,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                _formatTime(context, message.createdAt),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                MessageWidgetStatus(status: message.status),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: Radius.circular(message.message.isEmpty ? 12.r : 0),
              bottomRight: Radius.circular(message.message.isEmpty ? 12.r : 0),
            ),
            child: Image.network(
              message.mediaPath!,
              width: MediaQuery.of(context).size.width * 0.65,
              fit: BoxFit.cover,
              height: 200.h,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: 100.h,
                  color: isMe
                      ? AppColors.primary.withOpacity(0.2)
                      : Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: isMe ? Colors.white : AppColors.primary,
                      strokeWidth: 2.w,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Attempt to load local file if mediaPath is a valid file path
                final file = File(message.mediaPath!);
                if (file.existsSync()) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                      bottomLeft:
                          Radius.circular(message.message.isEmpty ? 12.r : 0),
                      bottomRight:
                          Radius.circular(message.message.isEmpty ? 12.r : 0),
                    ),
                    child: Image.file(
                      file,
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 100.h,
                      fit: BoxFit.fitWidth,
                    ),
                  );
                }
                // Fallback to asset if local file is not valid
                return Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: 100.h,
                  color: isMe
                      ? AppColors.primary.withOpacity(0.2)
                      : Colors.grey.shade100,
                  child: Image.asset(
                    "assets/images/placholder.jpg",
                    width: MediaQuery.of(context).size.width * 0.65,
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
          ),
          if (message.message.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              child: Text(
                message.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(context, message.createdAt),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isMe
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.shade500,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  MessageWidgetStatus(status: message.status),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTogglePlay,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: isMe ? Colors.white : AppColors.primary,
                    size: 18.r,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(child: _buildModernWaveform()),
              SizedBox(width: 8.w),
              Text(
                '0:15',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatTime(context, message.createdAt),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                MessageWidgetStatus(status: message.status),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernWaveform() {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          20,
          (index) {
            final heights = [6.h, 12.h, 8.h, 16.h, 10.h, 14.h, 7.h];
            final height = heights[index % heights.length];
            final isActive = isPlaying && index < 10;

            return AnimatedContainer(
              duration: Duration(milliseconds: 100 + (index * 30)),
              width: 2.5.w,
              height: isActive ? height * 1.2 : height,
              decoration: BoxDecoration(
                color: isActive
                    ? (isMe ? Colors.white : AppColors.primary)
                    : (isMe
                        ? Colors.white.withOpacity(0.4)
                        : Colors.grey.shade400),
                borderRadius: BorderRadius.circular(1.r),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, String? dateTimeStr) {
    if (dateTimeStr == null) return 'now'.tr(context);
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${date.day}/${date.month}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 5) {
        return '${difference.inMinutes}m';
      } else {
        return 'now'.tr(context);
      }
    } catch (e) {
      return 'now'.tr(context);
    }
  }
}
