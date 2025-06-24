import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/widgets/image_upload_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_basic_info_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_details_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_submit_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final accountId =
      int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
      create: (context) => ProductCubit(sl<ProductRepo>())..getCategories(),
      child:  Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic product information
          const ProductBasicInfoSection(),

          // Image upload sections
          const ImageUploadSection(cubit: true),

          // Product details
          const ProductDetailsSection(),

          // Promotion section
         // const ProductPromotionSection(),

          // Submit buttons
          ProductSubmitButtons(formKey: _formKey, accountId: accountId),
        ],
      ),
    ),
   );
  }
}
