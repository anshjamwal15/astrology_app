import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatListMessages extends Equatable {
  final Timestamp dateTime;
  final String userName;
  final String message;
  final String senderId;
  final bool isRead;

  const ChatListMessages({
    required this.dateTime,
    required this.userName,
    required this.message,
    required this.senderId,
    required this.isRead
  });

  @override
  List<Object?> get props => [dateTime, userName, message, senderId, isRead];
}