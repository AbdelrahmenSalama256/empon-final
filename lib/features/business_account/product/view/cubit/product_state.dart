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
class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}


class CategoryLoading extends ProductState {}

class CategoryLoaded extends ProductState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}

class CategorySelected extends ProductState {
  final int selectedId;
  CategorySelected(this.selectedId);
}

class CategoryError extends ProductState {
  final String message;
  CategoryError(this.message);
}

