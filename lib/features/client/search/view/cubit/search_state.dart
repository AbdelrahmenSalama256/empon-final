import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';

class SearchState {}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}

class SearchHistoryLoading extends SearchState {}

class SearchHistorySuccess extends SearchState {}

class SearchHistoryError extends SearchState {
  final String message;

  SearchHistoryError({required this.message});
}

class DeleteSearchHistoryLoading extends SearchState {}

class DeleteSearchHistorySuccess extends SearchState {}

class DeleteSearchHistoryError extends SearchState {
  final String message;

  DeleteSearchHistoryError({required this.message});
}

class GoToProductLoading extends SearchState {}

class GoToProductSuccess extends SearchState {}

class GoToProductError extends SearchState {
  final String message;

  GoToProductError({required this.message});
}

class RecentViewLoading extends SearchState {}

class RecentViewSuccess extends SearchState {}

class RecentViewError extends SearchState {
  final String message;
  RecentViewError({required this.message});
}

class ClearHistoryLoading extends SearchState {}

class ClearHistorySuccess extends SearchState {}

class ClearHistoryError extends SearchState {
  final String message;

  ClearHistoryError({required this.message});
}

class CommentLoading extends SearchState {}

class CommentSuccess extends SearchState {}

class CommentError extends SearchState {
  final String message;

  CommentError({required this.message});
}

class CommentsLoaded extends SearchState {
  final List<CommentModel> comments;

  CommentsLoaded(this.comments);
}

class LikeProductLoading extends SearchState {}

class LikeProductLoaded extends SearchState {
  final ProductModel? productModel;

  LikeProductLoaded(this.productModel);
}

class LikeProductError extends SearchState {
  final String message;

  LikeProductError({required this.message});
}

class LikeServiceLoading extends SearchState {}

class LikeServiceError extends SearchState {
  final String message;

  LikeServiceError({required this.message});
}

class LikeServiceLoaded extends SearchState {
  final ServiceModel? serviceModel;

  LikeServiceLoaded(this.serviceModel);
}

// Releated Products states with loading more
class RelatedProductsLoading extends SearchState {}

class RelatedProductsLoaded extends SearchState {}

class RelatedProductsError extends SearchState {
  final String message;

  RelatedProductsError({required this.message});
}

// loading more stats
class LoadingMoreProducts extends SearchState {}

class VariationsLoading extends SearchState {}

class VariationsSuccess extends SearchState {}

class VariationsError extends SearchState {
  final String message;
  VariationsError({required this.message});
}
