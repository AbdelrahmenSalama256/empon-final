import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/search/data/model/search_history_model.dart';
import 'package:embone/features/client/search/data/model/search_model.dart';
import 'package:embone/features/client/search/data/model/search_recent_view.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit(this.searchRepo) : super(SearchInitial());

  SearchModel? searchModel;
  init() {
    fetchSearchHistory();
    getRecentView();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final response = await searchRepo.searchProducts(query);
    response.fold(
      (l) {
        Print.error(l);
        emit(SearchError(message: l));
      },
      (r) {
        searchModel = r;
        Print.success('Search results fetched successfully');
        emit(SearchSuccess());
      },
    );
  }

  void clearSearch() {
    searchModel = null;
    emit(SearchInitial());
  }

  SearchHistoryModel? searchHistoryModel;

  Future<void> fetchSearchHistory() async {
    emit(SearchHistoryLoading());
    final response = await searchRepo.getSearchHistory();
    response.fold(
      (l) {
        Print.error(l);
        emit(SearchHistoryError(message: l));
      },
      (r) {
        searchHistoryModel = r;
        Print.success('Search history fetched successfully');
        emit(SearchHistorySuccess());
      },
    );
  }

  Future<void> deleteSearchHistory({required int id}) async {
    emit(DeleteSearchHistoryLoading());
    final response = await searchRepo.deleteSearchHistory(id: id);
    response.fold(
      (l) {
        Print.error(l);
        emit(DeleteSearchHistoryError(message: l));
      },
      (r) {
        Print.success('Search history Deleted successfully');
        emit(DeleteSearchHistorySuccess());
        fetchSearchHistory();
      },
    );
  }

  void goToProduct({required int id}) async {
    emit(GoToProductLoading());
    final response = await searchRepo.goToProduct(id: id);
    response.fold(
      (l) {
        Print.error(l);
        emit(GoToProductError(message: l));
      },
      (r) {
        Print.success('You are going to product ========> successfully');
        getRecentView();

        emit(GoToProductSuccess());
      },
    );
  }

  RecentViewModel? recentViewModel;

  Future<void> getRecentView() async {
    emit(RecentViewLoading());
    final response = await searchRepo.getRecentView();
    response.fold(
      (l) {
        Print.error(l);
        emit(RecentViewError(message: l));
      },
      (r) {
        recentViewModel = r;
        Print.success('Recent views fetched successfully');
        emit(RecentViewSuccess());
      },
    );
  }

  Future<void> clearHistory() async {
    emit(ClearHistoryLoading());
    final response = await searchRepo.clearHistory();
    response.fold(
      (l) {
        Print.error(l);
        emit(ClearHistoryError(message: l));
      },
      (r) {
        Print.success('Search history Deleted successfully');
        emit(ClearHistorySuccess());
        init();
      },
    );
  }
}
