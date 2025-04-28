import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;
  final String? badge;
  final String? actionText;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onActionTap;
  final VoidCallback? onCardTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.badge,
    this.actionText,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onActionTap,
    this.onCardTap,
  });

  @override
  State<ProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isFavorite = false;

  // Animation for the favorite button
  late AnimationController _favoriteController;
  late Animation<double> _favoriteScaleAnimation;

  // Animation for the add to cart button
  late AnimationController _cartController;
  late Animation<double> _cartScaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;

    // Main card animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Favorite button animations
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _favoriteScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _favoriteController,
        curve: Curves.easeInOut,
      ),
    );

    // Add to cart button animations
    _cartController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _cartScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _cartController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _favoriteController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    setState(() {});
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() {});
  }

  void _onTapCancel() {
    _controller.reverse();
    setState(() {});
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      _favoriteController.forward().then((_) => _favoriteController.reverse());
    }
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
    }
  }

  void _onCartTap() {
    _cartController.forward().then((_) => _cartController.reverse());
    if (widget.onActionTap != null) {
      widget.onActionTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onCardTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: 280.w,
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                // ignore: deprecated_member_use
                width: 0.5.w,
                // ignore: deprecated_member_use
                color: const Color(0xff000000).withOpacity(0.33)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product image with favorite button
              Stack(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40.w,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
                  PositionedDirectional(
                    top: 20.h,
                    start: 15.w,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: ScaleTransition(
                        scale: _favoriteScaleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 29.w,
                          height: 29.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: SvgPicture.asset(
                                _isFavorite
                                    ? "assets/images/svg/heart-active.svg"
                                    : "assets/images/svg/heart.svg",
                                width: _isFavorite ? 24.w : 20.w,
                                height: _isFavorite ? 24.h : 20.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //! Product details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title (start)
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                        // Price (end)
                        Text(
                          '${widget.price.toStringAsFixed(2)} ${"currency".tr(context)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          //
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    //! Badge and action button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.badge != null)
                          Text(
                            "${widget.badge}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            //
                          ),
                        if (widget.actionText != null)
                          GestureDetector(
                            onTap: _onCartTap,
                            child: ScaleTransition(
                              scale: _cartScaleAnimation,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffDFE0E5),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'shop_now'.tr(context),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
