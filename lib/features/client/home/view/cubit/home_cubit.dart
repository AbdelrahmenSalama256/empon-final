import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/home/data/model/home_model.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  HomeModel? homeModel;

  void init() {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    final response = await homeRepo.getHomeData();
    response.fold(
      (l) {
        Print.error(l);
        emit(HomeError(message: l));
      },
      (r) {
        homeModel = r;
        Print.success('Home data fetched successfully');
        emit(HomeSuccess());
      },
    );
  }

  void toggleFavorite(int productId) {
    if (homeModel != null) {
      final updatedAccounts = homeModel!.accounts.map((account) {
        final updatedProducts = account.products.map((product) {
          if (product.id == productId) {
            return Product(
              id: product.id,
              name: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
              isFavourite: !product.isFavourite,
            );
          }
          return product;
        }).toList();
        return Account(
          id: account.id,
          name: account.name,
          image: account.image,
          products: updatedProducts,
        );
      }).toList();

      homeModel = HomeModel(
        success: homeModel!.success,
        message: homeModel!.message,
        ads: homeModel!.ads,
        accounts: updatedAccounts,
      );

      Print.success('Favorite toggled for product $productId');
      emit(HomeSuccess());
    }
  }

  void onActionTap(int productId) {
    Print.success('Action tapped for product $productId');
    emit(HomeActionTapped(productId: productId));
  }
}
