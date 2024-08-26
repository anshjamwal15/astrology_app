import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FirebaseDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _roomsCollection = 'rooms';
  static const String _candidatesCollection = 'candidates';
  static const String _candidateUidField = 'uid';

  String? userId;

  Future<String> createRoom({required RTCSessionDescription offer}) async {
    final roomRef = _db.collection(_roomsCollection).doc();
    final roomWithOffer = <String, dynamic>{'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    return roomRef.id;
  }

  Future<RTCSessionDescription?> getRoomOfferIfExists({required String roomId}) async {
    final roomDoc = await _db.collection(_roomsCollection).doc(roomId).get();
    if (!roomDoc.exists) return null;

    final data = roomDoc.data() as Map<String, dynamic>;
    final offer = data['offer'];
    return RTCSessionDescription(offer['sdp'], offer['type']);
  }

  Future<void> setAnswer({
    required String roomId,
    required RTCSessionDescription answer,
  }) async {
    final roomRef = _db.collection(_roomsCollection).doc(roomId);
    final answerMap = <String, dynamic>{
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    };
    await roomRef.update(answerMap);
  }

  Future<void> addCandidateToRoom({
    required String roomId,
    required RTCIceCandidate candidate,
  }) async {
    final roomRef = _db.collection(_roomsCollection).doc(roomId);
    final candidatesCollection = roomRef.collection(_candidatesCollection);
    await candidatesCollection.add(candidate.toMap()..[_candidateUidField] = userId);
  }

  Stream<RTCSessionDescription?> getRoomDataStream({required String roomId}) {
    final snapshots = _db.collection(_roomsCollection).doc(roomId).snapshots();
    final filteredStream = snapshots.map((snapshot) => snapshot.data());
    return filteredStream.map(
          (data) {
        if (data != null && data['answer'] != null) {
          return RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );
        } else {
          return null;
        }
      },
    );
  }

  Stream<List<RTCIceCandidate>> getCandidatesAddedToRoomStream({
    required String roomId,
    required bool listenCaller,
  }) {
    final snapshots = _db
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_candidatesCollection)
        .where(_candidateUidField, isNotEqualTo: userId)
        .snapshots();

    final convertedStream = snapshots.map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            final data = doc.data();
            return RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            );
          },
        ).toList();
      },
    );

    return convertedStream;
  }

}
