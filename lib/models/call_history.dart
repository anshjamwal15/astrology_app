import 'package:cloud_firestore/cloud_firestore.dart';

class CallHistory {
  final String id;
  final String caller;
  final String callee;
  final DateTime createdAt;
  final int duration;
  final String type;

  CallHistory({
    required this.id,
    required this.caller,
    required this.callee,
    required this.createdAt,
    required this.duration,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caller': caller,
      'callee': callee,
      'createdAt': Timestamp.fromDate(createdAt),
      'duration': duration,
      'type': type,
    };
  }

  static CallHistory fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CallHistory(
      id: data['id'] ?? '',
      caller: data['caller'] ?? '',
      callee: data['callee'] ?? '',
      createdAt: data['createdAt'] ?? '',
      duration: data['duration'] ?? 0,
      type: data['type'] ?? '',
    );
  }
}
