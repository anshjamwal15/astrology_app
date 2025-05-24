import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionDetails extends Equatable {
  final String id;
  final String dateTime;
  final String fileName;
  final DocumentReference iType;
  final DocumentReference categoryId;
  final DocumentReference subCategoryId;
  final DocumentReference transactionId;

  const TransactionDetails({
    required this.id,
    required this.dateTime,
    required this.fileName,
    required this.iType,
    required this.categoryId,
    required this.subCategoryId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [
        id,
        dateTime,
        fileName,
        iType,
        categoryId,
        subCategoryId,
        transactionId,
      ];

  static TransactionDetails fromMap(Map<String, dynamic> map) {
    return TransactionDetails(
      id: map['id'] as String,
      dateTime: map['date_time'] as String,
      fileName: map['file_name'] as String,
      iType: map['i_type']['value'] as DocumentReference,
      categoryId: map['category_id']['value'] as DocumentReference,
      subCategoryId: map['sub_category_id']['value'] as DocumentReference,
      transactionId: map['transaction_id']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime,
      'file_name': fileName,
      'i_type': {'value': iType},
      'category_id': {'value': categoryId},
      'sub_category_id': {'value': subCategoryId},
      'transaction_id': {'value': transactionId},
    };
  }

  factory TransactionDetails.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionDetails(
      id: data['id'] ?? '',
      dateTime: data['date_time'] ?? '',
      fileName: data['file_name'] ?? '',
      iType: data['i_type']['value'] as DocumentReference,
      categoryId: data['category_id']['value'] as DocumentReference,
      subCategoryId: data['sub_category_id']['value'] as DocumentReference,
      transactionId: data['transaction_id']['value'] as DocumentReference,
    );
  }
}
