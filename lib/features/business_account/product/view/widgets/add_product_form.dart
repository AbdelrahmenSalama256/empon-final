import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/widgets/image_upload_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_basic_info_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_details_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_submit_buttons.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductForm extends StatelessWidget {
  final bool? isUpdate;
  ProductModel? productData;

  AddProductForm({super.key, this.isUpdate, this.productData});

  final _formKey = GlobalKey<FormState>();

  final accountId =
      int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProductCubit(sl<ProductRepo>());
        cubit.getAttributes().whenComplete(() => cubit.getCategories());
        return cubit;
      },
      child: Form(
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
            ProductSubmitButtons(
              formKey: _formKey,
              accountId: accountId,
              isUpdate: isUpdate!,
            ),
          ],
        ),
      ),
    );
  }
}
