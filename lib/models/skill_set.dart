import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SkillSet extends Equatable {
  final String id;
  final String title;
  final String status;

  const SkillSet({
    required this.id,
    required this.title,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, status];

  static SkillSet fromMap(Map<String, dynamic> map) {
    return SkillSet(
      id: map['id'] as String,
      title: map['title'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
    };
  }

  factory SkillSet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SkillSet(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
