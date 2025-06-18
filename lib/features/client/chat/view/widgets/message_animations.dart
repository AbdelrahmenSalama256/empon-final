import 'package:flutter/material.dart';

class MessageAnimations {
  final TickerProvider vsync;
  late AnimationController mainController;
  late AnimationController swipeController;
  late AnimationController selectionController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> selectionAnimation;

  MessageAnimations(this.vsync);

  void initialize() {
    mainController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    swipeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );

    selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );

    scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: mainController,
        curve: Curves.easeOutQuint,
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainController,
        curve: Curves.easeOut,
      ),
    );

    selectionAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: selectionController,
        curve: Curves.easeInOut,
      ),
    );

    mainController.forward();
  }

  void dispose() {
    mainController.dispose();
    swipeController.dispose();
    selectionController.dispose();
  }
}
