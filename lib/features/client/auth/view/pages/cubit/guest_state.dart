class GuestState {}

final class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestError extends GuestState {
  final String message;

  GuestError({required this.message});
}

class GuestSuccess extends GuestState {
  final String message;

  GuestSuccess(this.message);
}
