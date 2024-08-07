import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String lastTransactionId;
  final String mentorId;
  final int balance;
  final String dateTime;
  final String currency;
  final DocumentReference userId;

  const Wallet({
    required this.id,
    required this.lastTransactionId,
    required this.mentorId,
    required this.balance,
    required this.dateTime,
    required this.currency,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, lastTransactionId, mentorId, balance, dateTime, currency, userId];

  static Wallet fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'] as String,
      lastTransactionId: map['last_transaction_id'] as String,
      mentorId: map['mentor_id'] as String,
      balance: map['balance'] as int,
      dateTime: map['date_time'] as String,
      currency: map['currency'] as String,
      userId: map['user_id'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last_transaction_id': lastTransactionId,
      'mentor_id': mentorId,
      'balance': balance,
      'date_time': dateTime,
      'currency': currency,
      'user_id': userId,
    };
  }

  factory Wallet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Wallet(
      id: data['id'] ?? '',
      lastTransactionId: data['last_transaction_id'] ?? '',
      mentorId: data['mentor_id'] ?? '',
      balance: data['balance'] ?? 0,
      dateTime: data['date_time'] ?? '',
      currency: data['currency'] ?? '',
      userId: data['user_id']?['value'] as DocumentReference,
    );
  }
}
