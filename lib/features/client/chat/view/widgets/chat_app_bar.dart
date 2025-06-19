import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAppBar extends StatelessWidget {
  final String? name;
  final String? image;
  final String? online;
  final bool hasSelection;
  final VoidCallback onClearSelection;
  final Function(Message) onDeleteSelected;
  final VoidCallback onClearChat;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.image,
    required this.online,
    required this.hasSelection,
    required this.onClearSelection,
    required this.onDeleteSelected,
    required this.onClearChat,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();

    return AppHeader(
      title: '',
      centerTitle: false,
      titleWidget: Row(
        children: [
          image != null
              ? CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(image!),
                  onBackgroundImageError: (_, __) {},
                  child: image!.isEmpty
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
                  name ?? 'Unknown User',
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
                  online ?? 'offline'.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: online?.toLowerCase() == 'online'
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
              IconButton(
                icon: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                  size: 24.sp,
                ),
                onPressed: () => onDeleteSelected(cubit.selectedMessage!),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade700,
                  size: 24.sp,
                ),
                onPressed: onClearSelection,
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
                  onClearChat();
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
    );
  }
}
