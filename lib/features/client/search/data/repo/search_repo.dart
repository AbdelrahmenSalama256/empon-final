import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/client/product_Details/data/model/releated_model.dart';
import 'package:embone/features/client/search/data/model/search_history_model.dart';
import 'package:embone/features/client/search/data/model/search_model.dart';
import 'package:embone/features/client/search/data/model/search_recent_view.dart';

import '../../../product_Details/data/model/product_model.dart';

class SearchRepo {
  final ApiConsumer api;

  SearchRepo(this.api);

  Future<Either<String, SearchModel>> searchProducts(String query) async {
    try {
      final response = await api.get(
        EndPoints.search,
        queryParameters: {'name': query},
      );
      final searchModel = SearchModel.fromJson(response.data);
      return Right(searchModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch search results: $e');
    }
  }

  Future<Either<String, SearchHistoryModel>> getSearchHistory() async {
    try {
      final response = await api.get(EndPoints.searchHistory);
      final searchHistoryModel = SearchHistoryModel.fromJson(response.data);
      return Right(searchHistoryModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch search history: $e');
    }
  }

  Future<Either<String, String>> deleteSearchHistory(
      {required final int id}) async {
    try {
      final response = await api.delete("${EndPoints.searchHistory}/$id");
      return Right(response.data['message'] ?? 'Deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch search history: $e');
    }
  }

  Future<Either<String, ProductModel>> goToProduct(
      {required final int id}) async {
    try {
      final response = await api.get("${EndPoints.goToProduct}/$id", data: {
        "type": "product",
      });
      return Right(ProductModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch product: $e');
    }
  }

  Future<Either<String, ServiceModel>> goToService(
      {required final int id}) async {
    try {
      final response = await api.get("${EndPoints.getService}$id");
      return Right(ServiceModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch product: $e');
    }
  }

  Future<Either<String, RecentViewModel>> getRecentView() async {
    try {
      final response = await api.get(EndPoints.recentView);
      final recentViewModel = RecentViewModel.fromJson(response.data);
      return Right(recentViewModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch recent views: $e');
    }
  }

  Future<Either<String, String>> clearHistory() async {
    try {
      final response = await api.delete(EndPoints.clearHistory);
      return Right(response.data['message'] ?? 'Deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch search history: $e');
    }
  }

  Future<Either<String, String>> toggleProductLike({
    required int productId,
  }) async {
    try {
      await api.post(
        EndPoints.productLike,
        data: {'product_id': productId},
        isFormData: true,
      );
      return const Right('Like toggled successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> toggleServiceLike({
    required int serviceId,
  }) async {
    try {
      await api.post(
        EndPoints.serviceLike,
        data: {'service_id': serviceId},
        isFormData: true,
      );
      return const Right('Like toggled successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, RelatedProductsModel>> getReleatedProducts({
    int page = 1,
    int limit = 10,
    required final int id,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.relatedProducts}/$id',
        queryParameters: {'page': page, 'limit': limit},
      );
      return Right(RelatedProductsModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch related products: $e');
    }
  }
}
