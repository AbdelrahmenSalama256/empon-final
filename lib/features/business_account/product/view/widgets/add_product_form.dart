import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/widgets/image_upload_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_basic_info_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_details_section.dart';
import 'package:embone/features/business_account/product/view/widgets/product_submit_buttons.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductForm extends StatefulWidget {
  final bool? isUpdate;
  ProductModel? productData;

  AddProductForm({super.key, this.isUpdate, this.productData});
  


  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  @override
  void initState() {
    context.read<ProductCubit>().getAttributes().whenComplete(() {
      context.read<ProductCubit>().getCategories();
    });
    super.initState();
  }
  
  final _formKey = GlobalKey<FormState>();

  final accountId =
      int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));

  @override
  Widget build(BuildContext context) {
    return  BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
        showToast(context,
          message: state.product.message!, state: ToastStates.success);
        Navigator.pop(context);
        }
        
        if (state is ProductError) {
        showToast(context,
          message: state.error, state: ToastStates.error);
        }
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
                isUpdate: widget.isUpdate!,
              ),
            ],
          ),
        ),
      
    );
  }
}
