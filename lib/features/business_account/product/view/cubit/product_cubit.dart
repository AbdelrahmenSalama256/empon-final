import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/product/data/model/product_model.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;
  ProductCubit(this.productRepo) : super(ProductInitial());

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController = TextEditingController();

  XFile? productImage;
  List<XFile> productImages = [];

  int? productCategoryId;
  int isSale = 0;
  int? priceVariations;
  int? stockVariation;
  int? attributeValueId;
  List<String>? colorId; // Only single color for now (your repo takes a single int)

  Future<void> addProduct(int accountId) async {
    emit(ProductLoading());
    final result = await productRepo.addProduct(
      accountId,
      productNameController.text.trim(),
      productDescriptionController.text.trim(),
      productPriceController.text.trim(),
      productCategoryId ?? 0,
      isSale,
      productImage!,
      productImages,
      priceVariations ?? 0,
      stockVariation ?? 0,
      attributeValueId ?? 0,
      colorId ?? [],
    );

    result.fold(
      (failure) => emit(ProductError(failure)),
      (productModel) => emit(ProductSuccess(productModel)),
    );
  }

  void pickMainImage(XFile image) {
    productImage = image;
    emit(ProductImagePicked());
  }

  void pickMultipleImages(List<XFile> images) {
    productImages = images;
    emit(ProductImagesPicked());
  }

  void clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    productImage = null;
    productImages.clear();
    productCategoryId = null;
    isSale = 0;
    priceVariations = null;
    stockVariation = null;
    attributeValueId = null;
    colorId = null;
    emit(ProductInitial());
  }
}
