import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:embone/features/client/chat/view/widgets/massage_bubble.dart';
import 'package:embone/features/client/chat/view/widgets/massage_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatConversationScreen extends StatefulWidget {
  final int? receiverId;
  final String? name;
  final String? image;
  final String? online;

  const ChatConversationScreen({
    super.key,
    this.receiverId,
    this.name,
    this.image,
    this.online,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit(sl<ChatRepo>());
    if (widget.receiverId != null) {
      _chatCubit.fetchMessages(widget.receiverId!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatCubit.close();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animate) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _scrollToBottomDelayed() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _scrollToMessage(Message message) {
    final index = _chatCubit.messages.indexWhere((msg) => msg.id == message.id);
    if (index != -1 && _scrollController.hasClients) {
      final position = index * 100.0; // Approximate message height
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showDeleteDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'delete_message'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'delete_message_confirmation'.tr(context),
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(context),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _chatCubit.deleteMessage(message.id);
            },
            child: Text(
              'delete'.tr(context),
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'clear_chat'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'clear_chat_confirmation'.tr(context),
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(context),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _chatCubit.clearChat();
            },
            child: Text(
              'clear'.tr(context),
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receiverId == null) {
      return Scaffold(
        body: Center(child: Text('receiver_id_required'.tr(context))),
      );
    }

    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatLoaded) {
                _scrollToBottomDelayed();
              } else if (state is MassageSentLoaded) {
                _scrollToBottomDelayed();
              } else if (state is ChatScrollToLatest) {
                _scrollToBottom();
              } else if (state is ChatMessageFocused) {
                _scrollToMessage(state.message);
                Future.delayed(const Duration(seconds: 3), () {
                  _chatCubit.clearFocus();
                });
              } else if (state is ChatMessageDeleted) {
                _scrollToBottomDelayed(); // Scroll after deletion
              }
              if (state is MassageSentLoading) {
                // You might want to highlight the sending message
                _scrollToMessage(state.message);
              }
              //  else if (state is MassageSentError) {
              //   // You might want to highlight the failed message
              //   _scrollToMessage(state.);
              // }
            },
            builder: (context, state) {
              final messages = _chatCubit.messages;
              final selectedMessage = _chatCubit.selectedMessage;
              final focusedMessage = _chatCubit.focusedMessage;
              final hasSelection = selectedMessage != null;
              final hasFocus = focusedMessage != null;

              return Stack(
                children: [
                  Column(
                    children: [
                      AppHeader(
                        title: '',
                        centerTitle: false,
                        titleWidget: Row(
                          children: [
                            widget.image != null
                                ? CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage:
                                        NetworkImage(widget.image!),
                                    onBackgroundImageError: (_, __) {},
                                    child: widget.image!.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                            size: 24.sp,
                                          )
                                        : null,
                                  )
                                : Container(
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightGrey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                      size: 24.sp,
                                    ),
                                  ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.name ?? 'Unknown User',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    widget.online ?? 'offline'.tr(context),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: widget.online?.toLowerCase() ==
                                              'online'
                                          ? Colors.green
                                          : const Color(0xff909090),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        showBackButton: true,
                        actions: [
                          if (hasSelection)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // if (selectedMessage.fromMe)
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.red,
                                    size: 24.sp,
                                  ),
                                  onPressed: () =>
                                      _showDeleteDialog(selectedMessage),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade700,
                                    size: 24.sp,
                                  ),
                                  onPressed: () => _chatCubit.clearSelection(),
                                ),
                              ],
                            )
                          else
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.black87,
                                size: 24.sp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 'clear':
                                    _showClearChatDialog();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'clear_chat',
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.delete,
                                        size: 20.sp,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'clear'.tr(context),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (hasSelection)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'message_selected'.tr(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '1 selected',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Container(
                          color: hasFocus
                              ? Colors.black.withOpacity(0.3)
                              : Colors.transparent,
                          child: state is ChatLoading && messages.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : messages.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline,
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
                                    )
                                  : ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 16.h,
                                      ),
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        final message = messages[index];
                                        final previousMessage = index > 0
                                            ? messages[index - 1]
                                            : null;
                                        final showDate =
                                            previousMessage == null ||
                                                _shouldShowDate(
                                                  previousMessage.createdAt,
                                                  message.createdAt,
                                                );

                                        final isSelected =
                                            selectedMessage?.id == message.id;
                                        final isFocused =
                                            focusedMessage?.id == message.id;
                                        final isBlurred =
                                            hasFocus && !isFocused;

                                        return Column(
                                          children: [
                                            if (showDate)
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 6.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                ),
                                                child: Text(
                                                  _formatDate(context,
                                                      message.createdAt),
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
                        ),
                      ),
                      if (!hasFocus)
                        MessageInput(
                          receiverId: widget.receiverId!,
                          onMessageSent: () => _scrollToBottomDelayed(),
                        ),
                    ],
                  ),
                  if (hasFocus)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => _chatCubit.clearFocus(),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(20.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.r,
                                    spreadRadius: 2.r,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 32.sp,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'message_focused'.tr(context),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'tap_to_close'.tr(context),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
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
