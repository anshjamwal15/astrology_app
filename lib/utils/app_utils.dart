import 'package:astrology_app/constants/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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

String formatTimestamp(Timestamp timestamp, [bool? withDate]) {
  DateTime dateTime = timestamp.toDate();
  if (withDate == true) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }
  return DateFormat('hh:mm a').format(dateTime);
}

class UniqueIdGenerator {
  static const Uuid _uuid = Uuid();

  static String generate() {
    return _uuid.v4();
  }
}

void printWarning(Object? text) {
  String line = "$text";
  print('\x1B[33m$line\x1B[0m');
}

void printError(Object? text) {
  String line = "$text";
  print('\x1B[31m$line\x1B[0m');
}


Future<void> showLoader(BuildContext context) async {
  if (!isDialogOpen()) {
    AppConstants.isLoaderRunning = true;
    final size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: size.height * 0.1,
              child: Column(
                children: [
                  CircularProgressIndicator(color: Colors.blue.shade900),
                  SizedBox(height: size.height * 0.02),
                  const Text("Loading...."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  AppConstants.isLoaderRunning = false;
}

bool isDialogOpen() {
  return AppConstants.isLoaderRunning;
}
