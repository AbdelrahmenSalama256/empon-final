import 'package:embone/core/component/widgets/comment_input.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_item.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceReviewsSection extends StatefulWidget {
  final List<CommentModel> reviews;
  final TextEditingController commentController;
  final bool? isVendor;
  final int serviceId;
  final SearchCubit cubit;

  const ServiceReviewsSection({
    super.key,
    required this.reviews,
    required this.commentController,
    this.isVendor,
    required this.serviceId,
    required this.cubit,
  });

  @override
  State<ServiceReviewsSection> createState() => _ServiceReviewsSectionState();
}

class _ServiceReviewsSectionState extends State<ServiceReviewsSection> {
  int? _expandedCommentIndex;
  final Map<int, TextEditingController> _replyControllers = {};

  @override
  void dispose() {
    _replyControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  TextEditingController _getReplyController(int commentId) {
    if (!_replyControllers.containsKey(commentId)) {
      _replyControllers[commentId] = TextEditingController();
    }
    return _replyControllers[commentId]!;
  }

  void _addComment() {
    if (widget.commentController.text.isNotEmpty) {
      widget.cubit.serviceAddComment(serviceId: widget.serviceId);
    }
  }

  Future<void> _handleCommentTap(int index, CommentModel comment) async {
    setState(() {
      _expandedCommentIndex = _expandedCommentIndex == index ? null : index;
    });

    // Only fetch replies if we're expanding and replies aren't already loaded
    if (_expandedCommentIndex == index &&
        (comment.replies == null || comment.replies!.isEmpty)) {
      await widget.cubit.servicefetchChildComments(parentId: comment.commentId);
    }
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
        if (widget.reviews.isEmpty)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'no_comments'.tr(context),
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
        ...widget.reviews.asMap().entries.map((entry) {
          final index = entry.key;
          final comment = entry.value;

          return CommentItem(
            cubit: widget.cubit,
            index: index,
            review: comment,
            isExpanded: _expandedCommentIndex == index,
            isLoadingReplies: widget.cubit.state is CommentLoading &&
                comment.commentId == widget.cubit.currentParentId,
            onTap: () => _handleCommentTap(index, comment),
            onReply: (parentId) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('reply'.tr(context)),
                  content: AppTextField(
                    controller: _getReplyController(parentId),
                    hintText: 'write_reply_here'.tr(context),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel'.tr(context)),
                    ),
                    TextButton(
                      onPressed: () {
                        final replyText = _getReplyController(parentId).text;
                        if (replyText.isNotEmpty) {
                          widget.cubit.serviceaddReply(
                            serviceId: widget.serviceId,
                            parentId: parentId,
                            comment: replyText,
                          );
                          _getReplyController(parentId).clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('send'.tr(context)),
                    ),
                  ],
                ),
              );
            },
            productId: widget.serviceId,
          );
        }),
        if (widget.isVendor != true)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CommentInput(
              controller: widget.commentController,
              onSubmit: _addComment,
            ),
          ),
      ],
    );
  }
}

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
