import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/product/data/model/service_category_model.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepo repo;

  ServiceCubit(this.repo) : super(ServiceInitial());

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Inputs
  int? categoryServiceId;
  int? accountId;
  List<ServiceCategoryData> categories = [];
  XFile? logoImage;
  XFile? mainImage;
  List<XFile> sliderImages = [];
  List<int> selectedCategoryIds = [];

  // Setters
  void pickLogo(XFile file) {
    logoImage = file;
    emit(ServiceImagePicked());
  }

  void pickMainImage(XFile file) {
    mainImage = file;
    emit(ServiceImagePicked());
  }

  void pickSliderImages(List<XFile> files) {
    sliderImages = files;
    emit(ServiceImagePicked());
  }

  // Action: Create Service
  Future<void> createService() async {
    if (nameController.text.isEmpty ||
        detailsController.text.isEmpty ||
        mainImage == null ||
        priceController.text.isEmpty ||
        sliderImages.isEmpty ||
        categoryServiceId == null ||
        accountId == null) {
      emit(ServiceError("Missing required fields or images"));
      return;
    }

    emit(ServiceLoading());

    final result = await repo.createService(
      name: nameController.text.trim(),
      details: detailsController.text.trim(),
      price: priceController.text.trim(),
      categoryServiceId: categoryServiceId!,
      accountId: accountId!,
      mainImage: mainImage!,
      listImages: sliderImages,
    );

    result.fold(
      (error) => emit(ServiceError(error)),
      (model) => emit(ServiceSuccess(model)),
    );
  }

  void resetForm() {
    nameController.clear();
    detailsController.clear();
    priceController.clear();
    categoryServiceId = null;
    logoImage = null;
    mainImage = null;
    sliderImages.clear();
    emit(ServiceInitial());
  }

  Future<void> getServiceCategories() async {
    emit(
        ServiceLoading()); // Optional: Or you can create a ServiceCategoriesLoading state
    final result = await repo.fetchServiceCategories();
    result.fold(
      (error) => emit(ServiceError(error)),
      (categoryModel) {
        categories = categoryModel.data;
        emit(ServiceCategoriesLoaded(categories));
      },
    );
  }




}
