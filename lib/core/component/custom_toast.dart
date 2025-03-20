import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';

void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
  Duration duration = const Duration(seconds: 3),
}) {
  // Create an overlay entry with animation controllers
  late OverlayEntry toast;

  toast = OverlayEntry(
    builder: (context) => _ToastOverlay(
      message: message,
      state: state,
      duration: duration,
      onDismiss: () {
        toast.remove();
      },
    ),
  );

  Overlay.of(context).insert(toast);
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastStates state;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.state,
    required this.duration,
    required this.onDismiss,
  });

  @override
  _ToastOverlayState createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Slide animation with bounce
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0.1),
        ),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
        ),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();

    // Schedule dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted && !_isDismissing) {
        _dismissToast();
      }
    });
  }

  void _dismissToast() {
    _isDismissing = true;
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          top: 50.h,
          left: 16.w,
          right: 16.w,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _dismissToast();
                  }
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: choosePopUpColor(widget.state),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Optional: Add an app icon or notification icon here
                        // Icon(
                        //   _getIconForState(widget.state),
                        //   color: choosePopUpColor(widget.state),
                        //   size: 24.sp,
                        // ),
                        // if (icon != null) SizedBox(height: 8.h),
                        Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum ToastStates {
  success,
  error,
  warning,
}

Color choosePopUpColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = AppColors.primaryColor;
      break;
    case ToastStates.error:
      color = AppColors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}
