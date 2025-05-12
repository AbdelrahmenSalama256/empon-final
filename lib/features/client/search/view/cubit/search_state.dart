part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}

class SearchHistoryLoading extends SearchState {}

class SearchHistorySuccess extends SearchState {}

class SearchHistoryError extends SearchState {
  final String message;

  const SearchHistoryError({required this.message});
}

class DeleteSearchHistoryLoading extends SearchState {}

class DeleteSearchHistorySuccess extends SearchState {}

class DeleteSearchHistoryError extends SearchState {
  final String message;

  const DeleteSearchHistoryError({required this.message});
}

class GoToProductLoading extends SearchState {}

class GoToProductSuccess extends SearchState {}

class GoToProductError extends SearchState {
  final String message;

  const GoToProductError({required this.message});
}

class RecentViewLoading extends SearchState {}

class RecentViewSuccess extends SearchState {}

class RecentViewError extends SearchState {
  final String message;
  const RecentViewError({required this.message});
}

class ClearHistoryLoading extends SearchState {}

class ClearHistorySuccess extends SearchState {}

class ClearHistoryError extends SearchState {
  final String message;

  const ClearHistoryError({required this.message});
}

class CommentLoading extends SearchState {}

class CommentSuccess extends SearchState {}

class CommentError extends SearchState {
  final String message;

  const CommentError({required this.message});
}

class CommentsLoaded extends SearchState {
  final List<CommentModel> comments;

  const CommentsLoaded(this.comments);
}
