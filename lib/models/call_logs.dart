import 'package:astrology_app/repository/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallLogs {
  final String caller;
  final String callee;
  final Timestamp createdAt;
  final String duration;
  final String callType;
  final Timestamp endedAt;
  final String status;

  CallLogs({
    required this.caller,
    required this.callee,
    required this.createdAt,
    required this.duration,
    required this.callType,
    required this.endedAt,
    required this.status
  });

  static Future<CallLogs> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final caller = await UserRepository().getUserById(data['callerId']);
    return CallLogs(
      caller: caller?.name ?? '',
      callee: data['calleeId'] ?? '',
      createdAt: data['createdAt'] ?? '',
      duration: data['duration'] ?? '',
      callType: data['callType'] ?? '',
      endedAt: data['endedAt'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
