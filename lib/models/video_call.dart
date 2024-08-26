import 'package:astrology_app/utils/app_utils.dart';
import 'package:astrology_app/utils/rtc_session_description_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallRoom {
  final String roomId;
  final List<String> members;
  final bool isActive;
  final RTCSessionDescription? offer;

  VideoCallRoom({
    required this.roomId,
    required this.members,
    this.isActive = true,
    this.offer,
  });

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'members': members,
      'is_active': isActive,
      'offer': offer?.toMap(),
    };
  }

  static VideoCallRoom fromMap(Map<String, dynamic> map) {
    return VideoCallRoom(
      roomId: map['room_id'] as String,
      members: List<String>.from(map['members']),
      isActive: map['is_active'] as bool,
      offer: map['offer'] != null
          ? RTCSessionDescriptionHelper.fromMap(map['offer'])
          : null,
    );
  }

  factory VideoCallRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoCallRoom(
      roomId: data['room_id'] as String,
      members: List<String>.from(data['members'] ?? []),
      isActive: data['is_active'] ?? false,
      offer: data['offer'] != null
          ? RTCSessionDescriptionHelper.fromMap(data['offer'])
          : null,
    );
  }

  // Create a new room with an offer
  static Future<String> createRoom(String userAId, String userBId, RTCSessionDescription offer) async {
    final roomId = createCallRoom([userAId, userAId]);
    final room = VideoCallRoom(
      roomId: roomId,
      members: [userAId, userBId],
      offer: offer,
    );
    await FirebaseFirestore.instance.collection('video_call_rooms').doc(roomId).set(room.toMap());
    return roomId;
  }

  // Retrieve the offer for a specific room
  static Future<RTCSessionDescription?> getRoomOfferIfExists({required String roomId}) async {
    final roomDoc = await FirebaseFirestore.instance.collection('video_call_rooms').doc(roomId).get();
    if (!roomDoc.exists) return null;

    final data = roomDoc.data() as Map<String, dynamic>;
    final offer = data['offer'];
    return offer != null
        ? RTCSessionDescriptionHelper.fromMap(offer)
        : null;
  }

  // Set the answer for a specific room
  static Future<void> setAnswer({
    required String roomId,
    required RTCSessionDescription answer,
  }) async {
    final roomRef = FirebaseFirestore.instance.collection('video_call_rooms').doc(roomId);
    final answerMap = <String, dynamic>{
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    };
    await roomRef.update(answerMap);
  }

  // Add a candidate to the room's candidate collection
  static Future<void> addCandidateToRoom({
    required String roomId,
    required RTCIceCandidate candidate,
    required String userId,
  }) async {
    final roomRef = FirebaseFirestore.instance.collection('video_call_rooms').doc(roomId);
    final candidatesCollection = roomRef.collection('candidates');
    await candidatesCollection.add(candidate.toMap()..['uid'] = userId);
  }

  // Stream to get room data (answer) as a stream
  static Stream<RTCSessionDescription?> getRoomDataStream({required String roomId}) {
    final snapshots = FirebaseFirestore.instance.collection('video_call_rooms').doc(roomId).snapshots();
    return snapshots.map((snapshot) {
      final data = snapshot.data();
      return data != null && data['answer'] != null
          ? RTCSessionDescriptionHelper.fromMap(data['answer'])
          : null;
    });
  }

  // Stream to get ICE candidates as a stream
  static Stream<List<RTCIceCandidate>> getCandidatesAddedToRoomStream({
    required String roomId,
    required String userId,
  }) {
    final snapshots = FirebaseFirestore.instance
        .collection('video_call_rooms')
        .doc(roomId)
        .collection('candidates')
        .where('uid', isNotEqualTo: userId)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
      }).toList();
    });
  }

  // Find an active room by userBId
  static Future<VideoCallRoom?> findActiveRoom(String userBId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('video_call_rooms')
        .where('members', arrayContains: userBId)
        .where('is_active', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return VideoCallRoom.fromFirestore(querySnapshot.docs.first);
    }
    return null;
  }
}
