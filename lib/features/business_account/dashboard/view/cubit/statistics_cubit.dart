import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/dashboard/data/models/statistics_model.dart';
import 'package:embone/features/business_account/dashboard/data/repo/statistics_repo.dart';
import 'package:equatable/equatable.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this.statisticsRepo) : super(StatisticsInitial());
  final StatisticsRepo statisticsRepo;
  StatisticsData? statistics;

  Future<void> fetchStatistics(int? accountId) async {
    emit(StatisticsLoading());

    final result = await statisticsRepo.fetchStatistics(accountId);

    result.fold(
      (error) => emit(StatisticsError(error)),
      (stats) {
        statistics = stats.data;
        emit(StatisticsLoaded(statistics!));
      },
    );
  }

}
