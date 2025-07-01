import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/business_account/product/data/model/attributes_model.dart';
import 'package:embone/features/business_account/product/data/model/product_category_model.dart';
import 'package:embone/features/business_account/product/view/widgets/color_picker_dialog.dart';
import 'package:embone/features/business_account/product/data/model/product_model.dart'
    as business;
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart'
    as client;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/common/logs.dart';

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
  final int maxImages = 10;
  business.AddProductModel? productModel;
  XFile? productImage;
  List<XFile> productImages = [];
  List<business.Product>? products;
  business.Data? product;
  List<Category> categories = [];
  List<AttributeValue> attributes = [];
  int? selectedCategoryId;
  int? selectedattrebuteId;
  int isSale = 0;
  int? priceVariations;
  int? stockVariation;
  int? attributeValueId;
  String? color;
  final ImagePicker _picker = ImagePicker();
    final List<Color> colorOptions = [
    const Color(0xFF0D47A1),
    Colors.black,
    const Color(0xFFFFC107),
    const Color(0xFFE53935),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFF9C27B0),
    Colors.white,
  ];
  int selectedColorIndex = 0;
  Color customColor = Colors.blue;

  initControllers(
    bool isUpdate, {
    String? name,
    String? description,
    String? price,
    String? category,
    List<client.Variation>? variation,
    List<client.Detail>? details,
  }) async {
    
    await getCategories();
    await getAttributes();
    if (isUpdate) {
      emit(ProductLoading());
      productNameController.text = name!;
      productDescriptionController.text = description!;
      productPriceController.text = price!;
      
      selectedCategoryId = categories.firstWhere(
        (e) => e.name == category,
      ).id;
      if (variation != null && variation.isNotEmpty) {
        for (int i = 0; i < variation.length; i++) {
          if (variations.length <= i) {
        addVariation();
          }
          variations[i]['color_code'] = variation[i].color?.code;
          variations[i]['attribute_value_id'] = variation[i].attributeValue?.id;
          variations[i]['price'].text = variation[i].price;
          variations[i]['stock'].text = variation[i].stock.toString();
        }
      }

      if (details != null && details.isNotEmpty) {
        for (int i = 0; i < details.length; i++) {
          if (serviceDetailsControllers.length <= i) {
        addParoductDetail();
          }
          serviceDetailsControllers[i]['quality']?.text = details[i].quality ?? '';
          serviceDetailsControllers[i]['material']?.text = details[i].material ?? '';
        }
      }

      Print.success("message");
      emit(ProductInitial());
    }
  }

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
      "attribute_value_id": null,
      "price": TextEditingController(),
      "stock": TextEditingController(),
    });
    emit(ProductInitial());
  }

  void removeVariation(int index) {
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
              "attribute_value_id": v['attribute_value_id']?? 0,
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
        product = model.data;
        emit(ProductLoaded(product!));
      },
    );
  }

  // void pickMainImage(XFile image) {
  //   productImage = image;
  //   emit(ProductImagePicked());
  // }

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
        if (products != null) {
          products!.removeWhere((product) => product.id == id);
          emit(ProductDeleted());
          emit(ProductLoaded(product!));
        } else {
          emit(ProductError('No products to delete.'));
        }
      },
    );
  }
Future<void> updateProduct(
    int productId, int accountId ) async {
        emit(ProductLoading());
    final formattedVariations = variations
        .map((v) => {
              "color_code": v['color_code'] ?? '',
              "attribute_value_id": v['attribute_value_id'] ?? '',
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
    emit(ProductLoading());
PrintUtil.success(productImage);

    final result = await productRepo.updateProduct(
      productId,
      accountId:accountId ,
      name: productNameController.text,
      description: productDescriptionController.text,
      productImage:productImage,
      productImages:productImages,
      price: productPriceController.text,
      categoryId: selectedCategoryId ?? 0,
      isSale: isSale,
      variations: formattedVariations,
      serviceDetails: formatedDetails,
    );

    result.fold(
      (error) => emit(ProductError(error)),
      (model) => emit(UpdateProductSuccess(model)),
    );
  }

  Future<void> getAttributes() async {
    emit(AttributesLoading());
    final result = await productRepo.getAttributes();
    result.fold(
      (error) {
        emit(AttributesError(error));
      },
      (data) {
        attributes = data.data[0].values;
        emit(AttributesLoaded(attributes));
      },
    );
  }
  AttributeValue? findAttributeById(int? id) {
    if (id == null) return null;
    try {
      return attributes.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
  Future<void> pickMainImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
        productImage = XFile(image.path);
        emit(ProductInitial());
    }
  }
    Future<void> pickAdditionalImages() async {
    final availableSlots = maxImages - productImages.length;
    if (availableSlots <= 0) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
        productImages.addAll(images.take(availableSlots));
        emit(ProductInitial());
        PrintUtil.success(productImages);
      
    }
  }
    void removeMainImage() {
      productImage = null;
      emit(ProductInitial());
  
  }

   removeAdditionalImage(int index) {
      productImages.removeAt(index);
      emit(ProductInitial());
  }

    String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
    showCustomColorPicker(BuildContext context, int index) {
    showColorPickerDialog(
      context,
      initialColor: customColor,
      onColorChanged: (Color color) {
        customColor = color;
      },
      onSavePressed: () {
        colorOptions.add(customColor);
        selectedColorIndex = colorOptions.length - 1;
        variations[index]['color_code'] =
            colorToHexString(customColor);
        emit(ProductInitial());
      },
    );
  }
}
