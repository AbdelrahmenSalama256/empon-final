part of 'service_cubit.dart';

abstract class ServiceState {}

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

