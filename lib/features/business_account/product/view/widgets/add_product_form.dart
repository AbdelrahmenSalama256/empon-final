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

class AddProductForm extends StatefulWidget {
  final bool? isUpdate;
  ProductModel? productData;

  AddProductForm({super.key, this.isUpdate, this.productData});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  final accountId =
      int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));

//   @override
//   void initState() {
//     super.initState();

//  WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.isUpdate!) {
//         final cubit = context.read<ProductCubit>();
//         final data = widget.productData?.data;

//         if (data == null) return;
//         PrintUtil.success(data.description);
//         cubit.productNameController = TextEditingController(text:data.name ?? "hi");
//         cubit.productDescriptionController.text = data.description ?? "";
//         cubit.productPriceController.text = data.price ?? "";

//         cubit.variations.clear(); // Clear default
//         for (var variation in data.variations ?? []) {
//           cubit.variations.add({
//             "color_code": null,
//             "attribute_value_id": TextEditingController(
//                 text: variation.attributeValueId.toString()),
//             "price": TextEditingController(text: variation.price.toString()),
//             "stock": TextEditingController(text: variation.stock.toString()),
//           });
//         }

//         cubit.serviceDetailsControllers.clear(); // Clear default
//         // for (var detail in data.details ?? []) {
//         //   cubit.serviceDetailsControllers.add({
//         //     "quality": TextEditingController(text: detail.quality ?? ''),
//         //     "material": TextEditingController(text: detail.material ?? ''),
//         //   });
//         // }

//         if (cubit.variations.isEmpty) cubit.addVariation();
//         if (cubit.serviceDetailsControllers.isEmpty) cubit.addParoductDetail();

//       }
//     });

//   }

  @override
  Widget build(BuildContext context) {
    final data = widget.productData?.data;
    return BlocProvider(
      create: (context) => ProductCubit(sl<ProductRepo>())..getCategories(),
        // ..initControllers(widget.isUpdate ?? false,
        //     name: data!.name,
        //     description: data.description,
        //     price: data.price,
        //     variation: data.variations,
        //     category: data.category),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic product information
            const ProductBasicInfoSection(),

            // Image upload sections
             ImageUploadSection(cubit: true,imageUrl: data!.image),

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
