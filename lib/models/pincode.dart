import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Pincode extends Equatable {
  final String id;
  final String pincode;

  const Pincode({
    required this.id,
    required this.pincode,
  });

  @override
  List<Object?> get props => [id, pincode];

  static Pincode fromMap(Map<String, dynamic> map) {
    return Pincode(
      id: map['id'] as String,
      pincode: map['pincode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pincode': pincode,
    };
  }

  factory Pincode.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pincode(
      id: data['id'] ?? '',
      pincode: data['pincode'] ?? '',
    );
  }
}
