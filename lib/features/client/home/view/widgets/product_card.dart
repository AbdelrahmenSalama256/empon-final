import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double? originalPrice;
  final String? badge;
  final String? actionText;
  final bool isFavorite;
  final int? discountPercentage;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onActionTap;
  final VoidCallback? onCardTap;
  final bool isOffer; // New parameter to determine layout

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.badge,
    this.actionText,
    this.isFavorite = false,
    this.discountPercentage,
    this.onFavoriteToggle,
    this.onActionTap,
    this.onCardTap,
    this.isOffer = false, // Default to regular layout
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
              width: 0.5.w,
              color: const Color(0xff000000).withOpacity(0.33),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product image with favorite button and conditional offer badge
              SizedBox(
                height: 225.h,
                child: Stack(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: widget.imageUrl.startsWith('http')
                          ? Image.network(
                              widget.imageUrl,
                              height: 225.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImageErrorWidget(),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              widget.imageUrl,
                              height: 225.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImageErrorWidget(),
                            ),
                    ),

                    // Conditional Offer Badge (Top Right) - Only for offers
                    if (widget.isOffer && widget.discountPercentage != null)
                      PositionedDirectional(
                        top: 12.h,
                        end: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '-${widget.discountPercentage}%',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Favorite button - Different styles for offer vs regular
                    widget.isOffer
                        ? _buildOfferFavoriteButton()
                        : _buildRegularFavoriteButton(),
                  ],
                ),
              ),

              // Product details - Different layouts for offer vs regular
              Expanded(
                child: widget.isOffer
                    ? _buildOfferDetails()
                    : _buildRegularDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Offer layout favorite button (enhanced with shadow)
  Widget _buildOfferFavoriteButton() {
    return PositionedDirectional(
      top: 12.h,
      start: 12.w,
      child: GestureDetector(
        onTap: _toggleFavorite,
        child: ScaleTransition(
          scale: _favoriteScaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_isFavorite),
                  size: 18.w,
                  color: _isFavorite ? Colors.red : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Regular layout favorite button (original style with SVG)
  Widget _buildRegularFavoriteButton() {
    return PositionedDirectional(
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
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
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
    );
  }

  // Offer layout details (enhanced styling)
  Widget _buildOfferDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),

          // Product Title
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          // Price Row with original price
          Row(
            children: [
              Text(
                '${widget.price.toStringAsFixed(2)} ${"currency".tr(context)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (widget.originalPrice != null) ...[
                SizedBox(width: 8.w),
                Text(
                  '${widget.originalPrice!.toStringAsFixed(2)} ${"currency".tr(context)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 8.h),

          // Badge and Action Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.badge != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    widget.badge!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        widget.actionText!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Regular layout details (original simple styling)
  Widget _buildRegularDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${widget.price.toStringAsFixed(2)} ${"currency".tr(context)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.badge != null)
                Text(
                  widget.badge!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
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
                        widget.actionText!,
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
    );
  }

  Widget _buildImageErrorWidget() {
    return Center(
      child: Container(
        color: Colors.grey.shade200,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40.w,
          color: Colors.grey,
        ),
      ),
    );
  }
}
