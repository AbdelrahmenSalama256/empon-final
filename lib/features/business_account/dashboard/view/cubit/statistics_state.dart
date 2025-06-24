part of 'statistics_cubit.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

final class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final StatisticsData statistics;

  StatisticsLoaded(this.statistics);
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}
