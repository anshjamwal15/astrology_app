part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatMessages extends ChatEvent {
  final String chatId;

  const LoadChatMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final ChatMessages message;

  const SendMessage(this.chatId, this.message);

  @override
  List<Object> get props => [chatId, message];
}

class LoadUsersWhoMessaged extends ChatEvent {
  final String userId;

  const LoadUsersWhoMessaged(this.userId);

  @override
  List<Object> get props => [userId];
}

class _ChatMessagesUpdated extends ChatEvent {
  final List<ChatMessages> messages;

  const _ChatMessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

class MarkMessagesAsRead extends ChatEvent {
  final String chatId;
  final String userId;

  const MarkMessagesAsRead(this.chatId, this.userId);

  @override
  List<Object> get props => [chatId, userId];
}

class GetUnreadCount extends ChatEvent {
  final String userId;

  const GetUnreadCount(this.userId);

  @override
  List<Object> get props => [userId];
}
