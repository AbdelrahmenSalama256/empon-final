import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/widgets/message_animations.dart';
import 'package:embone/features/client/chat/view/widgets/message_content.dart';
import 'package:embone/features/client/chat/view/widgets/message_reply.dart';
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
  late MessageAnimations animations;
  double _swipeOffset = 0.0;
  bool _isSwipingToReply = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    animations = MessageAnimations(this);
    animations.initialize();
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        animations.selectionController.forward();
      } else {
        animations.selectionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    animations.dispose();
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
    animations.swipeController.forward();
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

    animations.swipeController.reverse().then((_) {
      setState(() {
        _swipeOffset = 0.0;
        _isSwipingToReply = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.fromMe;

    return AnimatedOpacity(
      opacity: widget.isBlurred ? 0.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: FadeTransition(
        opacity: animations.fadeAnimation,
        child: ScaleTransition(
          scale: widget.isFocused
              ? const AlwaysStoppedAnimation(1.1)
              : (widget.isSelected
                  ? animations.selectionAnimation
                  : animations.scaleAnimation),
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
                    right: isMe ? null : 20.w,
                    left: isMe ? 20.w : null,
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
                              MessageReply(
                                replay: widget.message.replay!,
                                isMe: isMe,
                                recivereId: widget.message.receiverId,
                              ),
                              SizedBox(height: 10.h),
                            ],
                            MessageContent(
                              message: widget.message,
                              isMe: isMe,
                              isPlaying: _isPlaying,
                              onTogglePlay: () => setState(() {
                                _isPlaying = !_isPlaying;
                              }),
                            ),
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
}
