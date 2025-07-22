import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/comment_content.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyItem extends StatelessWidget {
  final CommentModel reply;
  final SearchCubit cubit;
  final bool isRTL;
  final int productId; // Also used for serviceId
  final int parentId;
  final VoidCallback onReply;
  final FocusNode commentFocusNode;

  const ReplyItem({
    super.key,
    required this.reply,
    required this.cubit,
    required this.isRTL,
    required this.productId,
    required this.parentId,
    required this.onReply,
    required this.commentFocusNode,
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
              showTrash: false,
              onReply: onReply,
              productId: productId,
              commentFocusNode: commentFocusNode,
            ),
          ),
        ],
      ),
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
