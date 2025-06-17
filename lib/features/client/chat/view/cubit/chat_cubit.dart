import 'package:bloc/bloc.dart';
import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  List<Message> messages = [];
  List<ChatContact> contacts = [];
  Message? replyMessage;
  String inputText = '';
  bool isRecording = false;
  int recordingDuration = 0;
  Message? selectedMessage;
  Message? focusedMessage;
  Set<int> selectedMessageIds = {};
  ChatCubit(this.chatRepo) : super(ChatInitial());

  void updateInputText(String text) {
    inputText = text;
    emit(ChatInputChanged(text));
  }

  void setReplyMessage(Message? message) {
    replyMessage = message;
    emit(ChatReplyChanged(message));
  }

  void clearReply() {
    replyMessage = null;
    emit(ChatReplyChanged(null));
  }

  void startRecording() {
    isRecording = true;
    recordingDuration = 0;
    emit(ChatRecordingStarted());
  }

  void updateRecordingDuration(int duration) {
    recordingDuration = duration;
    emit(ChatRecordingUpdated(duration));
  }

  void stopRecording() {
    isRecording = false;
    if (recordingDuration > 0) {
      _sendVoiceMessage();
    }
    emit(ChatRecordingStopped());
  }

  void cancelRecording() {
    isRecording = false;
    recordingDuration = 0;
    emit(ChatRecordingStopped());
  }

  Future<void> fetchMessages(int receiverId) async {
    emit(ChatLoading());
    final response = await chatRepo.getMessages(receiverId: receiverId);
    response.fold(
      (error) => emit(ChatError(error)),
      (messagesResponse) {
        messages = messagesResponse;
        emit(ChatLoaded());
      },
    );
  }

  Future<void> fetchChatContacts() async {
    emit(ChatContactLoading());
    final response = await chatRepo.getChatContacts();
    response.fold(
      (error) => emit(ChatContactError(error)),
      (contactsResponse) {
        contacts = contactsResponse;
        emit(ChatContactLoaded());
      },
    );
  }

  Future<void> sendTextMessage(int receiverId, String message) async {
    if (message.trim().isEmpty) return;

    final tempMessage = _createTempMessage(
      receiverId: receiverId,
      message: message,
      mediaType: 'text',
      // status: MessageStatus.sending,
    );

    messages.add(tempMessage);
    emit(MassageSentLoading(tempMessage));

    final response = await chatRepo.sendMessage(
      receiverId: receiverId,
      message: message,
      replayId: replyMessage?.id.toString(),
    );

    response.fold(
      (error) {
        _updateMessageStatus(tempMessage.id, MessageStatus.failed);
        emit(MassageSentError(error));
      },
      (sentMessage) {
        _replaceMessage(
            tempMessage.id,
            sentMessage.copyWith(
              status: MessageStatus.sent,
            ));
        emit(MassageSentLoaded(sentMessage));
      },
    );

    _clearInputState();
  }

  Future<void> sendMediaMessage(
      int receiverId, String message, String mediaType, dynamic media) async {
    final tempMessage = _createTempMessage(
      receiverId: receiverId,
      message: message,
      mediaType: mediaType,
      mediaPath: media?.path,
    );

    messages.add(tempMessage);
    emit(MassageSentLoading(tempMessage));

    final response = await chatRepo.sendMessage(
      receiverId: receiverId,
      message: message,
      mediaType: mediaType,
      media: media,
      replayId: replyMessage?.id.toString(),
    );

    response.fold(
      (error) {
        _updateMessageStatus(tempMessage.id, MessageStatus.failed);
        emit(MassageSentError(error));
      },
      (sentMessage) {
        _replaceMessage(tempMessage.id, sentMessage);
        emit(MassageSentLoaded(sentMessage));
      },
    );

    _clearInputState();
  }

  Future<void> _sendVoiceMessage() async {
    final tempMessage = _createTempMessage(
      receiverId: 0,
      message: '',
      mediaType: 'voice',
    );

    messages.add(tempMessage);
    emit(ChatLoaded());

    // Simulate voice message sending
    await Future.delayed(const Duration(seconds: 2));
    _updateMessageStatus(tempMessage.id, MessageStatus.sent);
    emit(ChatLoaded());
  }

  Message _createTempMessage({
    required int receiverId,
    required String message,
    required String mediaType,
    String? mediaPath,
  }) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch,
      fromMe: true,
      senderId: 0,
      receiverId: receiverId,
      message: message,
      mediaPath: mediaPath,
      mediaType: mediaType,
      replayId: replyMessage?.id.toString(),
      createdAt: DateTime.now().toIso8601String(),
      status: MessageStatus.sending,
    );
  }

  void _updateMessageStatus(int messageId, MessageStatus status) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(status: status);
    }
  }

  void _replaceMessage(int tempId, Message newMessage) {
    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      messages[index] = newMessage.copyWith(status: MessageStatus.sent);
    }
  }

  void _clearInputState() {
    inputText = '';
    replyMessage = null;
    emit(ChatInputCleared());
  }

  void scrollToLatestMessage() {
    emit(ChatScrollToLatest());
  }

  void selectMessage(Message? message) {
    selectedMessage = message;
    emit(ChatMessageSelected(message));
  }

  void clearSelection() {
    selectedMessage = null;
    emit(ChatMessageSelected(null));
  }

  void focusOnMessage(Message message) {
    focusedMessage = message;
    emit(ChatMessageFocused(message));
  }

  void clearFocus() {
    focusedMessage = null;
    emit(ChatLoaded());
  }

  Future<void> deleteMessage(int messageId) async {
    final messageIndex = messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    // Show deleting state
    messages[messageIndex] = messages[messageIndex].copyWith(
      status: MessageStatus.deleting,
    );
    emit(ChatMessageDeleting(messageId));

    final result = await chatRepo.deleteMessage(messageId: messageId);
    result.fold(
      (error) {
        // Restore message if delete failed
        messages[messageIndex] = messages[messageIndex].copyWith(
          status: MessageStatus.sent,
        );
        emit(ChatError(error));
      },
      (_) {
        messages.removeAt(messageIndex);
        emit(ChatMessageDeleted(messageId));
      },
    );
  }

  Future<void> clearChat() async {
    messages.clear();
    emit(ChatCleared());

    // final response = await chatRepo.clearChat(receiverId);
  }

  // Navigate to replied message
  void navigateToReply(Message replyMessage) {
    if (replyMessage.replay != null) {
      // Find the original message
      final originalMessage = messages.firstWhere(
        (msg) => msg.id.toString() == replyMessage.replayId,
        orElse: () => replyMessage, // fallback
      );
      focusOnMessage(originalMessage);
    }
  }
}
