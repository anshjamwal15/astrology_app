import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HowToKnow extends Equatable {
  final String id;
  final String userMentor;
  final String title;
  final String status;
  final String order;

  const HowToKnow({
    required this.id,
    required this.userMentor,
    required this.title,
    required this.status,
    required this.order,
  });

  @override
  List<Object?> get props => [id, userMentor, title, status, order];

  static HowToKnow fromMap(Map<String, dynamic> map) {
    return HowToKnow(
      id: map['id'] as String,
      userMentor: map['user_mentor'] as String,
      title: map['title'] as String,
      status: map['status'] as String,
      order: map['order'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_mentor': userMentor,
      'title': title,
      'status': status,
      'order': order,
    };
  }

  factory HowToKnow.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HowToKnow(
      id: data['id'] ?? '',
      userMentor: data['user_mentor'] ?? '',
      title: data['title'] ?? '',
      status: data['status'] ?? '',
      order: data['order'] ?? '',
    );
  }
}
