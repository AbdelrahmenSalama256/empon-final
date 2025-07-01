import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/business_account/product/data/model/service_category_model.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepo repo;

  ServiceCubit(this.repo) : super(ServiceInitial());

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
final int maxImages = 10;
final ImagePicker _picker = ImagePicker();
bool _isPickingImages = false;
  // Inputs
  int? categoryServiceId;
  int? accountId;
  int? serviceId;
  List<ServiceCategoryData> categories = [];
  XFile? mainImage;
  List<XFile> sliderImages = [];
  List<int> selectedCategoryIds = [];
  List<Service> services = [];

  List<TextEditingController> featureControllers = [TextEditingController()];

  void addFeature() {
    featureControllers.add(TextEditingController());
    emit(ServiceInitial());
  }
  Future<void> initControllers(
    bool isUpdate, {
    String? name,
    String? details,
    String? price,
    String? category,
    List<Category>? categoriesData,
    List<String>? features,
  }) async {
    await getServiceCategories();
    if (isUpdate) {
      emit(ServiceLoading());
      nameController.text = name ?? '';
      detailsController.text = details ?? '';
      priceController.text = price ?? '';

      if (category != null && categories.isNotEmpty) {
        categoryServiceId = categories.firstWhere(
          (e) => e.name == category,
          orElse: () => categories.first,
        ).id;
      }

      if (features != null && features.isNotEmpty) {
        featureControllers = [];
        for (var feature in features) {
          featureControllers.add(TextEditingController(text: feature));
        }
      } else {
        featureControllers = [TextEditingController()];
      }

      emit(ServiceInitial());
    }
  }

  void disposeController() {
    for (var controller in featureControllers) {
      controller.dispose();
  }
   emit(ServiceInitial());
  }

  // Setters



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
      about: featureControllers.map((e) => e.text).toList(),
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

Future<void> getServicesByAccountId() async {
    emit(ServiceLoading());

    final result = await repo.fetchServicesByAccountId();

    result.fold(
      (error) => emit(ServiceError(error)),
      (response) {
        services = response.data;
        PrintUtil.info("Fetched services: $services");
        emit(ServiceLoaded(services));
      },
    );
  }

  Future <void> updateService(int id) async{
    emit(ServiceLoading());

    final result = await repo.updateService(
      accountId: accountId,
      name: nameController.text.trim(),
      details: detailsController.text.trim(),
      price: priceController.text.trim(),
      categoryServiceId: categoryServiceId!,
      serviceId: id,
      mainImage: mainImage,
      listImages: sliderImages,
      about: featureControllers.map((e) => e.text).toList(),
    );

    result.fold(
      (error) => emit(ServiceError(error)),
      (model) => emit(ServiceSuccess(model)),
    );
  }
Future<void> deleteService(int id) async {
    emit(
        ServiceLoading());
    final result = await repo.deleteServise(id);
    result.fold(
      (error) => emit(ServiceError(error)),
      (r) {
        emit(Deleted());
      },
    );
  }
    Future<void> pickMainImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      mainImage = XFile(image.path);
      emit(ServiceInitial());
    }
  }
  Future<void> pickAdditionalImages() async {
    if (_isPickingImages) return;
    _isPickingImages = true;
    try {
      final availableSlots = maxImages - sliderImages.length;
      if (availableSlots <= 0) {
        _isPickingImages = false;
        return;
      }

      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        sliderImages.addAll(images.take(availableSlots));
        emit(ServiceInitial());
        PrintUtil.success(sliderImages);
      }
    } finally {
      _isPickingImages = false;
    }
  }
  

  void removeMainImage() {
    mainImage = null;
    emit(ServiceInitial());
  }

  removeAdditionalImage(int index) {
    sliderImages.removeAt(index);
    emit(ServiceInitial());
  }


}
