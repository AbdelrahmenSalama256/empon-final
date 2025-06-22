import 'package:embone/features/business_account/product/view/widgets/image_upload_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_basic_info_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_details_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_promotion_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_submit_buttons.dart';
import 'package:flutter/material.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic product information
          const ProductBasicInfoSection(),

          // Image upload sections
          const ImageUploadSection(),

          // Product details
          const ProductDetailsSection(),

          // Promotion section
          const ProductPromotionSection(),

          // Submit buttons
          ProductSubmitButtons(formKey: _formKey),
        ],
      ),
    );
  }
}
