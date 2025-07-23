import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../data/model/support_message_model.dart';
import 'full_screen_image.dart';

class MessageBubble extends StatelessWidget {
  final SupportMessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        child: Align(
          alignment: !isMe
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color:
                    isMe ? AppColors.primary.withOpacity(0.1) : AppColors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(!isMe ? 12.r : 0),
                  topStart: Radius.circular(!isMe ? 0 : 12.r),
                  bottomEnd: Radius.circular(12.r),
                  bottomStart: Radius.circular(12.r),
                ),
                border: Border.all(
                  color: isMe
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isMe ? AppColors.primary : AppColors.grey,
                      ),
                    ),
                  if (message.mediaPath != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imagePath: message.mediaPath!,
                              heroTag:
                                  'image_${message.mediaPath.hashCode}_${message.createdAt}',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Hero(
                            tag:
                                'image_${message.mediaPath.hashCode}_${message.createdAt}',
                            child: Image.network(
                              message.mediaPath!,
                              width: double.infinity,
                              height: 150.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  "assets/images/placholder.jpg",
                                  width: double.infinity,
                                  height: 150.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
