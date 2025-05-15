// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;

  const CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoryState {
  final String message;

  const CategoriesError(this.message);
}
