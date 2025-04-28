import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/view/widgets/massage_bubble.dart';
import 'package:embone/features/client/chat/view/widgets/massage_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatConversationScreen extends StatelessWidget {
  const ChatConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample messages data
    final List<Map<String, dynamic>> messages = [
      {
        'text': 'Can I know the available sizes?',
        'isMe': false,
        'time': '09:45',
        'isVoice': false,
      },
      {
        'text': 'Can I know the available sizes?',
        'isMe': true,
        'time': '09:46',
        'isVoice': false,
      },
      {
        'text': 'Available sizes are 37, 38, and 40',
        'isMe': false,
        'time': '09:47',
        'isVoice': false,
      },
      {
        'text': 'OK thank you',
        'isMe': true,
        'time': '14:01',
        'date': 'Sat, 17/10',
        'isVoice': false,
      },
      {'duration': '0:20', 'isMe': true, 'time': '09:12', 'isVoice': true},
      {
        'text': 'Can I know the available sizes?',
        'isMe': false,
        'time': '09:45',
        'isVoice': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Amr Mohamed',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'online'.tr(context),
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
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final showDate = message.containsKey('date');

                  return Column(
                    children: [
                      if (showDate)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            message['date'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      MessageBubble(
                        text: message['text'] ?? '',
                        isMe: message['isMe'],
                        isVoice: message['isVoice'],
                        time: message['time'],
                      ),
                    ],
                  );
                },
              ),
            ),

            // Message Input
            Container(color: Colors.white, child: const MessageInput()),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
