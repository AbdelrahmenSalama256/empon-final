import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/wishlist_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/action_buttons_store.dart';
import 'package:flutter/material.dart';

class ActionButtonsRow extends StatefulWidget {
  const ActionButtonsRow({super.key});

  @override
  State<ActionButtonsRow> createState() => _ActionButtonsRowState();
}

class _ActionButtonsRowState extends State<ActionButtonsRow> {
  final bool _isFavorite = false;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    // Check the text direction of the current locale
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: !isRTL
            ? [
                // RTL Layout: Reverse the order of buttons
                ActionButton(
                  icon: _isLiked
                      ? "assets/images/svg/like.svg"
                      : "assets/images/svg/like.svg",
                  label: 'like'.tr(context),
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                ),
                ActionButton(
                  icon: _isFavorite
                      ? "assets/images/svg/heart-active.svg"
                      : "assets/images/svg/heart.svg",
                  label: 'favorite'.tr(context),
                  onPressed: () {
                    navigateTo(context, const WishlistScreen());
                  },
                ),
                ActionButton(
                  icon: "assets/images/svg/whatsapp.svg",
                  label: 'contact'.tr(context),
                  onPressed: () {
                    // Open contact options
                  },
                ),
                ActionButton(
                  icon: "assets/images/svg/chat.svg",
                  label: 'message'.tr(context),
                  onPressed: () {
                    // Open messaging
                  },
                ),
              ]
            : [
                // LTR Layout: Original order of buttons
                ActionButton(
                  icon: "assets/images/svg/chat.svg",
                  label: 'message'.tr(context),
                  onPressed: () {
                    // Open messaging
                  },
                ),
                ActionButton(
                  icon: "assets/images/svg/whatsapp.svg",
                  label: 'contact'.tr(context),
                  onPressed: () {
                    // Open contact options
                  },
                ),
                ActionButton(
                  icon: _isFavorite
                      ? "assets/images/svg/heart-active.svg"
                      : "assets/images/svg/heart.svg",
                  label: 'favorite'.tr(context),
                  onPressed: () {
                    navigateTo(context, const WishlistScreen());
                  },
                ),
                ActionButton(
                  icon: "assets/images/svg/like.svg",
                  label: 'like'.tr(context),
                  onPressed: () {
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
