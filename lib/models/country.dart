import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String code;
  final String name;
  final String currencyCode;
  final String currencyName;

  const Country({
    required this.id,
    required this.code,
    required this.name,
    required this.currencyCode,
    required this.currencyName,
  });

  @override
  List<Object?> get props => [id, code, name, currencyCode, currencyName];

  static Country fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      currencyCode: map['currency_code'] as String,
      currencyName: map['currency_name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'currency_code': currencyCode,
      'currency_name': currencyName,
    };
  }

  factory Country.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Country(
      id: data['id'] ?? '',
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      currencyCode: data['currency_code'] ?? '',
      currencyName: data['currency_name'] ?? '',
    );
  }
}
