// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageReply extends StatelessWidget {
  final Replay replay;
  final bool isMe;
  final int? recivereId;

  const MessageReply({
    super.key,
    required this.replay,
    required this.isMe,
    this.recivereId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ChatCubit>().navigateToReply(Message(
            id: replay.id,
            fromMe: isMe,
            status: MessageStatus.sent,
            senderId:
                int.tryParse(context.read<GlobalCubit>().userId ?? '') ?? 0,
            receiverId: 0,
            message: replay.message,
            mediaPath: replay.mediaPath,
            mediaType: replay.mediaType,
            createdAt: DateTime.now().toIso8601String(),
          )),
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
              left: !isRTL(context)
                  ? BorderSide(color: AppColors.primary, width: 3.w)
                  : BorderSide.none,
              right: isRTL(context)
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
                _buildReplyMediaPreview(context)
              else if (replay.mediaType == 'voice')
                _buildReplyVoicePreview(context)
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

  Widget _buildReplyMediaPreview(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.network(
              replay.mediaPath!,
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

  Widget _buildReplyVoicePreview(BuildContext context) {
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

  bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }
}
