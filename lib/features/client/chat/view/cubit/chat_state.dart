
class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatError extends ChatState {
  final String? massage;

  ChatError(this.massage);
}

final class ChatLoaded extends ChatState {
  
}
