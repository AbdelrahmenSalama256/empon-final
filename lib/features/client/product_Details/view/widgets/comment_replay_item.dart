import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_content.dart';
import 'package:embone/features/client/product_Details/view/widgets/review_section.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyItem extends StatelessWidget {
  final CommentModel reply;
  final SearchCubit cubit;
  final bool isRTL;
  final TextEditingController replyController;
  final int productId;

  const ReplyItem({
    super.key,
    required this.reply,
    required this.cubit,
    required this.isRTL,
    required this.replyController,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final commentId = reply.commentId;

    if (commentId == 0) {
      return const SizedBox.shrink();
    }

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
              cubit: cubit,
              index: -1,
              data: reply,
              onTap: () {},
              showTrash: true,
              onReply: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('reply'.tr(context)),
                    content: TextField(
                      controller: replyController,
                      decoration: InputDecoration(
                        hintText: 'write_reply_here'.tr(context),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('cancel'.tr(context)),
                      ),
                      TextButton(
                        onPressed: () {
                          if (replyController.text.isNotEmpty) {
                            cubit.addReply(
                              productId: productId,
                              parentId: commentId,
                              comment: replyController.text,
                            );
                            replyController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text('send'.tr(context)),
                      ),
                    ],
                  ),
                );
              },
              productId: productId,
            ),
          ),
        ],
      ),
    );
  }
}
