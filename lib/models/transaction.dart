import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final int amount;
  final int tax;
  final String mentorRateId;
  final Timestamp dateTimeFrom;
  final Timestamp dateTimeTo;
  final String gatewayId;
  final int duration;
  final int total;
  final int balance;
  final String currency;
  final String orderId;
  final DocumentReference tType;
  final DocumentReference sessionId;
  final DocumentReference user;

  const Transaction({
    required this.id,
    required this.amount,
    required this.tax,
    required this.mentorRateId,
    required this.dateTimeFrom,
    required this.dateTimeTo,
    required this.gatewayId,
    required this.duration,
    required this.total,
    required this.balance,
    required this.currency,
    required this.orderId,
    required this.tType,
    required this.sessionId,
    required this.user,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        tax,
        mentorRateId,
        dateTimeFrom,
        dateTimeTo,
        gatewayId,
        duration,
        total,
        balance,
        currency,
        orderId,
        tType,
        sessionId,
        user,
      ];

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      amount: map['amount'] as int,
      tax: map['tax'] as int,
      mentorRateId: map['mentor_rate_id'] as String,
      dateTimeFrom: map['date_time_from']['value'] as Timestamp,
      dateTimeTo: map['date_time_to']['value'] as Timestamp,
      gatewayId: map['gateway_id'] as String,
      duration: map['duration'] as int,
      total: map['total'] as int,
      balance: map['balance'] as int,
      currency: map['currency'] as String,
      orderId: map['order_id'] as String,
      tType: map['t_type']['value'] as DocumentReference,
      sessionId: map['session_id']['value'] as DocumentReference,
      user: map['user']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'tax': tax,
      'mentor_rate_id': mentorRateId,
      'date_time_from': {'value': dateTimeFrom},
      'date_time_to': {'value': dateTimeTo},
      'gateway_id': gatewayId,
      'duration': duration,
      'total': total,
      'balance': balance,
      'currency': currency,
      'order_id': orderId,
      't_type': {'value': tType},
      'session_id': {'value': sessionId},
      'user': {'value': user},
    };
  }

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: data['id'] ?? '',
      amount: data['amount'] ?? 0,
      tax: data['tax'] ?? 0,
      mentorRateId: data['mentor_rate_id'] ?? '',
      dateTimeFrom: data['date_time_from']['value'] as Timestamp,
      dateTimeTo: data['date_time_to']['value'] as Timestamp,
      gatewayId: data['gateway_id'] ?? '',
      duration: data['duration'] ?? 0,
      total: data['total'] ?? 0,
      balance: data['balance'] ?? 0,
      currency: data['currency'] ?? '',
      orderId: data['order_id'] ?? '',
      tType: data['t_type']['value'] as DocumentReference,
      sessionId: data['session_id']['value'] as DocumentReference,
      user: data['user']['value'] as DocumentReference,
    );
  }
}
