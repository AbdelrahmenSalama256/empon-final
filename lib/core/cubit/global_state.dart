part of 'global_cubit.dart';

sealed class GlobalState extends Equatable {
  const GlobalState();

  @override
  List<Object> get props => [];
}

final class GlobalInitial extends GlobalState {}

final class BottomNavChangeState extends GlobalState {}

// Any Other State You May Need
class LoadingState extends GlobalState {}

class ErrorState extends GlobalState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}

class LanguageChangeState extends GlobalState {}
