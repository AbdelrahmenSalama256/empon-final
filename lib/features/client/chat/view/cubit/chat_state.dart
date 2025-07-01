import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}

class ChatContactLoading extends ChatState {}

class ChatContactLoaded extends ChatState {}

class ChatContactError extends ChatState {
  final String error;
  ChatContactError(this.error);
}

class ChatInputChanged extends ChatState {
  final String text;
  ChatInputChanged(this.text);
}

class ChatReplyChanged extends ChatState {
  final Message? message;
  ChatReplyChanged(this.message);
}

class ChatRecordingStarted extends ChatState {}

class ChatRecordingUpdated extends ChatState {
  final int duration;
  ChatRecordingUpdated(this.duration);
}

class ChatRecordingStopped extends ChatState {}

class ChatInputCleared extends ChatState {}

class ChatScrollToLatest extends ChatState {}

class ChatMessageSelected extends ChatState {
  final Message? message;
  ChatMessageSelected(this.message);
}

class ChatMessageFocused extends ChatState {
  final Message message;
  ChatMessageFocused(this.message);
}

class ChatMessageDeleting extends ChatState {
  final int messageId;
  ChatMessageDeleting(this.messageId);
}

class ChatMessageDeleted extends ChatState {
  final int messageId;
  ChatMessageDeleted(this.messageId);
}

class ChatCleared extends ChatState {}

class MassageSentLoading extends ChatState {
  final Message message;
  MassageSentLoading(this.message);
}

class MassageSentLoaded extends ChatState {
  final Message message;
  MassageSentLoaded(this.message);
}

class ChatContactsFiltered extends ChatState {
  final List<ChatContact> filteredContacts;

  ChatContactsFiltered(this.filteredContacts);
}

class MassageSentError extends ChatState {
  final String error;
  MassageSentError(this.error);
}

class ChatCleareLoading extends ChatState {}

class ChatCleareError extends ChatState {
  final String? error;

  ChatCleareError(this.error);
}

class ChatContactSelected extends ChatState {
  final ChatContact? contact;

  ChatContactSelected(this.contact);
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
  deleting,
}
