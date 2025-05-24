part of 'chat_message_list_cubit.dart';

abstract class ChatMessageListState extends Equatable {
  const ChatMessageListState();

  @override
  List<Object> get props => [];
}

class ChatMessageListInitial extends ChatMessageListState {}

class ChatMessageListLoading extends ChatMessageListState {}

class ChatMessageListLoaded extends ChatMessageListState {
  final List<ChatListMessages> users;

  const ChatMessageListLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatMessageListError extends ChatMessageListState {
  final String message;

  const ChatMessageListError(this.message);

  @override
  List<Object> get props => [message];
}
