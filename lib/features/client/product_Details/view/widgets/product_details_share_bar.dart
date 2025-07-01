// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:embone/core/component/fav_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InteractionBar extends StatefulWidget {
  final bool isVendor;
  final int likeCount;
  final int commentCount;
  final bool isLoved;
  final bool isThumbsUp;
  final int isActive;
  final List<String> avatarUrls;
  final Function()? onShare;
  final Function()? onLike;
  final Function()? onComment;
  final Function()? onThumbsUp;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function(bool)? onAvailabilityChanged;
  final Function()? onActive;
  final IconData shareIcon;
  final IconData likeIcon;
  final IconData likedIcon;
  final IconData commentIcon;
  final IconData thumbsUpIcon;
  final IconData thumbsUpSelectedIcon;
  final IconData vendorThumbsUpIcon;
  final IconData vendorCommentIcon;
  final IconData editIcon;
  final IconData deleteIcon;
  final Color likeColor;
  final Color? thumbsUpColor;
  final Color? vendorThumbsUpColor;
  final Color? vendorCommentColor;
  final Color? editButtonColor;
  final Color? deleteButtonColor;
  final Color? editButtonBorderColor;
  final Color? deleteButtonBorderColor;
  final Color? toggleActiveColor;
  final TextStyle? availableTextStyle;
  final TextStyle? likeCountTextStyle;
  final TextStyle? commentCountTextStyle;
  final EdgeInsets? padding;
  // New visibility parameters
  final bool showShare;
  final bool showLike;
  final bool showComment;
  final bool showThumbsUp;
  final bool showEdit;
  final bool showDelete;
  final bool showAvailabilityToggle;

  const InteractionBar({
    super.key,
    this.isVendor = false,
    required this.likeCount,
    required this.commentCount,
    required this.isLoved,
    required this.isThumbsUp,
    required this.isActive,
    this.avatarUrls = const [],
    this.onShare,
    this.onLike,
    this.onComment,
    this.onThumbsUp,
    this.onEdit,
    this.onDelete,
    this.onAvailabilityChanged,
    this.onActive,
    this.shareIcon = Icons.share_outlined,
    this.likeIcon = Icons.favorite_border,
    this.likedIcon = CupertinoIcons.heart,
    this.commentIcon = CupertinoIcons.chat_bubble,
    this.thumbsUpIcon = CupertinoIcons.hand_thumbsup,
    this.thumbsUpSelectedIcon = CupertinoIcons.hand_thumbsup_fill,
    this.vendorThumbsUpIcon = CupertinoIcons.hand_thumbsup,
    this.vendorCommentIcon = CupertinoIcons.chat_bubble,
    this.editIcon = CupertinoIcons.pencil,
    this.deleteIcon = Icons.delete,
    this.likeColor = Colors.red,
    this.thumbsUpColor,
    this.vendorThumbsUpColor = Colors.black,
    this.vendorCommentColor = Colors.black,
    this.editButtonColor = Colors.white,
    this.deleteButtonColor = const Color(0xffEC4B4B),
    this.editButtonBorderColor = const Color(0xffE6E6E6),
    this.deleteButtonBorderColor = const Color(0xffE6E6E6),
    this.toggleActiveColor = AppColors.primary,
    this.availableTextStyle,
    this.likeCountTextStyle,
    this.commentCountTextStyle,
    this.padding,
    this.showShare = true,
    this.showLike = true,
    this.showComment = true,
    this.showThumbsUp = true,
    this.showEdit = true,
    this.showDelete = true,
    this.showAvailabilityToggle = true,
  });

  @override
  State<InteractionBar> createState() => _InteractionBarState();
}

class _InteractionBarState extends State<InteractionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isThumbsUp = false;
  bool _isSharePressed = false;
  bool _isCommentPressed = false;
  bool _isEditPressed = false;
  bool _isDeletePressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _isThumbsUp = widget.isThumbsUp;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateIcon(int index) {
    setState(() {
      switch (index) {
        case 0: // Share
          _isSharePressed = true;
          break;
        case 2: // Comment
          _isCommentPressed = true;
          break;
        case 3: // Thumbs up
          _isThumbsUp = !_isThumbsUp;
          break;
        case 4: // Edit
          _isEditPressed = true;
          break;
        case 5: // Delete
          _isDeletePressed = true;
          break;
      }
    });
    _controller.forward().then((_) {
      setState(() {
        _isSharePressed = false;
        _isCommentPressed = false;
        _isEditPressed = false;
        _isDeletePressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVendor
        ? VendorInteractionView(
            likeCount: widget.likeCount,
            commentCount: widget.commentCount,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
            onAvailabilityChanged: widget.onAvailabilityChanged,
            vendorThumbsUpIcon: widget.vendorThumbsUpIcon,
            vendorCommentIcon: widget.vendorCommentIcon,
            editIcon: widget.editIcon,
            deleteIcon: widget.deleteIcon,
            vendorThumbsUpColor: widget.vendorThumbsUpColor,
            vendorCommentColor: widget.vendorCommentColor,
            editButtonColor: widget.editButtonColor,
            deleteButtonColor: widget.deleteButtonColor,
            editButtonBorderColor: widget.editButtonBorderColor,
            deleteButtonBorderColor: widget.deleteButtonBorderColor,
            toggleActiveColor: widget.toggleActiveColor,
            availableTextStyle: widget.availableTextStyle,
            likeCountTextStyle: widget.likeCountTextStyle,
            commentCountTextStyle: widget.commentCountTextStyle,
            padding: widget.padding,
            isActive: widget.isActive,
            onActive: widget.onActive,
            animateIcon: _animateIcon,
            controller: _controller,
            scaleAnimation: _scaleAnimation,
            isEditPressed: _isEditPressed,
            isDeletePressed: _isDeletePressed,
            showEdit: widget.showEdit,
            showDelete: widget.showDelete,
            showAvailabilityToggle: widget.showAvailabilityToggle,
          )
        : NonVendorInteractionView(
            likeCount: widget.likeCount,
            commentCount: widget.commentCount,
            avatarUrls: widget.avatarUrls,
            onShare: widget.onShare,
            onLike: widget.onLike,
            onComment: widget.onComment,
            onThumbsUp: widget.onThumbsUp,
            shareIcon: widget.shareIcon,
            likeIcon: widget.likeIcon,
            likedIcon: widget.likedIcon,
            commentIcon: widget.commentIcon,
            thumbsUpIcon: widget.thumbsUpIcon,
            thumbsUpSelectedIcon: widget.thumbsUpSelectedIcon,
            likeColor: widget.likeColor,
            thumbsUpColor:
                widget.thumbsUpColor ?? Theme.of(context).primaryColor,
            isLoved: widget.isLoved,
            isThumbsUp: _isThumbsUp,
            animateIcon: _animateIcon,
            controller: _controller,
            scaleAnimation: _scaleAnimation,
            isSharePressed: _isSharePressed,
            isCommentPressed: _isCommentPressed,
            likeCountTextStyle: widget.likeCountTextStyle,
            commentCountTextStyle: widget.commentCountTextStyle,
            padding: widget.padding,
            showShare: widget.showShare,
            showLike: widget.showLike,
            showComment: widget.showComment,
            showThumbsUp: widget.showThumbsUp,
          );
  }
}

class VendorInteractionView extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final Function()? onEdit;
  final Function()? onDelete;
  final Function(bool)? onAvailabilityChanged;
  final IconData vendorThumbsUpIcon;
  final IconData vendorCommentIcon;
  final IconData editIcon;
  final IconData deleteIcon;
  final Color? vendorThumbsUpColor;
  final Color? vendorCommentColor;
  final Color? editButtonColor;
  final Color? deleteButtonColor;
  final Color? editButtonBorderColor;
  final Color? deleteButtonBorderColor;
  final Color? toggleActiveColor;
  final TextStyle? availableTextStyle;
  final TextStyle? likeCountTextStyle;
  final TextStyle? commentCountTextStyle;
  final EdgeInsets? padding;
  final int isActive;
  final Function()? onActive;
  final Function(int)? animateIcon;
  final AnimationController? controller;
  final Animation<double>? scaleAnimation;
  final bool isEditPressed;
  final bool isDeletePressed;
  final bool showEdit;
  final bool showDelete;
  final bool showAvailabilityToggle;

  const VendorInteractionView({
    super.key,
    required this.likeCount,
    required this.commentCount,
    this.onEdit,
    this.onDelete,
    this.onAvailabilityChanged,
    this.vendorThumbsUpIcon = CupertinoIcons.hand_thumbsup,
    this.vendorCommentIcon = CupertinoIcons.chat_bubble,
    this.editIcon = CupertinoIcons.pencil,
    this.deleteIcon = Icons.delete,
    this.vendorThumbsUpColor = Colors.black,
    this.vendorCommentColor = Colors.black,
    this.editButtonColor = Colors.white,
    this.deleteButtonColor = const Color(0xffEC4B4B),
    this.editButtonBorderColor = const Color(0xffE6E6E6),
    this.deleteButtonBorderColor = const Color(0xffE6E6E6),
    this.toggleActiveColor = AppColors.primary,
    this.availableTextStyle,
    this.likeCountTextStyle,
    this.commentCountTextStyle,
    this.padding,
    required this.isActive,
    this.onActive,
    this.animateIcon,
    this.controller,
    this.scaleAnimation,
    this.isEditPressed = false,
    this.isDeletePressed = false,
    this.showEdit = true,
    this.showDelete = true,
    this.showAvailabilityToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Availability toggle
              if (showAvailabilityToggle)
                Row(
                  children: [
                    Text(
                      'available'.tr(context),
                      style: availableTextStyle ??
                          TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(width: 8.w),
                    CupertinoSwitch(
                      value: isActive == 1,
                      onChanged: (value) {
                        if (onActive != null) {
                          onActive!();
                        }
                        if (onAvailabilityChanged != null) {
                          onAvailabilityChanged!(value);
                        }
                      },
                      activeTrackColor: toggleActiveColor,
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showEdit && onEdit != null)
                    GestureDetector(
                      onTap: () {
                        if (animateIcon != null) animateIcon!(4);
                        onEdit!();
                      },
                      child: AnimatedBuilder(
                        animation: controller!,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isEditPressed ? scaleAnimation!.value : 1.0,
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: editButtonColor,
                                border: Border.all(
                                    color: editButtonBorderColor!,
                                    width: 1.5.w),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                editIcon,
                                color: Colors.black,
                                size: 20.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (showEdit &&
                      onEdit != null &&
                      showDelete &&
                      onDelete != null)
                    SizedBox(width: 12.w),
                  if (showDelete && onDelete != null)
                    GestureDetector(
                      onTap: () {
                        if (animateIcon != null) animateIcon!(5);
                        onDelete!();
                      },
                      child: AnimatedBuilder(
                        animation: controller!,
                        builder: (context, child) {
                          return Transform.scale(
                            scale:
                                isDeletePressed ? scaleAnimation!.value : 1.0,
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                color: deleteButtonColor,
                                border: Border.all(
                                    color: deleteButtonBorderColor!,
                                    width: 1.5.w),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Image.asset(
                                "assets/images/trash.png",
                                width: 16.w,
                                height: 16.h,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),

          SizedBox(height: 17.h),

          // Comments and Likes count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Likes count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${'likes_count_label'.tr(context)} $likeCount',
                        style: likeCountTextStyle ??
                            TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xffA0A0A0),
                            ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(vendorThumbsUpIcon,
                          size: 30.sp, color: vendorThumbsUpColor),
                    ],
                  ),
                  SizedBox(width: 15.w),
                  // Comments count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${'comments_count_label'.tr(context)} $commentCount',
                        style: commentCountTextStyle ??
                            TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xffA0A0A0),
                            ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(vendorCommentIcon,
                          size: 30.sp, color: vendorCommentColor),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NonVendorInteractionView extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final List<String> avatarUrls;
  final Function()? onShare;
  final VoidCallback? onLike;
  final Function()? onComment;
  final Function()? onThumbsUp;
  final IconData shareIcon;
  final IconData likeIcon;
  final IconData likedIcon;
  final IconData commentIcon;
  final IconData thumbsUpIcon;
  final IconData thumbsUpSelectedIcon;
  final Color likeColor;
  final Color thumbsUpColor;
  final bool isLoved;
  final bool isThumbsUp;
  final Function(int) animateIcon;
  final AnimationController controller;
  final Animation<double> scaleAnimation;
  final bool isSharePressed;
  final bool isCommentPressed;
  final TextStyle? likeCountTextStyle;
  final TextStyle? commentCountTextStyle;
  final EdgeInsets? padding;
  final bool showShare;
  final bool showLike;
  final bool showComment;
  final bool showThumbsUp;

  const NonVendorInteractionView({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.avatarUrls,
    this.onShare,
    this.onLike,
    this.onComment,
    this.onThumbsUp,
    required this.shareIcon,
    required this.likeIcon,
    required this.likedIcon,
    required this.commentIcon,
    required this.thumbsUpIcon,
    required this.thumbsUpSelectedIcon,
    required this.likeColor,
    required this.thumbsUpColor,
    required this.isLoved,
    required this.isThumbsUp,
    required this.animateIcon,
    required this.controller,
    required this.scaleAnimation,
    this.isSharePressed = false,
    this.isCommentPressed = false,
    this.likeCountTextStyle,
    this.commentCountTextStyle,
    this.padding,
    this.showShare = true,
    this.showLike = true,
    this.showComment = true,
    this.showThumbsUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Column(
      children: [
        // Interaction icons and counts
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Counts (left in LTR, right in RTL)
              if (!isRTL)
                Row(
                  children: [
                    Text(
                      '$likeCount ${'likes'.tr(context)}',
                      style: likeCountTextStyle ??
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$commentCount ${'comments'.tr(context)}',
                      style: commentCountTextStyle ??
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                  ],
                ),

              // Icons (right in LTR, left in RTL)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showShare)
                    _buildAnimatedIcon(
                      icon: shareIcon,
                      onTap: () {
                        animateIcon(0);
                        if (onShare != null) onShare!();
                      },
                      index: 0,
                      isPressed: isSharePressed,
                    ),
                  if (showShare && (showLike || showComment || showThumbsUp))
                    const SizedBox(width: 24),
                  if (showLike)
                    FavoriteButton(
                      isFavorited: isLoved,
                      onFavoriteToggle: onLike ?? () {},
                    ),
                  if (showLike && (showComment || showThumbsUp))
                    const SizedBox(width: 24),
                  if (showComment)
                    _buildAnimatedIcon(
                      icon: commentIcon,
                      onTap: () {
                        animateIcon(2);
                        if (onComment != null) onComment!();
                      },
                      index: 2,
                      isPressed: isCommentPressed,
                    ),
                  if (showComment && showThumbsUp) const SizedBox(width: 24),
                  if (showThumbsUp)
                    _buildAnimatedIcon(
                      icon: isThumbsUp ? thumbsUpSelectedIcon : thumbsUpIcon,
                      onTap: () {
                        animateIcon(3);
                        if (onThumbsUp != null) onThumbsUp!();
                      },
                      index: 3,
                      color: isThumbsUp ? thumbsUpColor : null,
                      isPressed: isThumbsUp,
                    ),
                ],
              ),

              // Counts (right in LTR, left in RTL)
              if (isRTL)
                Row(
                  children: [
                    Text(
                      '$commentCount ${'comments'.tr(context)}',
                      style: commentCountTextStyle ??
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$likeCount ${'likes'.tr(context)}',
                      style: likeCountTextStyle ??
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Avatar row with staggered animation
        if (avatarUrls.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment:
                  isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                for (int i = 0; i < avatarUrls.length; i++)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 300 + (i * 100)),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: isRTL ? 0 : 8.0,
                        left: isRTL ? 8.0 : 0,
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(avatarUrls[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedIcon({
    required IconData icon,
    required Function() onTap,
    required int index,
    Color? color,
    bool isPressed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: isPressed && controller.status == AnimationStatus.forward
                ? scaleAnimation.value
                : 1.0,
            child: Icon(icon, size: 24, color: color ?? Colors.black54),
          );
        },
      ),
    );
  }
}
