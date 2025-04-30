import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/finding_accounts.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingAccountPage extends StatefulWidget {
  const SearchingAccountPage({super.key});

  @override
  State<SearchingAccountPage> createState() => _SearchingAccountPageState();
}

class _SearchingAccountPageState extends State<SearchingAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchingEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchingEmailController.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindingAccountsPage(
              phoneNumber: _searchingEmailController.text,
              firstName: _searchingEmailController.text,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'search_account'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: isRTL
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 16.h),
                          Center(
                            child: Image.asset(
                              'assets/images/name.png',
                              width: 326.w,
                              height: 244.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 32.h.h),
                          QuestionWidget(
                            question: 'search_for_accounts'.tr(context),
                            subtitle: 'search_account_description'.tr(context),
                          ),
                          SizedBox(height: 32.h.h),
                          AppTextField(
                            controller: _searchingEmailController,
                            labelText: 'phone_or_email'.tr(context),
                            hintText: 'enter_phone_or_email'.tr(context),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.phone_android,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.w,
                            ),
                            validator: (value) =>
                                Validators.validateEmail(value, context),
                          ),
                          SizedBox(height: 32.h.h),
                          AppButton(
                            text: 'search'.tr(context),
                            isLoading: _isLoading,
                            onPressed: _search,
                            height: 50.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
