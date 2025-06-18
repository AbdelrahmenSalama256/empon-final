part of 'product_cubit.dart';

sealed class ProductState  {
  const ProductState();

}

final class ProductInitial extends ProductState {}
final class ProductLoading extends ProductState {}
final class ProductError extends ProductState {
  final String message;
  const ProductError({required this.message});
  
}
final class ProductSuccess extends ProductState {
  final String message;
  const ProductSuccess(this.message);
 
}

