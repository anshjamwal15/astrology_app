import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final int amount;
  final int? tax;
  final Timestamp dateTime;
  final String? mentorRateId;
  final Timestamp? dateTimeFrom;
  final Timestamp? dateTimeTo;
  final String? gatewayId;
  final int? duration;
  final int? total;
  final int? balance;
  final String? currency;
  final String? orderId;
  final String? tType;
  final String? sessionId;
  final String user;

  const Transaction({
    required this.id,
    required this.amount,
    required this.dateTime,
    this.tax,
    this.mentorRateId,
    this.dateTimeFrom,
    this.dateTimeTo,
    this.gatewayId,
    this.duration,
    this.total,
    this.balance,
    this.currency,
    this.orderId,
    this.tType,
    this.sessionId,
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

  /// Convert Firestore document to Transaction
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Transaction(
      id: data['id'] ?? '',
      amount: data['amount'] ?? 0,
      dateTime: data['date_time'] as Timestamp,
      tax: data['tax'] as int?,
      mentorRateId: data['mentor_rate_id'] as String?,
      dateTimeFrom: data['date_time_from'] != null
          ? data['date_time_from'] as Timestamp
          : null, // Handle null safely
      dateTimeTo: data['date_time_to'] != null
          ? data['date_time_to'] as Timestamp
          : null, // Handle null safely
      gatewayId: data['gateway_id'] as String?,
      duration: data['duration'] as int?,
      total: data['total'] as int?,
      balance: data['balance'] as int?,
      currency: data['currency'] as String?,
      orderId: data['order_id'] as String?,
      tType: data['t_type'] as String?,
      sessionId: data['session_id'] as String?,
      user: data['user'] ?? '',
    );
  }

  /// Convert Transaction to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'tax': tax,
      'mentor_rate_id': mentorRateId,
      'date_time_from': dateTimeFrom,
      'date_time_to': dateTimeTo,
      'gateway_id': gatewayId,
      'duration': duration,
      'total': total,
      'balance': balance,
      'currency': currency,
      'order_id': orderId,
      't_type': tType,
      'session_id': sessionId,
      'user': user,
    };
  }

  /// Create Transaction from Map (useful for other contexts)
  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      amount: map['amount'] as int,
      dateTime: map['date_time'] as Timestamp,
      tax: map['tax'] as int?,
      mentorRateId: map['mentor_rate_id'] as String?,
      dateTimeFrom: map['date_time_from'] != null
          ? map['date_time_from'] as Timestamp
          : null, // Handle null safely
      dateTimeTo: map['date_time_to'] != null
          ? map['date_time_to'] as Timestamp
          : null, // Handle null safely
      gatewayId: map['gateway_id'] as String?,
      duration: map['duration'] as int?,
      total: map['total'] as int?,
      balance: map['balance'] as int?,
      currency: map['currency'] as String?,
      orderId: map['order_id'] as String?,
      tType: map['t_type'] as String?,
      sessionId: map['session_id'] as String?,
      user: map['user'] as String,
    );
  }
}
