// embone/features/client/chat/view/chat_conversation_screen.dart
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:embone/features/client/chat/view/widgets/massage_bubble.dart';
import 'package:embone/features/client/chat/view/widgets/massage_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatConversationScreen extends StatelessWidget {
  final int? receiverId;
  const ChatConversationScreen({super.key, this.receiverId});

  @override
  Widget build(BuildContext context) {
    if (receiverId == null) {
      return Scaffold(
        body: Center(child: Text('receiver_id_required'.tr(context))),
      );
    }

    return BlocProvider(
      create: (context) =>
          ChatCubit(sl<ChatRepo>())..fetchMessages(receiverId!),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  AppHeader(
                    title: '',
                    centerTitle: false,
                    titleWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amr Mohamed', // Replace with dynamic name if available
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'online'.tr(context), // Translated status
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff909090),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    showBackButton: true,
                  ),

                  // Chat Messages
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is ChatLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is ChatError) {
                          return Center(
                              child: Text(state.massage ??
                                  'error_loading_messages'.tr(context)));
                        }
                        if (state is ChatLoaded) {
                          final messages = cubit.messages;
                          if (messages.isEmpty) {
                            return Center(
                                child: Text('no_messages_yet'.tr(context)));
                          }
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final previousMessage =
                                  index > 0 ? messages[index - 1] : null;
                              final showDate = previousMessage == null ||
                                  _shouldShowDate(previousMessage.createdAt,
                                      message.createdAt);

                              return Column(
                                children: [
                                  if (showDate)
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Text(
                                        _formatDate(context, message.createdAt),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  MessageBubble(
                                    message: message,
                                    context: context,
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // Message Input
                  const MessageInput(),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper methods to determine date display
  bool _shouldShowDate(String? previousDate, String? currentDate) {
    if (previousDate == null || currentDate == null) return true;
    final prev = DateTime.parse(previousDate);
    final curr = DateTime.parse(currentDate);
    return prev.day != curr.day ||
        prev.month != curr.month ||
        prev.year != curr.year;
  }

  String _formatDate(BuildContext context, String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    final date = DateTime.parse(dateTimeStr);
    return '${_getDayName(date.weekday).tr(context)}, ${date.day}/${date.month}/${date.year % 100}';
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    final date = DateTime.parse(dateTimeStr);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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

// Placeholder ReplayData class for MessageBubble (adjust based on actual implementation)
class ReplayData {
  final String text;
  final bool isVoice;

  ReplayData({required this.text, required this.isVoice});
}
