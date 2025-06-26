import 'package:embone/core/constants/navigation.dart';
import 'package:embone/features/client/chat/view/chat_conversation_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/action_buttons_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtonsRow extends StatefulWidget {
  final int? recivereId;
  final String? recivereName;
  final String? recivereImage;
  final String? recivereOline;
  final bool showChat;
  final bool showWhatsApp;
  final bool showFavorite;
  final bool showLike;
  final VoidCallback? onChatPressed;
  final VoidCallback? onWhatsAppPressed;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onLikePressed;
  final bool isFavorite;
  final bool isLiked;

  const ActionButtonsRow({
    super.key,
    this.recivereId,
    this.recivereName,
    this.recivereImage,
    this.recivereOline,
    this.showChat = true,
    this.showWhatsApp = true,
    this.showFavorite = true,
    this.showLike = true,
    this.onChatPressed,
    this.onWhatsAppPressed,
    this.onFavoritePressed,
    this.onLikePressed,
    this.isFavorite = false,
    this.isLiked = false,
  });

  @override
  State<ActionButtonsRow> createState() => _ActionButtonsRowState();
}

class _ActionButtonsRowState extends State<ActionButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            if (widget.showChat)
              ActionButton(
                icon: "assets/images/svg/chat.svg",
                label: 'message',
                onPressed: widget.onChatPressed ??
                    () {
                      navigateTo(
                        context,
                        ChatConversationScreen(
                          receiverId: widget.recivereId,
                          name: widget.recivereName,
                          image: widget.recivereImage,
                          online: widget.recivereOline,
                        ),
                      );
                    },
              ),
            if (widget.showWhatsApp)
              ActionButton(
                icon: "assets/images/svg/whatsapp.svg",
                label: 'contact',
                onPressed: widget.onWhatsAppPressed ?? () {},
              ),
            if (widget.showFavorite)
              ActionButton(
                icon: "assets/images/svg/heart.svg",
                activeIcon: "assets/images/svg/heart-active.svg",
                label: widget.isFavorite ? 'unfavorite' : 'favorite',
                onPressed: widget.onFavoritePressed ?? () {},
                isActive: widget.isFavorite,
              ),
            if (widget.showLike)
              ActionButton(
                icon: "assets/images/svg/like.svg",
                activeIcon: "assets/images/svg/like.svg",
                label: widget.isLiked ? 'unfollow' : 'follow',
                onPressed: widget.onLikePressed ?? () {},
                isActive: widget.isLiked,
              ),
          ],
        ),
      ),
    );
  }
}
