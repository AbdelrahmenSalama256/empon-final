import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsSection({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Divider(height: 1.h, color: Colors.grey.shade300),

        // Reviews header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // View all button
              Text(
                'عرض الكل',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),

              // Title
              Text(
                'التقييمات',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),

        // Review items
        ...reviews.map((review) => ReviewItem(
              name: review['name'],
              avatar: review['avatar'],
              rating: review['rating'],
              comment: review['comment'],
              date: review['date'],
            )),

        // Divider
        Divider(height: 1.h, color: Colors.grey.shade300),
      ],
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;

  const ReviewItem({
    Key? key,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // User info and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Date
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              // Rating stars
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 16.w,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // User name
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(width: 8.w),

              // Avatar
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 20.w,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Comment
          Text(
            comment,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.end,
          ),

          SizedBox(height: 8.h),

          // Like and reply buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Reply button
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.reply,
                  size: 16.w,
                  color: Colors.grey,
                ),
                label: Text(
                  'رد',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Like button
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 16.w,
                  color: Colors.grey,
                ),
                label: Text(
                  'إعجاب',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
