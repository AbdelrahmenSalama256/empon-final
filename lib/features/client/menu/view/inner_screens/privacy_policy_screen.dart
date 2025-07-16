import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/data/repo/faq_repo.dart';
import 'package:embone/features/client/menu/data/repo/privacy_policy_repo.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_state.dart';
import 'package:embone/features/client/menu/view/cubit/privacy_policy_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/privacy_policy_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      if (!_showScrollToTop) {
        setState(() {
          _showScrollToTop = true;
        });
      }
    } else {
      if (_showScrollToTop) {
        setState(() {
          _showScrollToTop = false;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivacyPolicyCubit(sl<PrivacyPolicyRepo>())..init(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
            builder: (context, state) {
              final privacyPolicyCubit = context.read<PrivacyPolicyCubit>();
              return BlocProvider(
                create: (context) =>
                    FaqsCubit(sl.call<FaqRepo>())..fetchContactInfo(),
                child: BlocBuilder<FaqsCubit, FaqsState>(
                  builder: (context, faqState) {
                    final faqcubit = context.read<FaqsCubit>();
                    return Column(
                      children: [
                        AppHeader(
                          title: 'privacy_policy'.tr(context),
                          showBackButton: true,
                          centerTitle: true,
                          style: HeaderStyle.standard,
                        ),
                        state is PrivacyPolicyLoading
                            ? const Expanded(
                                child: Center(
                                  child: CustomLoadingIndicator(),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildIntroductionCard(),
                                      SizedBox(height: 16.h),
                                      if (state is PrivacyPolicyLoaded)
                                        // // _buildLastUpdatedCard(privacyPolicyCubit
                                        // //     .privacyPolicy!.lastUpdated),
                                        // SizedBox(height: 16.h),
                                        ..._buildPrivacyPolicySections(
                                            privacyPolicyCubit
                                                    .privacyPolicy?.content ??
                                                'Loading...'),
                                      SizedBox(height: 24.h),
                                      _buildContactCard(faqcubit),
                                      SizedBox(height: 100.h),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: _showScrollToTop
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 24.w,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildIntroductionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.security,
                  color: AppColors.primary,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'privacy_protection'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'privacy_intro'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedCard(String lastUpdated) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.update,
            color: AppColors.primary,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Text(
            'last_updated'.tr(context),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            lastUpdated,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPrivacyPolicySections(String content) {
    return [
      _buildPolicySection(
        title: 'full_policy'.tr(context),
        content: content,
        icon: Icons.description,
      ),
    ];
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(FaqsCubit faqcubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.contact_support,
                  color: AppColors.primary,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'contact_us'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'privacy_contact_info'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          _buildContactItem(
              Icons.email, faqcubit.contactInfo?.contactEmail ?? ''),
          SizedBox(height: 8.h),
          _buildContactItem(
              Icons.phone, faqcubit.contactInfo?.whatsappNumber ?? ''),
          // SizedBox(height: 8.h),
          // _buildContactItem(
          //     Icons.location_on, '123 Privacy Street, Data City, DC 12345'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.w,
          color: AppColors.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
