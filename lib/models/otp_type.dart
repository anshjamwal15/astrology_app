import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OtpType extends Equatable {
  final String id;
  final String title;

  const OtpType({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];

  static OtpType fromMap(Map<String, dynamic> map) {
    return OtpType(
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

  factory OtpType.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OtpType(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
    );
  }
}
