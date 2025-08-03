import 'package:embone/features/client/menu/data/model/support_message_model.dart';

class SupportchatState {}

final class SupportchatInitial extends SupportchatState {}

final class SupportchatLoading extends SupportchatState {}

final class SupportchatLoaded extends SupportchatState {
  final List<SupportMessageModel> messages;
  SupportchatLoaded(this.messages);
}

final class SupportchatError extends SupportchatState {
  final String error;
  SupportchatError(this.error);
}

final class LoadMessagesLoadingState extends SupportchatState {}

final class LoadMessagesErrorState extends SupportchatState {}

final class LoadMessagesSuccessState extends SupportchatState {}
