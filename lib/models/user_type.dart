import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserType extends Equatable {
  final String id;
  final String userMentor;
  final String title;
  final String status;

  const UserType({
    required this.id,
    required this.userMentor,
    required this.title,
    required this.status,
  });

  @override
  List<Object?> get props => [id, userMentor, title, status];

  static UserType fromMap(Map<String, dynamic> map) {
    return UserType(
      id: map['id'] as String,
      userMentor: map['user_mentor'] as String,
      title: map['title'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_mentor': userMentor,
      'title': title,
      'status': status,
    };
  }

  factory UserType.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserType(
      id: data['id'] ?? '',
      userMentor: data['user_mentor'] ?? '',
      title: data['title'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
