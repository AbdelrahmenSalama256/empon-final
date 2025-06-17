import 'dart:async';
import 'dart:io';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  final int receiverId;
  final VoidCallback onMessageSent;

  const MessageInput(
      {super.key, required this.receiverId, required this.onMessageSent});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedMedia = [];

  Timer? _recordingTimer;
  late AnimationController _replyAnimationController;
  late AnimationController _recordingAnimationController;
  late Animation<double> _replySlideAnimation;
  late Animation<double> _recordingPulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _controller.addListener(_onTextChanged);
  }

  void _initializeAnimations() {
    _replyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _replySlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _replyAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _recordingPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _replyAnimationController.dispose();
    _recordingAnimationController.dispose();
    _controller.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    context.read<ChatCubit>().updateInputText(_controller.text);
  }

  Future<void> _pickMedia() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedMedia
            .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    }
  }

  Future<void> _pickCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedMedia.add(File(pickedFile.path));
      });
    }
  }

  void _startRecording() {
    final cubit = context.read<ChatCubit>();
    cubit.startRecording();

    HapticFeedback.mediumImpact();
    _recordingAnimationController.repeat(reverse: true);

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      cubit.updateRecordingDuration(timer.tick);
    });
  }

  void _stopRecording() {
    final cubit = context.read<ChatCubit>();
    cubit.stopRecording();

    _recordingAnimationController.stop();
    _recordingAnimationController.reset();
    _recordingTimer?.cancel();
  }

  void _cancelRecording() {
    final cubit = context.read<ChatCubit>();
    cubit.cancelRecording();

    _recordingAnimationController.stop();
    _recordingAnimationController.reset();
    _recordingTimer?.cancel();

    HapticFeedback.lightImpact();
  }

  void _sendMessage() {
    final cubit = context.read<ChatCubit>();
    final text = _controller.text.trim();

    if (text.isNotEmpty || _selectedMedia.isNotEmpty) {
      if (_selectedMedia.isNotEmpty) {
        for (final media in _selectedMedia) {
          cubit.sendMediaMessage(widget.receiverId, text, 'image', media);
        }
        setState(() {
          _selectedMedia.clear();
        });
      } else {
        cubit.sendTextMessage(widget.receiverId, text);
      }

      _controller.clear();
      widget.onMessageSent();
    }
  }

  void _removeMedia(File media) {
    setState(() {
      _selectedMedia.remove(media);
    });
  }

  String _formatRecordingDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatReplyChanged) {
          if (state.message != null) {
            _replyAnimationController.forward();
          } else {
            _replyAnimationController.reverse();
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        final hasText = cubit.inputText.isNotEmpty;
        final hasMedia = _selectedMedia.isNotEmpty;
        final isRecording = cubit.isRecording;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(_replySlideAnimation),
                child: cubit.replyMessage != null
                    ? _buildReplyPreview(cubit.replyMessage!)
                    : const SizedBox.shrink(),
              ),
              if (hasMedia) _buildMediaPreview(),
              if (isRecording) _buildRecordingOverlay(cubit.recordingDuration),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: isRecording
                    ? _buildRecordingBar()
                    : _buildInputBar(hasText, hasMedia),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputBar(bool hasText, bool hasMedia) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.primary,
            size: 24.sp,
          ),
          onPressed: _pickMedia,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: 'write_massage_here'.tr(context),
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.sp,
                      ),
                      fillColor: Colors.transparent,
                      border: const UnderlineInputBorder(),
                    ),
                    cursorColor: AppColors.primary,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                  onPressed: _pickCamera,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: hasText || hasMedia ? _sendMessage : null,
          onLongPressStart:
              hasText || hasMedia ? null : (_) => _startRecording(),
          onLongPressEnd: hasText || hasMedia ? null : (_) => _stopRecording(),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasText || hasMedia ? Icons.send : Icons.mic,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 24.sp,
          ),
          onPressed: _cancelRecording,
        ),
        Expanded(
          child: Row(
            children: [
              ScaleTransition(
                scale: _recordingPulseAnimation,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final cubit = context.read<ChatCubit>();
                  return Text(
                    _formatRecordingDuration(cubit.recordingDuration),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
              SizedBox(width: 16.w),
              Expanded(child: _buildRecordingWaveform()),
            ],
          ),
        ),
        Container(
          width: 40.w,
          height: 40.h,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingWaveform() {
    return SizedBox(
      height: 30.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(15, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 50)),
            width: 3.w,
            height: (8 + (index % 3) * 4).h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.7),
              borderRadius: BorderRadius.circular(1.5.r),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecordingOverlay(int duration) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.black.withOpacity(0.8),
      child: Row(
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'slide_up_to_cancel'.tr(context),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.white,
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedMedia.length,
        itemBuilder: (context, index) {
          final media = _selectedMedia[index];
          return Container(
            margin: EdgeInsets.only(right: 8.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    media,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4.h,
                  right: 4.w,
                  child: GestureDetector(
                    onTap: () => _removeMedia(media),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReplyPreview(Message replyMessage) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'replying_to'.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  replyMessage.mediaType == 'image'
                      ? 'photo'.tr(context)
                      : replyMessage.mediaType == 'voice'
                          ? 'voice_message'.tr(context)
                          : replyMessage.message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18.sp, color: Colors.grey),
            onPressed: () => context.read<ChatCubit>().clearReply(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
