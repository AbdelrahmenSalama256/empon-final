part of 'wishlist_cubit.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

class WishlistsLoading extends WishlistState {}

class WishlistsSuccess extends WishlistState {
  const WishlistsSuccess();
}

class WishlistsError extends WishlistState {
  final String message;

  const WishlistsError(this.message);
}
