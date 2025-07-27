import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/data/repo/faq_repo.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/faqs_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/customer_support_chat_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/contact_option.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/custom_divider.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/faq_item.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/section_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return BlocProvider(
      create: (context) => FaqsCubit(sl<FaqRepo>())..init(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<FaqsCubit, FaqsState>(
            builder: (context, state) {
              final faqsCubit = context.read<FaqsCubit>();
              return Column(
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
                            if (state is FaqLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (state is FaqError)
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: AppColors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            if (state is FaqLoaded)
                              Column(
                                children: state.faqResponse.data.map((faq) {
                                  return Column(
                                    children: [
                                      FAQItem(
                                        question: faq.question,
                                        answer: faq.answer,
                                        isRTL: isRTL,
                                      ),
                                      const CustomDivider(),
                                    ],
                                  );
                                }).toList(),
                              ),

                            SizedBox(height: 24.h),

                            // Inquiry Section
                            SectionHeader(
                              title: "have_inquiry".tr(context),
                              subtitle: "not_found_in_faq".tr(context),
                              isRTL: isRTL,
                            ),

                            // Contact Options
                            ContactOption(
                              title: "whatsapp".tr(context),
                              subtitle: faqsCubit.contactInfo?.whatsappNumber ??
                                  "N/A",
                              icon: CupertinoIcons.phone,
                              iconColor: const Color(0xff1E2644),
                              onTap: () => _launchUrl(
                                  'https://wa.me/+2${faqsCubit.contactInfo?.whatsappNumber ?? ''}'),
                              isRTL: isRTL,
                            ),
                            const CustomDivider(),
                            ContactOption(
                              title: "email".tr(context),
                              subtitle:
                                  faqsCubit.contactInfo?.contactEmail ?? "N/A",
                              icon: CupertinoIcons.envelope,
                              iconColor: const Color(0xff1E2644),
                              onTap: () => _launchUrl(
                                  'mailto:${faqsCubit.contactInfo?.contactEmail ?? ''}'),
                              isRTL: isRTL,
                            ),
                            const CustomDivider(),
                            ContactOption(
                              title: "via_in_app_chat".tr(context),
                              subtitle: "customer_support".tr(context),
                              icon: CupertinoIcons.chat_bubble,
                              iconColor: const Color(0xff1E2644),
                              onTap: () {
                                navigateWithoutNav(
                                    context, const CustomerSupportChatScreen());
                              },
                              isRTL: isRTL,
                            ),
                            SizedBox(height: 16.h),
                            Center(
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      navigateWithoutNav(context,
                                          const CustomerSupportChatScreen());
                                      // navigateTo(context,
                                      //     const CustomerSupportChatScreen());
                                    },
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
              );
            },
          ),
        ),
      ),
    );
  }
}
