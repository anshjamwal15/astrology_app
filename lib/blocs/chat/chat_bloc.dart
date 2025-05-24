import 'dart:async';
import 'package:astrology_app/models/chat_list_messages.dart';
import 'package:astrology_app/models/chat_messages.dart';
import 'package:astrology_app/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<ChatMessages>>? _messagesSubscription;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<LoadChatMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        _messagesSubscription?.cancel();
        _messagesSubscription =
            chatRepository.getChatMessagesStream(event.chatId).listen(
          (messages) {
            add(_ChatMessagesUpdated(messages));
          },
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<_ChatMessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    on<_ChatListUpdated>((event, emit) {
      emit(UsersLoaded(event.messages));
    });

    on<SendMessage>((event, emit) async {
      try {
        await chatRepository.sendMessage(event.chatId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<MarkMessagesAsRead>((event, emit) async {
      try {
        await chatRepository.markMessagesAsRead(event.chatId, event.userId);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<GetUnreadCount>((event, emit) async {
      try {
        final count = await chatRepository.getUnreadMessageCount(event.userId);
        emit(UnreadCountLoaded(count));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
