import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';

class CommentRepo {
  final ApiConsumer api;

  CommentRepo(this.api);
  Future<Either<String, CommentResponseModel>> fetchParentComments({
    required int productId,
    int page = 1,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.commentParent}/$productId/$page',
      );

      return Right(CommentResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, CommentResponseModel>> fetchChildComments({
    required int parentId,
    int page = 1,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.commentChild}/$parentId/$page',
      );

      return Right(CommentResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, CommentResponseModel>> addComment({
    required int productId,
    required String comment,
    int? parentId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.comment,
        data: {
          'product_id': productId,
          'comment': comment,
          if (parentId != null) 'parent_id': parentId,
        },
        isFormData: true,
      );

      return Right(CommentResponseModel.fromJson({
        'success': response.data['success'],
        'message': response.data['message'],
        'data': {
          'comments': [response.data['data']]
        },
        'current_page': 1,
        'last_page': 1,
        'total': 1,
      }));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, CommentResponseModel>> updateComment({
    required int commentId,
    required String comment,
  }) async {
    try {
        await api.put(
        '${EndPoints.comment}/$commentId',
        data: {
          'comment': comment,
          'method': 'PUT',
        },
        isFormData: true,
      );

      return Right(CommentResponseModel.fromJson({}));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> deleteComment({
    required int commentId,
  }) async {
    try {
      await api.delete(
        '${EndPoints.comment}/$commentId',
      );
      return const Right('Comment deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> toggleLike({
    required int commentId,
  }) async {
    try {
      await api.post(
        EndPoints.commentLike,
        data: {'comment_id': commentId},
        isFormData: true,
      );

      return const Right('Comment deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
