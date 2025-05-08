part of 'shop_cubit.dart';

sealed class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

final class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopSuccess extends ShopState {}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);
}
