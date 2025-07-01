import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:embone/features/client/chat/view/widgets/massage_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessagesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Message> messages;
  final Message? selectedMessage;
  final Message? focusedMessage;
  final ChatState state;

  const ChatMessagesList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.selectedMessage,
    required this.focusedMessage,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final hasFocus = focusedMessage != null;

    return Container(
      color: hasFocus ? Colors.black.withOpacity(0.3) : Colors.transparent,
      child: state is ChatLoading && messages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final previousMessage =
                        index > 0 ? messages[index - 1] : null;
                    final showDate = previousMessage == null ||
                        _shouldShowDate(
                          previousMessage.createdAt,
                          message.createdAt,
                        );

                    final isSelected = selectedMessage?.id == message.id;
                    final isFocused = focusedMessage?.id == message.id;
                    final isBlurred = hasFocus && !isFocused;

                    return Column(
                      children: [
                        if (showDate)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              _formatDate(context, message.createdAt),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        MessageBubble(
                          message: message,
                          isSelected: isSelected,
                          isFocused: isFocused,
                          isBlurred: isBlurred,
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chat_bubble,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_messages_yet'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'start_conversation'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDate(String? previousDate, String? currentDate) {
    if (previousDate == null || currentDate == null) return true;
    try {
      final prev = DateTime.parse(previousDate);
      final curr = DateTime.parse(currentDate);
      return prev.day != curr.day ||
          prev.month != curr.month ||
          prev.year != curr.year;
    } catch (e) {
      return true;
    }
  }

  String _formatDate(BuildContext context, String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'today'.tr(context);
      } else if (difference.inDays == 1) {
        return 'yesterday'.tr(context);
      } else if (difference.inDays < 7) {
        return _getDayName(date.weekday).tr(context);
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }

  String _getDayName(int weekday) {
    const dayKeys = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return dayKeys[weekday - 1];
  }
}
