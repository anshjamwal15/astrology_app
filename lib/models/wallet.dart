import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String? lastTransactionId;
  final String? mentorId;
  final int balance;
  final Timestamp dateTime;
  final String currency;
  final String userId;

  const Wallet({
    required this.id,
    this.lastTransactionId,
    this.mentorId,
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
      lastTransactionId: map['last_transaction_id'] as String?,
      mentorId: map['mentor_id'] as String?,
      balance: map['balance'] as int,
      dateTime: map['date_time'] as Timestamp,
      currency: map['currency'] as String,
      userId: map['user_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      userId: data['user_id'] ?? '',
    );
  }
}
