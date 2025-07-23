// supportchat_cubit.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:embone/features/client/menu/data/model/support_chat_conversation_model.dart';
import 'package:embone/features/client/menu/data/model/support_message_model.dart';
import 'package:embone/features/client/menu/data/repo/support_chat_repo.dart';
import 'package:embone/features/client/menu/view/cubit/cubit/supportchat_state.dart';

class SupportchatCubit extends Cubit<SupportchatState> {
  final SupportChatRepo supportChatRepo;
  final int? supportConversationId;
  final int? currentUserId;

  List<SupportMessageModel> messages = [];
  List<SupportConversationModel> conversations = [];

  SupportchatCubit({
    required this.supportChatRepo,
    this.supportConversationId,
    this.currentUserId,
  }) : super(SupportchatInitial()) {
    init();
  }

  void init() {
    fetchConversations();
  }

  Future<void> sendMessage(String message, {File? file}) async {
    if (message.trim().isEmpty && file == null) return;

    final tempMessage = _createTempMessage(
      message: message,
      file: file,
    );
    messages.add(tempMessage);
    emit(SupportchatLoading());

    try {
      final result = await supportChatRepo.sendMessage(
        content: message,
        attachment: file,
      );

      result.fold(
        (error) {
          _updateMessageStatus(tempMessage.id, 'failed');
          emit(SupportchatError(error));
        },
        (response) {
          final sentMessage = response.data.copyWith(
            senderId: currentUserId,
            senderType: 'user',
            status: 'delivered',
          );
          _replaceMessage(tempMessage.id, sentMessage);
          emit(SupportchatLoaded(messages));
        },
      );
    } catch (e) {
      _updateMessageStatus(tempMessage.id, 'failed');
      emit(SupportchatError(e.toString()));
    }
  }

  Future<void> fetchConversations() async {
    emit(SupportchatLoading());
    try {
      final result = await supportChatRepo.fetchMessages();
      result.fold(
        (error) => emit(SupportchatError(error)),
        (fetchedConversations) {
          conversations = fetchedConversations;
          if (supportConversationId != null) {
            // Load messages for the current conversation
            final conversation = conversations.firstWhere(
              (c) => c.id == supportConversationId,
              orElse: () => SupportConversationModel(
                id: 0,
                userId: 0,
                subject: '',
                isClosed: 0,
                lastMessageAt: '',
                createdAt: '',
                updatedAt: '',
                messages: [],
              ),
            );
            messages = conversation.messages;
          }
          emit(SupportchatLoaded(messages));
        },
      );
    } catch (e) {
      emit(SupportchatError(e.toString()));
    }
  }

  SupportMessageModel _createTempMessage({
    required String message,
    File? file,
  }) {
    return SupportMessageModel(
      supportConversationId: supportConversationId ?? 0,
      senderId: currentUserId ?? 0,
      senderType: 'user',
      content: message,
      mediaPath: file?.path,
      mediaType: file != null ? 'image' : 'text',
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
      id: DateTime.now().millisecondsSinceEpoch,
      status: 'sending',
    );
  }

  void _updateMessageStatus(int messageId, String status) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(status: status);
      emit(SupportchatLoaded(List.from(messages)));
    }
  }

  void _replaceMessage(int tempId, SupportMessageModel newMessage) {
    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      messages[index] = newMessage;
      emit(SupportchatLoaded(List.from(messages)));
    }
  }
}
