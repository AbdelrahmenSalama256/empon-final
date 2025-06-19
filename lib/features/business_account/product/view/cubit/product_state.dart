part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final ProductModel product;
  ProductSuccess(this.product);
}

class ProductError extends ProductState {
  final String error;
  ProductError(this.error);
}

class ProductImagePicked extends ProductState {}

class ProductImagesPicked extends ProductState {}
