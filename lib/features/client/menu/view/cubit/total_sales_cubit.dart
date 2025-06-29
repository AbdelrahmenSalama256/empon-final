import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/model/total_sales_model.dart';
import 'package:embone/features/client/menu/data/repo/total_sales_repo.dart';
import 'package:embone/features/client/menu/view/cubit/total_sales_state.dart';

class TotalSalesCubit extends Cubit<TotalSalesState> {
  final TotalSalesRepo totalSalesRepo;
   StatisticsData? totalSales;
  TotalSalesCubit(this.totalSalesRepo) : super(TotalSalesInitial());
  void init() {
    totalSales = null;
  }

  Future<void> fetchTotalSales(
    String type,
    String date
  ) async {
    if (isClosed) return;

    emit(TotalSalesLoading());
    Print.info("Starting to fetch TotalSales");

    final result = await totalSalesRepo.fetchStatistics(
      type: type,
      date: date
    );

    if (isClosed) return;

    result.fold(
      (error) {
        Print.error("Failed to fetch TotalSales: $error");
        emit(TotalSalesError(error.toString()));
      },
      (totalSalesResponse) {
        totalSales = totalSalesResponse.data;
        emit(TotalSalesLoaded(totalSales!));
      },
    );
  }


}
