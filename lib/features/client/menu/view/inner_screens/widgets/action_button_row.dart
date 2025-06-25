import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/view/chat_conversation_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/action_buttons_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (widget.showChat)
            ActionButton(
              icon: "assets/images/svg/chat.svg",
              label: 'message'.tr(context),
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
              label: 'contact'.tr(context),
              onPressed: widget.onWhatsAppPressed ?? () {},
            ),
          if (widget.showFavorite)
            ActionButton(
              icon: widget.isFavorite
                  ? "assets/images/svg/heart-active.svg"
                  : "assets/images/svg/heart.svg",
              label: 'favorite'.tr(context),
              onPressed: widget.onFavoritePressed ??
                  () {
                    cubit.addAccountToWishlist(widget.recivereId ?? 0);
                  },
            ),
          if (widget.showLike)
            ActionButton(
              icon: _isLiked
                  ? "assets/images/svg/like-fill.svg"
                  : "assets/images/svg/like.svg",
              label: 'like'.tr(context),
              onPressed: widget.onLikePressed ??
                  () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
            ),
        ],
      ),
    );
  }
}
