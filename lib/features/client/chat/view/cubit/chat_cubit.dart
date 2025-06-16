import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  List<Message> messages = [];

  ChatCubit(this.chatRepo) : super(ChatInitial());

  Future<void> fetchMessages(int receiverId) async {
    emit(ChatLoading());
    final response = await chatRepo.getMessages(receiverId: receiverId);
    response.fold(
      (error) => emit(ChatError(error)),
      (messagesResponse) {
        messages = messagesResponse;
        PrintUtil.debug(messages);
        emit(ChatLoaded());
      },
    );
  }
}
