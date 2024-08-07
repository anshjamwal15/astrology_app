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
  final DocumentReference language;

  const Categories({
    required this.id,
    required this.code,
    required this.name,
    required this.icon,
    required this.predecessor,
    required this.text,
    required this.status,
    required this.order,
    required this.language,
  });

  @override
  List<Object?> get props => [id, code, name, icon, predecessor, text, status, order, language];

  static Categories fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      predecessor: map['predecessor'] as int,
      text: map['text'] as String,
      status: map['status'] as String,
      order: map['order'] as String,
      language: map['language']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'icon': icon,
      'predecessor': predecessor,
      'text': text,
      'status': status,
      'order': order,
      'language': language.path,
    };
  }

  factory Categories.fromFirestore(DocumentSnapshot doc) {
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
      language: data['language']['value'] as DocumentReference,
    );
  }
}
