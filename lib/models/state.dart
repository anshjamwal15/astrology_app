import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class State extends Equatable {
  final String id;
  final String code;
  final String name;
  final DocumentReference countryId;

  const State({
    required this.id,
    required this.code,
    required this.name,
    required this.countryId,
  });

  @override
  List<Object?> get props => [id, code, name, countryId];

  static State fromMap(Map<String, dynamic> map) {
    return State(
      id: map['id'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      countryId: map['country_id']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'country_id': {'value': countryId},
    };
  }

  factory State.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return State(
      id: data['id'] ?? '',
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      countryId: data['country_id']['value'] as DocumentReference,
    );
  }
}
