import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';

import '../model/category_model.dart';

class CategoryRepo {
  final ApiConsumer api;

  CategoryRepo(this.api);

  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final response = await api.get(EndPoints.category);
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      final categories =
          data.map((json) => CategoryModel.fromJson(json)).toList();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch categories: $e');
    }
  }
}
