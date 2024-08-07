import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SubCategory extends Equatable {
  final String id;
  final String title;
  final String status;
  final DocumentReference categoryId;

  const SubCategory({
    required this.id,
    required this.title,
    required this.status,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, title, status, categoryId];

  static SubCategory fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'] as String,
      title: map['title'] as String,
      status: map['status'] as String,
      categoryId: map['category_id']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'category_id': {'value': categoryId},
    };
  }

  factory SubCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubCategory(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      status: data['status'] ?? '',
      categoryId: data['category_id']['value'] as DocumentReference,
    );
  }
}
