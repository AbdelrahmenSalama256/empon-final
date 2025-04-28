// help_support_page.dart
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/contact_option.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/custom_divider.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/faq_item.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/section_header.dart'
    show SectionHeader;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "help_support".tr(context),
              showBackButton: true,
              centerTitle: true,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FAQ Section
                      SectionHeader(
                        isRTL: isRTL,
                        title: "frequently_asked_questions".tr(context),
                      ),

                      FAQItem(
                        question: "login_required_question".tr(context),
                        answer: "login_required_answer".tr(context),
                        isRTL: isRTL,
                      ),

                      const CustomDivider(),

                      FAQItem(
                        question: "another_question".tr(context),
                        answer: "another_answer".tr(context),
                        isRTL: isRTL,
                      ),

                      const CustomDivider(),

                      FAQItem(
                        question: "more_questions".tr(context),
                        answer: "more_answers".tr(context),
                        isRTL: isRTL,
                      ),

                      const CustomDivider(),

                      SizedBox(height: 24.h),

                      // Inquiry Section
                      SectionHeader(
                        title: "have_inquiry".tr(context),
                        subtitle: "not_found_in_faq".tr(context),
                        isRTL: isRTL,
                      ),

                      // Contact Options
                      ContactOption(
                        title: "via_whatsapp".tr(context),
                        subtitle: "00201228745120",
                        icon: CupertinoIcons.phone,
                        iconColor: const Color(0xff1E2644),
                        onTap: () => _launchUrl('https://wa.me/00201228745120'),
                        isRTL: isRTL,
                      ),

                      const CustomDivider(),

                      ContactOption(
                        title: "via_email".tr(context),
                        subtitle: "Empon.eg@gmail.com",
                        icon: CupertinoIcons.envelope,
                        iconColor: const Color(0xff1E2644),
                        onTap: () => _launchUrl('mailto:Empon.eg@gmail.com'),
                        isRTL: isRTL,
                      ),

                      const CustomDivider(),

                      ContactOption(
                        title: "via_in_app_chat".tr(context),
                        subtitle: "",
                        icon: CupertinoIcons.chat_bubble,
                        iconColor: const Color(0xff1E2644),
                        onTap: () {},
                        isRTL: isRTL,
                      ),

                      SizedBox(height: 16.h),

                      // Login to chat button
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "login_to_chat".tr(context),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
