import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final String id;
  final String title;

  const Status({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];

  static Status fromMap(Map<String, dynamic> map) {
    return Status(
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

  factory Status.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Status(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
    );
  }
}
