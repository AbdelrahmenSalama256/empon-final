import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactForm extends StatefulWidget {
  final Function(String)? onSubmit;
  final String title;
  final String subtitle;
  final String hintText;

  const ContactForm({
    super.key,
    this.onSubmit,
    this.title = "contact_us", // Translation key
    this.subtitle = "enter_email_for_updates", // Translation key
    this.hintText = "enter_your_email", // Translation key
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitEmail() {
    if (_emailController.text.isNotEmpty && widget.onSubmit != null) {
      widget.onSubmit!(_emailController.text);
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.title.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 8.h),

        // Divider
        Divider(
          height: 1.h,
          // ignore: deprecated_member_use
          color: const Color(0XFF000000).withOpacity(0.22),
        ),

        SizedBox(height: 16.h),

        // Subtitle
        Text(
          widget.subtitle.tr(context),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xffB5BBCF),
          ),
        ),

        SizedBox(height: 16.h),

        // Email input with submit button
        Row(
          children: [
            // Email input field
            Expanded(
              child: AppTextField(
                controller: _emailController,
                hintText: widget.hintText.tr(context),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                  size: 20.w,
                ),
                suffixIcon: // Submit button
                    IconButton(
                  icon: Icon(
                    isRTL ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.black,
                    size: 20.w,
                  ),
                  onPressed: _submitEmail,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _submitEmail();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
