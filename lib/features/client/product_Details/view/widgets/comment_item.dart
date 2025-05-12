import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_content.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_replay_item.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentItem extends StatelessWidget {
  final CommentModel review;
  final bool isExpanded;
  final bool isLoadingReplies;
  final VoidCallback onTap;
  final Function(int) onReply;
  final int productId;
  final SearchCubit cubit;
  final int index;
  const CommentItem({
    super.key,
    required this.index,
    required this.cubit,
    required this.review,
    required this.isExpanded,
    this.isLoadingReplies = false,
    required this.onTap,
    required this.onReply,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final replies = review.replies ?? [];
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommentContent(
          cubit: cubit,
          index: index,
          data: review,
          onTap: onTap,
          showTrash: true,
          onReply: () => onReply(review.commentId),
          productId: productId,
        ),
        if (isLoadingReplies)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
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
                                cubit: cubit,
                                reply: reply,
                                isRTL: isRTL,
                                replyController: TextEditingController(),
                                productId: productId,
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
