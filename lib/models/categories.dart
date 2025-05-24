import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Categories extends Equatable {
  final String id;
  final String code;
  final String name;
  final String icon;
  final int predecessor;
  final String text;
  final String status;
  final String order;
  final String image;
  // final String language;

  const Categories({
    required this.id,
    required this.code,
    required this.name,
    required this.icon,
    required this.predecessor,
    required this.text,
    required this.status,
    required this.order,
    required this.image
    // required this.language,
  });

  @override
  List<Object?> get props => [id, code, name, icon, predecessor, text, status, order, image];


  static Categories fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Categories(
      id: data['id'] ?? '',
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      predecessor: data['predecessor'] ?? 0,
      text: data['text'] ?? '',
      status: data['status'] ?? '',
      order: data['order'] ?? '',
      image: data['image'] ?? ''
      // language: data['language']['value'] as DocumentReference,
    );
  }
}
