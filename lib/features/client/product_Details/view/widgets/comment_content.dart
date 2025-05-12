import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CommentContent extends StatelessWidget {
  final CommentModel data;
  final int index; // Added index
  final VoidCallback onTap;
  final bool showTrash;
  final VoidCallback? onReply;
  final int productId;
  final SearchCubit cubit;

  const CommentContent({
    super.key,
    required this.cubit,
    required this.data,
    required this.index, // Added index
    required this.onTap,
    this.showTrash = false,
    this.onReply,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final commentId = data.commentId;

    return GestureDetector(
      onTap: onTap,
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
                  backgroundImage: (data.userImage ?? '').startsWith('http')
                      ? NetworkImage(data.userImage!) as ImageProvider
                      : const AssetImage('assets/images/default_avatar.png'),
                ),
                SizedBox(width: 10.w),
                Text(
                  data.userName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  data.time,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffB4BBC6),
                  ),
                ),
                const Spacer(),
                if (showTrash && commentId != 0)
                  GestureDetector(
                    onTap: () {
                      cubit.deleteComment(commentId: commentId);
                    },
                    child: Container(
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
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              data.comment,
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
                      data.likesCount.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff8991A0),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: commentId != 0 && onReply != null ? onReply : null,
                  child: Row(
                    children: [
                      Text(
                        'reply'.tr(context), // Fixed typo: replay -> reply
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: commentId != 0
                              ? const Color(0xff8991A0)
                              : Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        'assets/images/svg/corner-up-right.svg',
                        width: 16.w,
                        height: 16.h,
                        colorFilter: commentId != 0
                            ? null
                            : const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: commentId != 0
                      ? () => cubit.toggleLike(
                            commentId: commentId,
                          )
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Icon(
                      data.isLiked
                          ? CupertinoIcons.hand_thumbsup_fill
                          : CupertinoIcons.hand_thumbsup,
                      size: 20.w,
                      color:
                          commentId != 0 ? Colors.grey : Colors.grey.shade400,
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
