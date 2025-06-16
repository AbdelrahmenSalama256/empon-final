// ignore_for_file: deprecated_member_use

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final BuildContext context;

  const MessageBubble({
    super.key,
    required this.message,
    required this.context,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(widget.context) == TextDirection.rtl;
    final isMe = widget.message.fromMe;
    final isVoice = widget.message.mediaType == 'voice';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 0.w,
            vertical: 4.h,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (widget.message.replay != null)
                _buildReplyMessage(isMe, isRTL),
              Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // if (!isMe && !isRTL) _buildAvatar(),
                  // if (isMe && isRTL) _buildAvatar(),
                  SizedBox(
                      width: ((!isMe && !isRTL) || (isMe && isRTL)) ? 8.w : 0),
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(widget.context).size.width * 0.75,
                        minWidth: 60.w,
                      ),
                      child: isVoice
                          ? _buildVoiceMessage(isMe, isRTL)
                          : _buildTextMessage(isMe, isRTL),
                    ),
                  ),
                  SizedBox(
                      width: ((isMe && !isRTL) || (!isMe && isRTL)) ? 8.w : 0),
                  if (isMe && !isRTL) _buildAvatar(),
                  if (!isMe && isRTL) _buildAvatar(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final isMe = widget.message.fromMe;
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMe
              ? [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ]
              : [
                  Colors.grey.shade400,
                  Colors.grey.shade300,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: (isMe ? AppColors.primary : Colors.grey.shade400)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 18.r,
      ),
    );
  }

  Widget _buildReplyMessage(bool isMe, bool isRTL) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8.h,
        right: isMe ? (isRTL ? 0 : 40.w) : 0,
        left: !isMe ? (isRTL ? 40.w : 0) : 0,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: isRTL
              ? BorderSide(
                  color: isMe ? AppColors.primary : Colors.grey.shade400,
                  width: 3.w,
                )
              : const BorderSide(width: 0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'replying_to'.tr(widget.context),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.message.replay!.message,
            style: TextStyle(
              fontSize: 13.sp,
              color: isMe ? AppColors.primary : Colors.black87,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage(bool isMe, bool isRTL) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: isMe
            ? LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isMe ? Colors.white : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(isMe ? 20.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: isMe
                ? AppColors.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: !isMe
            ? Border.all(
                color: Colors.grey.shade200,
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.message,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: isMe ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all_rounded,
                  size: 14.r,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(bool isMe, bool isRTL) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: isMe
            ? LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isMe ? Colors.white : null,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isMe
                ? AppColors.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: !isMe
            ? Border.all(
                color: Colors.grey.shade200,
                width: 1,
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: isMe ? Colors.white : AppColors.primary,
                    size: 20.r,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(child: _buildModernWaveform(isMe)),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'voice_message_duration'.tr(widget.context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isMe ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatTime(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all_rounded,
                  size: 14.r,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernWaveform(bool isMe) {
    return SizedBox(
      height: 32.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          25,
          (index) {
            final heights = [8.h, 16.h, 12.h, 20.h, 14.h, 18.h, 10.h];
            final height = heights[index % heights.length];
            final isActive = _isPlaying && index < 12;

            return AnimatedContainer(
              duration: Duration(milliseconds: 100 + (index * 50)),
              width: 3.w,
              height: height,
              decoration: BoxDecoration(
                color: isActive
                    ? (isMe ? Colors.white : AppColors.primary)
                    : (isMe
                        ? Colors.white.withOpacity(0.5)
                        : Colors.grey.shade400),
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'now'.tr(widget.context);
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return 'date_format'
            .tr(widget.context)
            .replaceAll('{day}', date.day.toString())
            .replaceAll('{month}', date.month.toString());
      } else if (difference.inHours > 0) {
        return 'hours_ago'
            .tr(widget.context)
            .replaceAll('{hours}', difference.inHours.toString());
      } else if (difference.inMinutes > 5) {
        return 'minutes_ago'
            .tr(widget.context)
            .replaceAll('{minutes}', difference.inMinutes.toString());
      } else {
        return 'now'.tr(widget.context);
      }
    } catch (e) {
      return 'now'.tr(widget.context);
    }
  }
}
