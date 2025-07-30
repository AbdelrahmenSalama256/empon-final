import 'dart:io';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/component/custom_toast.dart';
import '../../../../../core/component/widgets/app_header.dart';
import '../../../../../core/cubit/global_cubit.dart';
import '../../data/repo/support_chat_repo.dart';
import '../cubit/cubit/supportchat_cubit.dart';
import '../cubit/cubit/supportchat_state.dart';
import 'widgets/attachment_preview.dart';
import 'widgets/input_area.dart';
import 'widgets/message_bubble_support.dart';

class CustomerSupportChatScreen extends StatefulWidget {
  const CustomerSupportChatScreen({super.key});

  @override
  State<CustomerSupportChatScreen> createState() =>
      _CustomerSupportChatScreenState();
}

class _CustomerSupportChatScreenState extends State<CustomerSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  void _sendMessage(SupportchatCubit cubit) {
    if (_messageController.text.trim().isEmpty && _selectedFile == null) return;

    cubit.sendMessage(
      _messageController.text.trim(),
      file: _selectedFile,
    );

    setState(() {
      _selectedFile = null;
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });

    
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportchatCubit(
        supportChatRepo: sl<SupportChatRepo>(),
        currentUserId: int.parse(sl<GlobalCubit>().userId.toString()),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<SupportchatCubit, SupportchatState>(
          listener: (context, state) {
            if (state is SupportchatError) {
              showToast(
                context,
                message: "unexpected_error".tr(context),
                state: ToastStates.error,
              );
            }
            if (state is SupportchatLoaded) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            final cubit = context.read<SupportchatCubit>();
            return SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    title: '',
                    centerTitle: false,
                    titleWidget: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          clipBehavior: Clip.none,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100.r)),
                          child: Image.asset(
                            "assets/images/logo_text.png",
                            // color: AppColors.primary,
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'customer_support'.tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    showBackButton: true,
                  ),
                  Expanded(
                    child: state is SupportchatLoading && cubit.messages.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : _buildMessageList(cubit),
                  ),
                  InputArea(
                    messageController: _messageController,
                    onPickFile: _pickFile,
                    onSendMessage: _sendMessage,
                    selectedFile: _selectedFile,
                  ),
                  if (_selectedFile != null)
                    AttachmentPreview(
                      file: _selectedFile!,
                      onRemove: () => setState(() => _selectedFile = null),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageList(SupportchatCubit cubit) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      reverse: true,
      itemCount: cubit.messages.length,
      itemBuilder: (context, index) {
        final message = cubit.messages[index];
        final isMe = message.senderType != "App\\Models\\Admin";
     

        return MessageBubble(
          message: message,
          isMe: !isMe,
        );
      },
    );
  }
}
