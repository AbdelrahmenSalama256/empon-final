import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsToggle extends StatefulWidget {
  const NotificationsToggle({super.key});

  @override
  State<NotificationsToggle> createState() => _NotificationsToggleState();
}

class _NotificationsToggleState extends State<NotificationsToggle>
    with TickerProviderStateMixin {
  late AnimationController _switchController;
  late AnimationController _iconController;
  late AnimationController _textController;

  late Animation<double> _switchAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<Color?> _iconColorAnimation;
  late Animation<double> _textOpacityAnimation;

  bool _isAnimating = false;
  bool _systemNotificationsEnabled = true;
  bool _checkingPermission = false;

  @override
  void initState() {
    super.initState();

    _initControllers();
    _checkNotificationPermission();
  }

  void _initControllers() {
    // Switch animation controller
    _switchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Icon animation controller
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Switch scale animation
    _switchAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _switchController,
      curve: Curves.easeInOut,
    ));

    // Icon scale animation
    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    // Icon color animation
    _iconColorAnimation = ColorTween(
      begin: Colors.black,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkNotificationPermission() async {
    setState(() => _checkingPermission = true);

    // Check if notifications are enabled at system level
    final status = await Permission.notification.status;
    _systemNotificationsEnabled = status.isGranted;

    setState(() => _checkingPermission = false);
  }

  Future<void> _requestNotificationPermission() async {
    setState(() => _checkingPermission = true);

    final status = await Permission.notification.request();
    _systemNotificationsEnabled = status.isGranted;

    setState(() => _checkingPermission = false);

    if (!_systemNotificationsEnabled) {
      // Optionally show a dialog explaining how to enable notifications in settings
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("notifications_permission_required".tr(context)),
        content: Text("enable_notifications_in_settings".tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text("open_settings".tr(context)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToggle(GlobalCubit cubit, bool newValue) async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);

    // Start animations
    _switchController.forward();
    _iconController.forward();
    _textController.forward();

    // Call the toggle function
    await cubit.toggleNotifications(!newValue);

    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 100));

    // Reverse animations
    await Future.wait([
      _switchController.reverse(),
      _iconController.reverse(),
      _textController.reverse(),
    ]);

    setState(() => _isAnimating = false);
  }

  @override
  void dispose() {
    _switchController.dispose();
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
      return _buildLoadingIndicator();
    }

    if (!_systemNotificationsEnabled) {
      return _buildPermissionRequestButton();
    }

    return _buildNotificationToggle();
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRequestButton() {
    return InkWell(
      onTap: _requestNotificationPermission,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.primary.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/svg/notification.svg",
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primary,
                ),
                SizedBox(width: 12.w),
                Text(
                  "enable_notifications".tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.w,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        final isEnabled = !cubit.isNotificationsDisabled;
        final isLoading = state is LoadingState || _isAnimating;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isLoading ? 8.w : 0,
            vertical: isLoading ? 4.h : 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: isLoading
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Animated Icon
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _iconScaleAnimation,
                      _iconColorAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(isLoading ? 4.w : 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLoading
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: SvgPicture.asset(
                            "assets/images/svg/notification.svg",
                            width: 24.w,
                            height: 24.h,
                            color: isLoading
                                ? AppColors.primary
                                : _iconColorAnimation.value ?? Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),

                  // Animated Text
                  AnimatedBuilder(
                    animation: _textOpacityAnimation,
                    builder: (context, child) {
                      return AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              isLoading ? FontWeight.w600 : FontWeight.w500,
                          color: Colors.black.withOpacity(
                            isLoading ? 0.8 : _textOpacityAnimation.value,
                          ),
                        ),
                        child: Text(
                          "notifications".tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                context.read<GlobalCubit>().language == "ar"
                                    ? "Beiruti"
                                    : "Poppins",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Animated Switch with Loading Indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  // Loading indicator
                  if (isLoading)
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),

                  // Animated Switch
                  AnimatedBuilder(
                    animation: _switchAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _switchAnimation.value,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLoading ? 0.3 : 1.0,
                          child: CupertinoSwitch(
                            value: isEnabled,
                            onChanged: isLoading
                                ? null
                                : (value) => _handleToggle(cubit, value),
                            activeTrackColor: AppColors.primary,
                            trackColor: Colors.grey.withOpacity(0.3),
                            thumbColor:
                                isLoading ? Colors.grey.withOpacity(0.5) : null,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
