import 'dart:async';
import 'package:astrology_app/models/chat_messages.dart';
import 'package:astrology_app/models/user.dart'; // Import the User model
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
        _messagesSubscription?.cancel(); // Cancel any previous subscription
        _messagesSubscription = chatRepository.getChatMessagesStream(event.chatId).listen(
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

    on<SendMessage>((event, emit) async {
      try {
        await chatRepository.sendMessage(event.chatId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<LoadUsersWhoMessaged>((event, emit) async {
      emit(UsersLoading());
      try {
        List<User> users = await chatRepository.getUsersWhoMessaged(event.userId);
        emit(UsersLoaded(users));
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
