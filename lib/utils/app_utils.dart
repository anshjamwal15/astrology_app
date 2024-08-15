import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>?> getRefDocumentData(DocumentReference ref) async {
  try {
    DocumentSnapshot docSnapshot = await ref.get();
    return docSnapshot.exists ? docSnapshot.data() as Map<String, dynamic>? : null;
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching document: $e');
    }
    return null;
  }
}

Future<DocumentSnapshot?> findDocumentWithField({
  required String collectionPath,
  required String fieldName,
  required dynamic value,
}) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where(fieldName, isEqualTo: value)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error finding document: $e');
    }
    return null;
  }
}


String filterTrueValues(Map<String, dynamic> inputMap) {
  for (var entry in inputMap.entries) {
    if (entry.value && entry.key != "id") {
      return entry.key;
    }
  }
  return '';
}