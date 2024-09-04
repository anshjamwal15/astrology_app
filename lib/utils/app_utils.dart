import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('hh:mm a').format(dateTime);
}

String createCallRoom(List<String> members) {
  members.sort();
  return members.join('_').substring(0, 8);
}

void printWarning(Object text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(Object text) {
  print('\x1B[31m$text\x1B[0m');
}