import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String id;
  final String code;
  final String language;
  final String status;

  const Language({
    required this.id,
    required this.code,
    required this.language,
    required this.status,
  });

  @override
  List<Object?> get props => [id, code, language, status];

  static Language fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['id'] as String,
      code: map['code'] as String,
      language: map['language'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'language': language,
      'status': status,
    };
  }

  factory Language.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Language(
      id: data['id'] ?? '',
      code: data['code'] ?? '',
      language: data['language'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
