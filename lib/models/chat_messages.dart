import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessages extends Equatable {
  final Timestamp dateTime;
  final String message;
  final List<String> members;
  final String sentBy;
  final bool isRead;

  const ChatMessages({
    required this.dateTime,
    required this.message,
    required this.members,
    required this.sentBy,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [dateTime, message, members, sentBy, isRead];

  static ChatMessages fromMap(Map<String, dynamic> map) {
    return ChatMessages(
      dateTime: map['date_time'] as Timestamp,
      message: map['message'] as String,
      members: List<String>.from(map['members'] as List),
      sentBy: map['sent_by'] as String,
      isRead: map['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime,
      'message': message,
      'members': members,
      'sent_by': sentBy,
      'is_read': isRead,
    };
  }

  factory ChatMessages.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessages(
      dateTime: data['date_time'] as Timestamp,
      message: data['message'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      sentBy: data['sent_by'] ?? '',
      isRead: data['is_read'] ?? false,
    );
  }
}
