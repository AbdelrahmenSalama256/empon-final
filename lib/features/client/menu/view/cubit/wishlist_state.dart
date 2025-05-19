class WishlistState {}

final class WishlistInitial extends WishlistState {}

class WishlistsLoading extends WishlistState {}

class WishlistsSuccess extends WishlistState {
  WishlistsSuccess();
}

class WishlistsError extends WishlistState {
  final String message;

  WishlistsError(this.message);
}
