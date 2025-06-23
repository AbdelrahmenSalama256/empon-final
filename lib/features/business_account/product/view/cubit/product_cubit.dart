import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/business_account/product/data/model/product_category_model.dart';
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
  List<Product> products = [];
 List<Category> categories = [];
  int? selectedCategoryId;
  int isSale = 0;
  int? priceVariations;
  int? stockVariation;
  int? attributeValueId;
  List<String>? colorId; 
  
  List<Map<String, TextEditingController>> serviceDetailsControllers = [];

  void addParoductDetail() {
    serviceDetailsControllers.add({
      'quality': TextEditingController(),
      'material': TextEditingController(),
    });
    emit(ProductInitial());
  }
  void removeParoductDetail() {
    serviceDetailsControllers.last['quality']?.dispose();
    serviceDetailsControllers.last['material']?.dispose();
    serviceDetailsControllers.removeLast();
    emit(ProductInitial());

  }
  List<Map<String, dynamic>> variations = [];

  void addVariation() {
    variations.add({
      "color_code": null, // will be a Color object
      "attribute_value_id": TextEditingController(),
      "price": TextEditingController(),
      "stock": TextEditingController(),
    });
    emit(ProductInitial());
  }

  void removeVariation(int index) {
    variations[index]['attribute_value_id'].dispose();
    variations[index]['price']?.dispose();
    variations[index]['stock']?.dispose();
    variations.removeAt(index);
    emit(ProductInitial());
  }


  Future<void> addProduct(int accountId) async {
    emit(ProductLoading());
      final formattedVariations = variations
        .map((v) => {
              "color_code": v['color_code'] != null
                  ? '#${(v['color_code'] as Color).value.toRadixString(16).padLeft(8, '0').toUpperCase()}'
                  : null,
              "attribute_value_id": v['attribute_value_id']?.text ?? '',
              "price": v['price']?.text ?? '',
              "stock": v['stock']?.text ?? '',
            })
        .toList();
    final result = await productRepo.addProduct(
      accountId,
      productNameController.text.trim(),
      productDescriptionController.text.trim(),
      productPriceController.text.trim(),
      selectedCategoryId ?? 0,
      isSale,
      productImage!,
      productImages,
      formattedVariations,
      serviceDetailsControllers
      
    );

    result.fold(
      (failure) => emit(ProductError(failure)),
      (productModel) => emit(ProductSuccess(productModel)),
    );
  }
    Future<void> getProductsByAccountId(int accountId) async {
    emit(ProductLoading());
    final result = await productRepo.fetchAccountProductsById(accountId);
    result.fold(
      (error) => emit(ProductError(error)),
      (model) {
        products = model.data;
        emit(ProductLoaded(products));
      },
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
    selectedCategoryId = null;
    isSale = 0;
    priceVariations = null;
    stockVariation = null;
    attributeValueId = null;
    colorId = null;
    emit(ProductInitial());
  }


  Future<void> getCategories() async {
    emit(CategoryLoading());
    final result = await productRepo.fetchCategories();
    result.fold(
      (error) {
        emit(CategoryError(error));
      },
      (data) {
        categories = data;
        PrintUtil.info("Categories: $categories");
        emit(CategoryLoaded(categories));
      },
    );
  }

  void selectCategory(int id) {
    selectedCategoryId = id;
    emit(CategorySelected(id));
  }
}

