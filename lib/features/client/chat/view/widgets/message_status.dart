import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/chat_state.dart';

class MessageWidgetStatus extends StatelessWidget {
  final MessageStatus status;

  const MessageWidgetStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12.r,
          height: 12.r,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: Colors.white.withOpacity(0.8),
          ),
        );
      case MessageStatus.failed:
        return GestureDetector(
          onTap: () => context.read<ChatCubit>().clearReply(),
          child: Icon(
            Icons.error_outline,
            size: 14.r,
            color: Colors.red,
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.done,
          size: 12.r,
          color: Colors.white.withOpacity(0.8),
        );
      case MessageStatus.delivered:
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12.r,
          color: status == MessageStatus.read
              ? Colors.blue
              : Colors.white.withOpacity(0.8),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
