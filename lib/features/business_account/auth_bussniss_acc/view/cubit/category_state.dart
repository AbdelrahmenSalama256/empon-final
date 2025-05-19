import '../../data/model/category_model.dart';

class CategoryState {}

final class CategoryInitial extends CategoryState {}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;

   CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoryState {
  final String message;

   CategoriesError(this.message);
}
