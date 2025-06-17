import 'dart:io';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isSelected;
  final bool isFocused;
  final bool isBlurred;

  const MessageBubble({
    super.key,
    required this.message,
    this.isSelected = false,
    this.isFocused = false,
    this.isBlurred = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _swipeAnimationController;
  late AnimationController _selectionAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _selectionAnimation;

  bool _isPlaying = false;
  double _swipeOffset = 0.0;
  bool _isSwipingToReply = false;

  static const String _baseUrl = 'https://empon.evyx.lol/storage/chat_media/';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _handleResend() {
    final cubit = context.read<ChatCubit>();
    final message = widget.message;

    if (message.mediaType == 'text') {
      cubit.sendTextMessage(message.receiverId, message.message);
    } else if (message.mediaType == 'image' || message.mediaType == 'voice') {
      if (message.mediaPath != null) {
        final mediaFile = File(message.mediaPath!);
        cubit.sendMediaMessage(
          message.receiverId,
          message.message,
          message.mediaType,
          mediaFile,
        );
      }
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _selectionAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _selectionAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _selectionAnimationController.forward();
      } else {
        _selectionAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swipeAnimationController.dispose();
    _selectionAnimationController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    HapticFeedback.mediumImpact();
    context.read<ChatCubit>().selectMessage(widget.message);
  }

  void _handleTap() {
    final cubit = context.read<ChatCubit>();

    if (cubit.selectedMessage != null) {
      cubit.clearSelection();
    } else if (widget.message.replayId != null) {
      cubit.navigateToReply(widget.message);
    }
  }

  void _handleSwipeStart(DragStartDetails details) {
    if (widget.isBlurred) return;

    setState(() {
      _isSwipingToReply = true;
    });
    _swipeAnimationController.forward();
  }

  void _handleSwipeUpdate(DragUpdateDetails details) {
    if (widget.isBlurred) return;

    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isMe = widget.message.fromMe;

    double newOffset =
        _swipeOffset + (isRTL ? -details.delta.dx : details.delta.dx);

    if (isMe) {
      newOffset = newOffset.clamp(0.0, 60.0);
    } else {
      newOffset = newOffset.clamp(-60.0, 0.0);
    }

    setState(() {
      _swipeOffset = newOffset;
    });
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (widget.isBlurred) return;

    if (_swipeOffset.abs() > 30.0) {
      HapticFeedback.mediumImpact();
      context.read<ChatCubit>().setReplyMessage(widget.message);
    }

    _swipeAnimationController.reverse().then((_) {
      setState(() {
        _swipeOffset = 0.0;
        _isSwipingToReply = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isMe = widget.message.fromMe;

    return AnimatedOpacity(
      opacity: widget.isBlurred ? 0.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: widget.isFocused
              ? const AlwaysStoppedAnimation(1.1)
              : (widget.isSelected ? _selectionAnimation : _scaleAnimation),
          child: GestureDetector(
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            onHorizontalDragStart: _handleSwipeStart,
            onHorizontalDragUpdate: _handleSwipeUpdate,
            onHorizontalDragEnd: _handleSwipeEnd,
            child: Stack(
              children: [
                if (_isSwipingToReply && !widget.isBlurred)
                  Positioned(
                    left: isMe ? null : 20.w,
                    right: isMe ? 20.w : null,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: (_swipeOffset.abs() / 60.0).clamp(0.0, 1.0),
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.reply_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.isSelected)
                  Positioned(
                    left: isMe ? null : 0,
                    right: isMe ? 0 : null,
                    top: 0,
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  ),
                if (widget.isFocused)
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8.r,
                            spreadRadius: 2.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                AnimatedContainer(
                  duration: widget.isBlurred
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  transform: Matrix4.translationValues(_swipeOffset, 0, 0),
                  margin: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 2.h,
                    bottom: 2.h,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              widget.message.replay != null ? 10.w : 0.w,
                          vertical: widget.message.replay != null ? 10.h : 0.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.message.replay != null
                              ? AppColors.lightGrey.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              widget.message.replay != null ? 12.r : 0.r),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.message.replay != null) ...[
                              _buildReplyMessage(isMe, isRTL),
                              SizedBox(height: 10.h),
                            ],
                            _buildMessageContent(isMe, isRTL),
                            if (widget.message.replay != null)
                              SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReplyMessage(bool isMe, bool isRTL) {
    final replay = widget.message.replay;
    if (replay == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.read<ChatCubit>().navigateToReply(widget.message),
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.lightGrey
                : AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
            border: Border(
              left: !isRTL
                  ? BorderSide(color: AppColors.primary, width: 3.w)
                  : BorderSide.none,
              right: isRTL
                  ? BorderSide(color: AppColors.primary, width: 3.w)
                  : BorderSide.none,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.reply,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isMe
                        ? 'you'.tr(context)
                        : replay.message.isNotEmpty
                            ? 'sender_name'.tr(context)
                            : 'replying_to'.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              if (replay.mediaType == 'image' && replay.mediaPath != null)
                _buildReplyMediaPreview(replay, isMe)
              else if (replay.mediaType == 'voice')
                _buildReplyVoicePreview(isMe)
              else
                Text(
                  replay.message.isNotEmpty
                      ? replay.message
                      : 'message_deleted'.tr(context),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isMe
                        ? AppColors.primary.withOpacity(0.8)
                        : Colors.black87,
                    fontStyle: replay.message.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyMediaPreview(Replay replay, bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.network(
              replay.mediaPath!.startsWith('http')
                  ? replay.mediaPath!
                  : '$_baseUrl${replay.mediaPath}',
              width: 40.w,
              height: 40.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 20.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 14.sp,
                      color: isMe
                          ? AppColors.primary.withOpacity(0.8)
                          : Colors.grey.shade600,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'photo'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isMe
                            ? AppColors.primary.withOpacity(0.8)
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (replay.message.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    replay.message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isMe
                          ? AppColors.primary.withOpacity(0.9)
                          : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyVoicePreview(bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mic,
              color: isMe ? Colors.white.withOpacity(0.8) : AppColors.primary,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'voice_message'.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isMe
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: List.generate(8, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: 2.w),
                      width: 2.w,
                      height: (6 + (index % 3) * 2).h,
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Text(
            '0:15',
            style: TextStyle(
              fontSize: 11.sp,
              color:
                  isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(bool isMe, bool isRTL) {
    final message = widget.message;

    if (message.mediaType == 'image' && message.mediaPath != null) {
      return _buildImageMessage(isMe, isRTL);
    } else if (message.mediaType == 'voice') {
      return _buildVoiceMessage(isMe, isRTL);
    } else {
      return _buildTextMessage(isMe, isRTL);
    }
  }

  Widget _buildTextMessage(bool isMe, bool isRTL) {
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
            widget.message.message,
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
                _formatTime(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                _buildMessageStatus(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(bool isMe, bool isRTL) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
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
              bottomLeft:
                  Radius.circular(widget.message.message.isEmpty ? 12.r : 0),
              bottomRight:
                  Radius.circular(widget.message.message.isEmpty ? 12.r : 0),
            ),
            child: Image.network(
              widget.message.mediaPath!.startsWith('http')
                  ? widget.message.mediaPath!
                  : '$_baseUrl${widget.message.mediaPath}',
              width: MediaQuery.of(context).size.width * 0.65,
              fit: BoxFit.fitWidth,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: 200.h,
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
              errorBuilder: (context, error, stackTrace) => Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: 200.h,
                color: isMe
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_rounded,
                        size: 40.sp,
                        color:
                            isMe ? Colors.white.withOpacity(0.7) : Colors.grey),
                    SizedBox(height: 8.h),
                    Text(
                      'image_load_error'.tr(context),
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.message.message.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              child: Text(
                widget.message.message,
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
                  _formatTime(widget.message.createdAt),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isMe
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.shade500,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  _buildMessageStatus(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(bool isMe, bool isRTL) {
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
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
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
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: isMe ? Colors.white : AppColors.primary,
                    size: 18.r,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(child: _buildModernWaveform(isMe)),
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
                _formatTime(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMe
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade500,
                ),
              ),
              if (isMe) ...[
                SizedBox(width: 4.w),
                _buildMessageStatus(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernWaveform(bool isMe) {
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
            final isActive = _isPlaying && index < 10;

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

  Widget _buildMessageStatus() {
    if (widget.message.status == MessageStatus.sending) {
      return SizedBox(
        width: 12.r,
        height: 12.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          color: Colors.white.withOpacity(0.8),
        ),
      );
    } else if (widget.message.status == MessageStatus.failed) {
      return GestureDetector(
        onTap: () => _handleResend(),
        child: Icon(
          Icons.error_outline,
          size: 14.r,
          color: Colors.red,
        ),
      );
    } else if (widget.message.status == MessageStatus.sent) {
      return Icon(
        Icons.done,
        size: 12.r,
        color: Colors.white.withOpacity(0.8),
      );
    } else if (widget.message.status == MessageStatus.delivered ||
        widget.message.status == MessageStatus.read) {
      return Icon(
        Icons.done_all,
        size: 12.r,
        color: widget.message.status == MessageStatus.read
            ? Colors.blue
            : Colors.white.withOpacity(0.8),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _formatTime(String? dateTimeStr) {
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
