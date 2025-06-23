
import 'package:embone/features/business_account/product/data/model/service_category_model.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';

class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final ServiceModel model;
  ServiceSuccess(this.model);
}

class ServiceError extends ServiceState {
  final String error;
  ServiceError(this.error);
}

class ServiceImagePicked extends ServiceState {}

class ServiceCategoriesLoaded extends ServiceState {
  final List<ServiceCategoryData> categories;
  ServiceCategoriesLoaded(this.categories);
}

class ServiceLoaded extends ServiceState {
  final List<Service> services;

  ServiceLoaded(this.services);
}
