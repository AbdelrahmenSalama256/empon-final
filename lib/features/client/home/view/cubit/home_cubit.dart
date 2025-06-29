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
  List<ServiceModel> services = [];

  // Pagination for products
  int productsCurrentPage = 1;
  int productsLimit = 10;
  bool productsHasMore = true;
  bool productsIsLoadingMore = false;
  HomeModel? homeModel;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  void init() async {
    await fetchHomeData();
    await fetchServices();
  }

  Future<void> fetchHomeData({bool loadMore = false}) async {
    if (isClosed) return;

    if (loadMore && !productsHasMore) {
      return;
    }

    if (loadMore) {
      productsIsLoadingMore = true;
      emit(HomeLoadingMore());
      productsCurrentPage++;
    } else {
      emit(HomeLoading());
      productsCurrentPage = 1;
      homeModel = null; // Reset homeModel for fresh load
    }

    Print.info("Starting to fetch home data, page: $productsCurrentPage");

    final response = await homeRepo.getHomeData(
        page: productsCurrentPage, limit: productsLimit);
    response.fold(
      (error) {
        Print.error("Failed to fetch home data: $error");
        emit(HomeError(message: error));
      },
      (r) {
        if (loadMore) {
          homeModel?.accounts.addAll(r.accounts);
        } else {
          homeModel = r;
        }
        productsHasMore = r.accounts.length == productsLimit;
        productsIsLoadingMore = false;
        Print.info(
            "Fetched ${homeModel?.accounts.length ?? 0} accounts successfully");
        emit(HomeSuccess());
      },
    );
  }

  Future<void> fetchServices({bool loadMore = false}) async {
    if (isClosed) return;

    if (loadMore && !servicesHasMore) {
      return;
    }

    if (loadMore) {
      servicesIsLoadingMore = true;
      emit(HomeLoadingMore());
      servicesCurrentPage++;
    } else {
      emit(HomeLoading());
      servicesCurrentPage = 1;
      services = [];
    }

    Print.info("Starting to fetch services, page: $servicesCurrentPage");

    final response = await homeRepo.getServices(
        limit: servicesLimit, page: servicesCurrentPage);

    response.fold(
      (error) {
        Print.error("Failed to fetch services: $error");
        emit(HomeError(message: error));
      },
      (r) {
        services.addAll(r);
        servicesHasMore = r.length == servicesLimit;
        servicesIsLoadingMore = false;
        Print.info("Fetched ${services.length} services successfully");
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

  // Load more methods
  void loadMoreProducts() {
    fetchHomeData(loadMore: true);
  }

  void loadMoreServices() {
    fetchServices(loadMore: true);
  }
}
