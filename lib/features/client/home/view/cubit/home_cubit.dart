import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/home/data/model/home_model.dart';
import 'package:embone/features/client/home/data/model/service_model.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  // Pagination for services
  int servicesCurrentPage = 1;
  int servicesLimit = 10;
  bool servicesHasMore = true;
  bool servicesIsLoadingMore = false;

  // Pagination for products
  int productsCurrentPage = 1;
  int productsLimit = 10;
  bool productsHasMore = true;
  bool productsIsLoadingMore = false;
  List<ServiceModel> services = [];
  HomeModel? homeModel;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  void init() async {
    await fetchHomeData();
    await fetchServices();
  }

  Future<void> fetchHomeData({bool loadMore = false}) async {
    if (productsIsLoadingMore) return;

    if (loadMore) {
      productsIsLoadingMore = true;
      emit(HomeLoadingMore());
      productsCurrentPage++;
    } else {
      emit(HomeLoading());
      productsCurrentPage = 1;
      productsHasMore = true;
    }

    final response = await homeRepo.getHomeData(
        page: productsCurrentPage, limit: productsLimit);
    response.fold(
      (l) => emit(HomeError(message: l)),
      (r) {
        if (loadMore) {
          // Merge new products with existing ones
          homeModel?.accounts.addAll(r.accounts);
        } else {
          homeModel = r;
        }
        productsHasMore = (r.accounts.length) == productsLimit;
        productsIsLoadingMore = false;
        emit(HomeSuccess());
      },
    );
  }

  Future<void> fetchServices({bool loadMore = false}) async {
    if (servicesIsLoadingMore || !servicesHasMore) return;

    if (loadMore) {
      servicesIsLoadingMore = true;
      emit(HomeLoadingMore());
      servicesCurrentPage++;
    } else {
      servicesCurrentPage = 1;
      services = [];
      servicesHasMore = true;
    }

    final response = await homeRepo.getServices(
        limit: servicesLimit, page: servicesCurrentPage);

    response.fold(
      (l) => emit(HomeError(message: l)),
      (r) {
        services.addAll(r);
        servicesHasMore = r.length == servicesLimit;
        servicesIsLoadingMore = false;
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
          isActive: account.isActive,
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

  // Method to load more services
  void loadMoreServices() {
    fetchServices();
  }
}
