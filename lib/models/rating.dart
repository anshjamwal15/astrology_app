import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String forUser;
  final String dateTime;
  final String responseTo;
  final String rating;
  final String comment;
  final String status;
  final DocumentReference user;
  final DocumentReference transactionId;

  const Rating({
    required this.id,
    required this.forUser,
    required this.dateTime,
    required this.responseTo,
    required this.rating,
    required this.comment,
    required this.status,
    required this.user,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [
        id,
        forUser,
        dateTime,
        responseTo,
        rating,
        comment,
        status,
        user,
        transactionId,
      ];

  static Rating fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'] as String,
      forUser: map['for_user'] as String,
      dateTime: map['date_time'] as String,
      responseTo: map['response_to'] as String,
      rating: map['rating'] as String,
      comment: map['comment'] as String,
      status: map['status'] as String,
      user: map['user']['value'] as DocumentReference,
      transactionId: map['transaction_id']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'for_user': forUser,
      'date_time': dateTime,
      'response_to': responseTo,
      'rating': rating,
      'comment': comment,
      'status': status,
      'user': {'value': user},
      'transaction_id': {'value': transactionId},
    };
  }

  factory Rating.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rating(
      id: data['id'] ?? '',
      forUser: data['for_user'] ?? '',
      dateTime: data['date_time'] ?? '',
      responseTo: data['response_to'] ?? '',
      rating: data['rating'] ?? '',
      comment: data['comment'] ?? '',
      status: data['status'] ?? '',
      user: data['user']['value'] as DocumentReference,
      transactionId: data['transaction_id']['value'] as DocumentReference,
    );
  }
}
