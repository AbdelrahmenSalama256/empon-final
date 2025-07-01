import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/business_account/product/data/model/product_category_model.dart';
import 'package:embone/features/business_account/product/data/model/product_model.dart'
    as business;
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;
  ProductCubit(this.productRepo) : super(ProductInitial()) {
    addVariation();
    addParoductDetail();
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();

  business.AddProductModel? productModel;
  XFile? productImage;
  List<XFile> productImages = [];
  List<business.Product> products = [];
  List<Category> categories = [];
  int? selectedCategoryId;
  int isSale = 0;
  int? priceVariations;
  int? stockVariation;
  int? attributeValueId;
  String? color;

  // initControllers(
  //   bool isUpdate, {
  //   String? name,
  //   String? description,
  //   String? price,
  //   String? category,
  //   List<client.Variation>? variation,
  //   String? mainImage
  // }) async {
  //   await getCategories();
  //   if (isUpdate) {
  //     productNameController.text = name!;
  //     productDescriptionController.text = description!;
  //     productPriceController.text = price!;

  //     selectedCategoryId = categories.firstWhere(
  //       (e) => e.name == category,
  //     ).id;
  //     if (variation != null && variation.isNotEmpty) {
  //       for (int i = 0; i < variation.length; i++) {
  //         if (variations.length <= i) {
  //           addVariation();
  //         }
  //         variations[i]['color_code'] = variation[i].color?.code;
  //         variations[i]['attribute_value_id'].text = variation[i].attributeValue?.name;
  //         variations[i]['price'].text = variation[i].price;
  //         variations[i]['stock'].text = variation[i].stock.toString();
  //       }

  //     }

  //     Print.success("message");
  //     emit(ProductInitial());
  //   }
  // }

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
              "color_code": v['color_code'] ?? '',
              "attribute_value_id": v['attribute_value_id']?.text ?? '',
              "price": v['price']?.text ?? '',
              "stock": v['stock']?.text ?? '',
            })
        .toList();
    final formatedDetails = serviceDetailsControllers
        .map((e) => {
              'quality': e['quality']?.text ?? '',
              'material': e['material']?.text ?? ''
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
        formatedDetails);

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
    color = null;
    for (var v in variations) {
      v['attribute_value_id']?.dispose();
      v['price']?.dispose();
      v['stock']?.dispose();
    }
    variations.clear();
    addVariation();
    for (var d in serviceDetailsControllers) {
      d['quality']?.dispose();
      d['material']?.dispose();
    }
    serviceDetailsControllers.clear();
    addParoductDetail();

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

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    final result = await productRepo.deleteProduct(id);
    result.fold(
      (error) => emit(ProductError(error)),
      (_) {
        products.removeWhere((product) => product.id == id);
        emit(ProductDeleted());
        emit(ProductLoaded(products));
      },
    );
  }
}
