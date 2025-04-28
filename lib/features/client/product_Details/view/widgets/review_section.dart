import 'package:embone/core/component/widgets/comment_input.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Main Reviews Section Widget
class ReviewsSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final Function(String)? onAddComment;
  final bool? isVendor;

  const ReviewsSection({
    super.key,
    required this.reviews,
    this.onAddComment,
    this.isVendor,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final TextEditingController _commentController = TextEditingController();
  int? _expandedCommentIndex;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isVendor != true)
          Divider(height: 1.h, color: Colors.grey.shade300),
        SectionTitle(
          title: 'comments'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),
        ...widget.reviews.asMap().entries.map((entry) => CommentItem(
              review: entry.value,
              isExpanded: _expandedCommentIndex == entry.key,
              onTap: () {
                setState(() {
                  _expandedCommentIndex =
                      _expandedCommentIndex == entry.key ? null : entry.key;
                });
              },
            )),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: CommentInput(onSubmit: widget.onAddComment),
        ),
      ],
    );
  }
}

// Reusable Comment Item Widget
class CommentItem extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isExpanded;
  final VoidCallback onTap;

  const CommentItem({
    super.key,
    required this.review,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final replies = (review['replies'] as List<Map<String, dynamic>>?) ?? [];
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommentContent(
          data: review,
          onTap: onTap,
          showTrash: true,
        ),
        if (replies.isNotEmpty)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Column(
                      children: replies
                          .map((reply) => ReplyItem(
                                reply: reply,
                                isRTL: isRTL,
                              ))
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}

// Reusable Comment Content Widget
class CommentContent extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final bool showTrash;

  const CommentContent({
    super.key,
    required this.data,
    required this.onTap,
    this.showTrash = false,
  });

  @override
  State<CommentContent> createState() => _CommentContentState();
}

class _CommentContentState extends State<CommentContent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: widget.data['avatar'].startsWith('http')
                      ? NetworkImage(widget.data['avatar']) as ImageProvider
                      : AssetImage(widget.data['avatar']),
                ),
                SizedBox(width: 10.w),
                Text(
                  widget.data['name'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  widget.data['date'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffB4BBC6),
                  ),
                ),
                const Spacer(),
                if (widget.showTrash)
                  Container(
                    width: 40.w,
                    height: 40.h,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffEC4B4B),
                      border: Border.all(
                          color: const Color(0xffE6E6E6), width: 1.5.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset(
                      "assets/images/trash.png",
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              widget.data['comment'],
              style: TextStyle(fontSize: 14.sp, color: const Color(0xff272727)),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      'likes'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff8991A0),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.data['likes'].toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff8991A0),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Row(
                  children: [
                    Text(
                      'replay'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8991A0),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      "assets/images/svg/corner-up-right.svg",
                      width: 16.w,
                      height: 16.h,
                    ),
                  ],
                ),
                const Spacer(),
                StatefulBuilder(
                  builder: (context, setState) => InkWell(
                    onTap: () {
                      setState(() {
                        widget.data['isLiked'] =
                            !(widget.data['isLiked'] ?? false);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Icon(
                        (widget.data['isLiked'] ?? false)
                            ? CupertinoIcons.hand_thumbsup_fill
                            : CupertinoIcons.hand_thumbsup,
                        // fill: BoxFit.cover,
                        size: 20.w,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Reply Item Widget
class ReplyItem extends StatelessWidget {
  final Map<String, dynamic> reply;
  final bool isRTL;

  const ReplyItem({
    super.key,
    required this.reply,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16.w,
            child: CustomPaint(
              painter: DashedLineVerticalPainter(isRTL: isRTL),
            ),
          ),
          Expanded(
            child: CommentContent(
              data: reply,
              onTap: () {}, // Empty callback as replies aren't expandable
              showTrash: false,
            ),
          ),
        ],
      ),
    );
  }
}

// Dashed Line Painter (unchanged)
class DashedLineVerticalPainter extends CustomPainter {
  final bool isRTL;

  DashedLineVerticalPainter({required this.isRTL});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3.w
      ..style = PaintingStyle.stroke;

    const dashHeight = 10;
    const dashSpace = 2;
    double startY = 0;
    final xPosition = isRTL ? 0.0 : size.width - 4.w;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(xPosition, startY),
        Offset(xPosition, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
