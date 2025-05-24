part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessages> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<ChatListMessages> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UnreadCountLoaded extends ChatState {
  final int count;

  const UnreadCountLoaded(this.count);

  @override
  List<Object> get props => [count];
}

