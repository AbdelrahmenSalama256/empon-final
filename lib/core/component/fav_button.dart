// ignore: file_names
import 'dart:math';

import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;
  final double size;
  final Color iconColor;
  final Duration animationDuration;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onFavoriteToggle,
    this.size = 24.0,
    this.iconColor = Colors.red,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with TickerProviderStateMixin {
  bool isFavorited = false;
  double scale = 1.0;
  bool showHearts = false;
  late AnimationController _heartController;
  late List<Map<String, dynamic>> floatingHearts;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    floatingHearts = [];
  }

  void toggleFavorite() {
    final wasFavorited = isFavorited; // Store the previous state
    setState(() {
      widget.onFavoriteToggle();
      isFavorited = !isFavorited; // Toggle the state
      scale = 1.3; // Scale effect for the icon
    });

    // Trigger the floating hearts effect only when favoriting (false -> true)
    if (!wasFavorited && isFavorited) {
      setState(() {
        showHearts = true;
        generateFloatingHearts();
        _heartController.forward(from: 0);
      });
    }

    // Reset the scale after the animation
    Future.delayed(widget.animationDuration, () {
      if (mounted) {
        // ✅ التحقق من أن الـ Widget لا يزال موجودًا
        setState(() {
          scale = 1.0;
        });
      }
    });

    // Clear the floating hearts after the animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        // ✅ التحقق من أن الـ Widget لا يزال موجودًا
        setState(() {
          floatingHearts.clear();
          showHearts = false;
        });
      }
    });
  }

  void generateFloatingHearts() {
    floatingHearts.clear();
    final random = Random();

    for (int i = 0; i < 6; i++) {
      floatingHearts.add({
        "left": (random.nextDouble() * 40 - 20).toDouble(),
        "size": (random.nextDouble() * 10 + 10).toDouble(),
        "opacity": 1.0,
        "animationController": AnimationController(
          vsync: this,
          duration: Duration(milliseconds: random.nextInt(400) + 600),
        )..forward(),
      });
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    for (var heart in floatingHearts) {
      heart["animationController"].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleFavorite,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TweenAnimationBuilder<double>(
            duration: widget.animationDuration,
            tween: Tween<double>(begin: 1.0, end: scale),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Icon(
                  isFavorited
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: isFavorited ? AppColors.red : Colors.grey,
                  size: widget.size,
                ),
              );
            },
          ),
          if (showHearts)
            ...floatingHearts.map((heart) {
              return AnimatedBuilder(
                animation: heart["animationController"],
                builder: (context, child) {
                  return Positioned(
                    top: -heart["animationController"].value * 50,
                    left: heart["left"],
                    child: Opacity(
                      opacity:
                          1 - (heart["animationController"].value as double),
                      child: Transform.scale(
                        scale: (1 - heart["animationController"].value) * 1.2,
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          // ignore: deprecated_member_use
                          color: widget.iconColor.withOpacity(0.8),
                          size: heart["size"].toDouble(),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }
}
