import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;
  ProductCubit(this.productRepo): super(ProductInitial());

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();
  XFile? productImage;
  List<XFile>? productImages;
  int? productCategoryId;
  int? isSale;
  int? priceVariations;
  int? stockVariation;
  int? attributeValueId;
  List<String>? colorId;
  





}
