import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  List<Message> messages = [];
  List<ChatContact> contacts = [];
  Message? replyMessage;
  ChatContact? selectedContact;
  String inputText = '';
  bool isRecording = false;
  int recordingDuration = 0;
  Message? selectedMessage;
  Message? focusedMessage;
  Set<int> selectedMessageIds = {};
  late IOWebSocketChannel? _channel;
  final int? receiverId;
  final int currentUserId;
  List<ChatContact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  ChatCubit(this.chatRepo, this.receiverId, this.currentUserId)
      : super(ChatInitial()) {
    initializeWebSocket();
  }

  void initializeWebSocket() {
    if (receiverId != null) {
      _channel =
          IOWebSocketChannel.connect('wss://empon.evyx.lol/comm/$receiverId');
      _channel!.stream.listen(
        (dynamic message) {
          final Map<String, dynamic> data = _parseWebSocketMessage(message);
          if (data['type'] == 'new_message') {
            final newMessage = Message.fromJson(data['message']);
            // Only add if not from current user to avoid echo
            if (newMessage.senderId != currentUserId) {
              newMessage.fromMe = newMessage.senderId == currentUserId;
              messages.add(newMessage);
              emit(MassageSentLoaded(newMessage));
              PrintUtil.debug('New message received: $newMessage');
            }
          }
        },
        onError: (error) {
          emit(MassageSentError('WebSocket error: $error'));
          PrintUtil.error('WebSocket error: $error');
        },
        onDone: () {
          emit(MassageSentError('WebSocket connection closed'));
          PrintUtil.error('WebSocket connection closed');
          initializeWebSocket();
        },
      );
    }
  }

  void selectContact(ChatContact contact) {
    selectedContact = contact;
    emit(ChatContactSelected(contact));
  }

  void clearSelectionContact() {
    selectedContact = null;
    emit(ChatLoaded());
  }

  Map<String, dynamic> _parseWebSocketMessage(dynamic message) {
    try {
      return message is String
          ? Map<String, dynamic>.from(jsonDecode(message))
          : message as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to parse WebSocket message: $e');
      }
      return {};
    }
  }

  @override
  Future<void> close() {
    _channel?.sink.close(ws_status.normalClosure);
    searchController.dispose();

    return super.close();
  }

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
    );

    messages.add(tempMessage);
    emit(MassageSentLoading(tempMessage));
    _channel?.sink.add(jsonEncode({
      'type': 'new_message',
      'receiver_id': receiverId.toString(),
      'message': message,
      'media_type': 'text',
      'replay_id': replyMessage?.id.toString(),
    }));

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
        sentMessage = sentMessage.copyWith(
          fromMe: sentMessage.senderId == currentUserId,
          status: MessageStatus.delivered,
        );
        _replaceMessage(tempMessage.id, sentMessage);
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
        sentMessage = sentMessage.copyWith(
          fromMe: sentMessage.senderId == currentUserId,
          status: MessageStatus.delivered,
        );
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

    await Future.delayed(const Duration(seconds: 2));
    _updateMessageStatus(tempMessage.id, MessageStatus.delivered);
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
      senderId: currentUserId,
      status: MessageStatus.sending,
      receiverId: receiverId,
      message: message,
      mediaPath: mediaPath,
      mediaType: mediaType,
      replayId: replyMessage?.id.toString(),
      createdAt: DateTime.now().toIso8601String(),
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
      messages[index] = newMessage;
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
    selectedContact = null;
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

    messages[messageIndex] = messages[messageIndex].copyWith(
      status: MessageStatus.deleting,
    );
    emit(ChatMessageDeleting(messageId));

    final result = await chatRepo.deleteMessage(messageId: messageId);
    result.fold(
      (error) {
        messages[messageIndex] = messages[messageIndex].copyWith(
          status: MessageStatus.delivered,
        );
        emit(ChatError(error));
      },
      (_) {
        messages.removeAt(messageIndex);
        emit(ChatMessageDeleted(messageId));
      },
    );
  }

  Future<void> clearChat({required int receiveID}) async {
    // Use receiverId from constructor
    emit(ChatCleareLoading());
    final result = await chatRepo.deleteChat(receiveID: receiveID);
    result.fold(
      (error) => emit(ChatCleareError(error)),
      (_) {
        messages.clear();
        contacts.removeAt(receiveID);
        fetchChatContacts();
        emit(ChatCleared());
      },
    );
  }

  void navigateToReply(Message replyMessage) {
    if (replyMessage.replay != null) {
      final originalMessage = messages.firstWhere(
        (msg) => msg.id.toString() == replyMessage.replayId,
        orElse: () => replyMessage,
      );
      focusOnMessage(originalMessage);
    }
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      filteredContacts = List.from(contacts);
    } else {
      filteredContacts = contacts.where((contact) {
        final name = contact.fullName.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
    emit(ChatContactsFiltered(filteredContacts));
  }
}
