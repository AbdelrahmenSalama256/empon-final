import 'package:embone/core/component/widgets/comment_input.dart';
import 'package:embone/core/locale/app_loacl.dart';
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
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addCommentOrReply() {
    if (widget.commentController.text.isNotEmpty) {
      if (widget.cubit.replyParentId != null) {
        widget.cubit.serviceaddReply(
          serviceId: widget.serviceId,
          parentId: widget.cubit.replyParentId!,
          comment: widget.commentController.text,
        );
      } else {
        widget.cubit.serviceAddComment(serviceId: widget.serviceId);
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
                comment.commentId == widget.cubit.servicecurrentParentId,
            onTap: () => _handleCommentTap(index, comment),
            onReply: () {},
            productId: widget.serviceId,
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
