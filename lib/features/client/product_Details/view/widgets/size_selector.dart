import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final List<String> unavailableSizes;
  final String? selectedSize;
  final Function(String) onSizeSelected;
  final String title;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.unavailableSizes = const [],
    this.selectedSize,
    required this.onSizeSelected,
    required this.title,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.selectedSize;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SizeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSize != widget.selectedSize) {
      setState(() {
        _selectedSize = widget.selectedSize;
      });
    }
  }

  void _selectSize(String size) {
    if (widget.unavailableSizes.contains(size)) return;

    setState(() {
      _selectedSize = size;
    });

    _controller.forward();
    widget.onSizeSelected(size);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),

        // Size options
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = widget.sizes.length - 1; i >= 0; i--)
              _buildSizeOption(widget.sizes[i]),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    final isUnavailable = widget.unavailableSizes.contains(size);
    final isSelected = _selectedSize == size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale:
                isSelected && _controller.status == AnimationStatus.forward
                    ? _scaleAnimation.value
                    : 1.0,
            child: child,
          );
        },
        child: InkWell(
          onTap: isUnavailable ? null : () => _selectSize(size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade200 : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isUnavailable ? Colors.grey.shade400 : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
