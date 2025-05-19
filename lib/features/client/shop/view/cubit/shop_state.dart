class ShopState {}

final class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopSuccess extends ShopState {}

class ShopError extends ShopState {
  final String message;

  ShopError(this.message);
}
