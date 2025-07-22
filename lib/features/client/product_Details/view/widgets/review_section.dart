import 'package:embone/core/component/widgets/comment_input.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_item.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsSection extends StatefulWidget {
  final List<CommentModel> reviews;
  final TextEditingController commentController;
  final bool? isVendor;
  final int productId;
  final SearchCubit cubit;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.commentController,
    this.isVendor,
    required this.productId,
    required this.cubit,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  int? _expandedCommentIndex;
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addCommentOrReply() {
    if (widget.commentController.text.isNotEmpty) {
      if (widget.cubit.replyParentId != null) {
        widget.cubit.addReply(
          productId: widget.productId,
          parentId: widget.cubit.replyParentId!,
          comment: widget.commentController.text,
        );
      } else {
        widget.cubit.addComment(productId: widget.productId);
      }
      FocusScope.of(context).unfocus(); // Hide keyboard
    }
  }

  Future<void> _handleCommentTap(int index, CommentModel comment) async {
    setState(() {
      _expandedCommentIndex = _expandedCommentIndex == index ? null : index;
    });

    if (_expandedCommentIndex == index &&
        (comment.replies == null || comment.replies!.isEmpty)) {
      await widget.cubit.fetchChildComments(parentId: comment.commentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
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
                widget.cubit.currentParentId == comment.commentId,
            onTap: () => _handleCommentTap(index, comment),
            onReply: () {
              // No action needed here; handled in CommentContent
            },
            productId: widget.productId,
            commentFocusNode: _commentFocusNode,
          );
        }),
        if (widget.isVendor != true)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CommentInput(
              controller: widget.commentController,
              onSubmit: _addCommentOrReply,
              isLoading: widget.cubit.state is CommentLoading,
              focusNode: _commentFocusNode,
            ),
          ),
      ],
    );
  }
}
