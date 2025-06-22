import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:embone/features/client/chat/view/widgets/chat_app_bar.dart';
import 'package:embone/features/client/chat/view/widgets/chat_dialogs.dart';
import 'package:embone/features/client/chat/view/widgets/chat_messages_list.dart';
import 'package:embone/features/client/chat/view/widgets/massage_input.dart';
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
    _chatCubit = ChatCubit(sl<ChatRepo>(), widget.receiverId,
        int.parse(context.read<GlobalCubit>().userId.toString()));

    if (widget.receiverId != null) {
      _chatCubit.fetchMessages(widget.receiverId!);
      // _chatCubit.initializeWebSocket();
    } else {
      // Handle case where receiverId is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('receiver_id_required'.tr(context))),
      );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                _scrollToBottomDelayed();
              }
            },
            builder: (context, state) {
              final cubit = context.read<ChatCubit>();
              final hasSelection = cubit.selectedMessage != null;
              final hasFocus = cubit.focusedMessage != null;

              return Stack(
                children: [
                  Column(
                    children: [
                      ChatAppBar(
                        name: widget.name,
                        image: widget.image,
                        online: widget.online,
                        hasSelection: hasSelection,
                        onClearSelection: cubit.clearSelection,
                        onDeleteSelected: _showDeleteDialog,
                        onClearChat: _showClearChatDialog,
                      ),
                      if (hasSelection)
                        SelectionIndicator(
                          onClear: cubit.clearSelection,
                        ),
                      Expanded(
                        child: ChatMessagesList(
                          scrollController: _scrollController,
                          messages: cubit.messages,
                          selectedMessage: cubit.selectedMessage,
                          focusedMessage: cubit.focusedMessage,
                          state: state,
                        ),
                      ),
                      if (!hasFocus)
                        MessageInput(
                          receiverId: widget.receiverId!,
                          onMessageSent: _scrollToBottomDelayed,
                        ),
                    ],
                  ),
                  if (hasFocus)
                    FocusOverlay(
                      onTap: cubit.clearFocus,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
