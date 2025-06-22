import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final GlobalKey _logoKey = GlobalKey();

  Offset? _logoPosition;
  Size? _logoSize;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureLogoPosition();
    });
  }

  void _captureLogoPosition() {
    final RenderBox? renderBox =
        _logoKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _logoPosition = renderBox.localToGlobal(Offset.zero);
      _logoSize = renderBox.size;
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Check token and navigate after the animation completes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final String? token =
            sl<CacheHelper>().getData(key: AppConstants.token);
        Print.info("Token: $token");

        Widget destination;
        if (token != null && token.isNotEmpty) {
          destination = const BaseScreen(); // Logged in
        } else {
          destination = const IntroPage(); // Not logged in
        }

        Navigator.of(context)
            .pushReplacement(_createLogoAnimationRoute(destination));
      }
    });
  }

  Route _createLogoAnimationRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final double value = animation.value;

        return Stack(
          children: [
            Opacity(opacity: value, child: child),
            if (_logoPosition != null && value < 0.99)
              Positioned(
                left: _logoPosition!.dx,
                top: _logoPosition!.dy - (value * 150),
                child: Opacity(
                  opacity: 1.0 - value,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: _logoSize?.height,
                    width: _logoSize?.width,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    key: _logoKey,
                    height: 118.h,
                    width: 78.w,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
