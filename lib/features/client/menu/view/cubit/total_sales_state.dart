

import 'package:embone/features/client/menu/data/model/total_sales_model.dart';

class TotalSalesState {
  const TotalSalesState();
}

final class TotalSalesInitial extends TotalSalesState {}

class TotalSalesLoading extends TotalSalesState {}

class TotalSalesLoaded extends TotalSalesState {
  final StatisticsData? totalSalesResponse;

  TotalSalesLoaded(this.totalSalesResponse);
}

class TotalSalesError extends TotalSalesState {
  final String message;

  const TotalSalesError(this.message);
}


