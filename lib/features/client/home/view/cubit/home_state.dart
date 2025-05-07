part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});
}

class HomeActionTapped extends HomeState {
  final int productId;

  const HomeActionTapped({required this.productId});
}
