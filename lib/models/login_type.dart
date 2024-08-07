import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LoginType extends Equatable {
  final String id;
  final String title;

  const LoginType({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];

  static LoginType fromMap(Map<String, dynamic> map) {
    return LoginType(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory LoginType.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoginType(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
    );
  }
}
