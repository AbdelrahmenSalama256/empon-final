import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/wishlist_model.dart';
import 'package:embone/features/client/menu/data/repo/wishlist_repo.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo wishlistRepo;
  FavoritesResponseModel? wishlistData;

  WishlistCubit(this.wishlistRepo) : super(WishlistInitial());

  Future<void> fetchFavorites() async {
    emit(WishlistsLoading());
    final response = await wishlistRepo.fetchFavorites();
    Print.info(response);

    response.fold(
      (l) {
        Print.error(l);
        emit(WishlistsError(l));
      },
      (r) {
        wishlistData = r;
        Print.info(wishlistData);
        Print.success('Wishlist data fetched successfully');
        emit(const WishlistsSuccess());
      },
    );
  }
}
