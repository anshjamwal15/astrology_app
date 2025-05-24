import 'dart:async';

import 'package:astrology_app/models/chat_list_messages.dart';
import 'package:astrology_app/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_message_list_state.dart';

class ChatMessageListCubit extends Cubit<ChatMessageListState> {
  final _chatRepository = ChatRepository();
  StreamSubscription<List<ChatListMessages>>?
  usersMessageListStreamSubscription;

  ChatMessageListCubit(): super(ChatMessageListInitial());

  Future<void> loadChatMessageList(String userId) async {
    try {
      usersMessageListStreamSubscription?.cancel();
      usersMessageListStreamSubscription = _chatRepository
          .getUsersWhoMessaged(userId)
          .listen((users) => emit(ChatMessageListLoaded(users)));
    } catch (e) {
      emit(ChatMessageListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    usersMessageListStreamSubscription?.cancel();
    return super.close();
  }
}