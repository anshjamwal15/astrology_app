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
