import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:embone/core/constants/app_colors.dart';

class SupportButton extends StatefulWidget {
  final VoidCallback onTap;

  const SupportButton({super.key, required this.onTap});

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true); // 🔄 تأثير نبض مستمر

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      isClicked = true;
    });
    _controller.stop(); // ❌ إيقاف النبض عند الضغط

    Future.delayed(const Duration(milliseconds: 200), () {
      widget.onTap();
      setState(() {
        isClicked = false;
      });
      _controller.repeat(reverse: true); // 🔄 إعادة تشغيل الأنيميشن
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: _onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isClicked ? Colors.green : AppColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: const Icon(
              CupertinoIcons.conversation_bubble,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
