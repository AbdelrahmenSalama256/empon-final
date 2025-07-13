import 'package:cached_network_image/cached_network_image.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/home/data/model/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final VoidCallback? onBrandTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300.h, // Fixed height to constrain the card
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            Expanded(
              child: _buildDetailsSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: CachedNetworkImage(
              imageUrl: "${service.mainImage}", // Handle null image
              width: double.infinity,
              // height: 160.h,
              fit: BoxFit.cover,

              placeholder: (context, url) => Image.asset(
                'assets/images/placholder.jpg',
                fit: BoxFit.contain,
              ),
              errorWidget: (context, url, error) => Center(
                child: Image.asset(
                  'assets/images/placholder.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 12.h,
            start: 12.w,
            child: GestureDetector(
              onTap: onBrandTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "${service.account?.logo}",
                    width: 45.w,
                    height: 45.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/placholder.jpg',
                      fit: BoxFit.contain,
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Image.asset(
                        'assets/images/placholder.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                service.category?.name.toUpperCase() ?? "",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                service.account?.name ?? "unknown".tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            service.name ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${double.tryParse(service.price ?? "")?.toStringAsFixed(2) ?? service.price} ${"currency".tr(context)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppButton(
                  height: 40.h,
                  onPressed: () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
                  text: 'book_now'.tr(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
