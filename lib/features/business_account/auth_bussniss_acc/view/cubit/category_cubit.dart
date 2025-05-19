import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/category_repo.dart';

import '../../data/model/category_model.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo categoryRepo;
  List<CategoryModel> categories = [];

  CategoryCubit(this.categoryRepo) : super(CategoryInitial());
  // Fetch categories
  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    final response = await categoryRepo.getCategories();
    response.fold(
      (error) {
        Print.error('Failed to fetch categories: $error');
        emit(CategoriesError(error));
      },
      (fetchedCategories) {
        categories = fetchedCategories;
        Print.success(
            'Categories fetched successfully: ${categories.length} categories');
        emit(CategoriesLoaded(categories));
      },
    );
  }
}
