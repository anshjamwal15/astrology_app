import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class SignalingService {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
          'stun:stun.1und1.de:3478',
          'stun:stun.gmx.net:3478',
          'stun:stun.l.google.com:19302',
          'stun:stun3.l.google.com:19302',
          'stun:stun4.l.google.com:19302',
          'stun:23.21.150.121:3478',
          'stun:stun.12connect.com:3478',
          'stun:stun.12voip.com:3478'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  RTCPeerConnectionState? connectionState;
  RTCIceGatheringState? iceGatheringState;
  RTCIceConnectionState? iceConnectionState;

  Future<String> createRoom(
    String roomId,
    MediaStream localStream,
    MediaStream remoteStream,
      bool isVideo
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var roomName = isVideo ? "video_rooms" : "audio_rooms";
    DocumentReference roomRef = db.collection(roomName).doc(roomId);

    if (kDebugMode) {
      print('Create PeerConnection with configuration: $configuration');
    }

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners(remoteStream);

    localStream.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      if (kDebugMode) {
        print('Got candidate: ${candidate.toMap()}');
      }
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    if (kDebugMode) {
      print('Created offer: $offer');
    }

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    if (kDebugMode) {
      // print('New room created with SDK offer. Room ID: $roomId');
    }
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      if (kDebugMode) {
        // print('Got remote track: ${event.streams[0]}');
      }

      event.streams[0].getTracks().forEach((track) {
        if (kDebugMode) {
          // print('Add a track to the remoteStream $track');
        }
        remoteStream.addTrack(track);
      });
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      if (kDebugMode) {
        // print('Got updated room: ${snapshot.data()}');
      }

      if (snapshot.data() == null) return;

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        if (kDebugMode) {
          print("Someone tried to connect");
        }
        await peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          if (kDebugMode) {
            // print('Got new remote ICE candidate: ${jsonEncode(data)}');
          }
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
    return roomId;
  }

  Future<void> joinRoom(
    String roomId,
    MediaStream localStream,
    MediaStream remoteStream,
      bool isVideo
  ) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var roomName = isVideo ? "video_rooms" : "audio_rooms";
    DocumentReference roomRef = db.collection(roomName).doc(roomId);
    var roomSnapshot = await roomRef.get();
    if (kDebugMode) {
      // print('Got room ${roomSnapshot.exists}');
    }

    if (roomSnapshot.exists) {
      if (kDebugMode) {
        // print('Create PeerConnection with configuration: $configuration');
      }
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners(remoteStream);

      localStream.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          if (kDebugMode) {
            // print('onIceCandidate: complete!');
          }
          return;
        }
        if (kDebugMode) {
          print('onIceCandidate: ${candidate.toMap()}');
        }
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        if (kDebugMode) {
          // print('Got remote track: ${event.streams[0]}');
        }
        event.streams[0].getTracks().forEach((track) {
          if (kDebugMode) {
            // print('Add a track to the remoteStream: $track');
          }
          remoteStream.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      if (kDebugMode) {
        // print('Got offer $data');
      }
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      if (kDebugMode) {
        // print('Created Answer $answer');
      }

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          if (kDebugMode) {
            // print('Got new remote ICE candidate: $data');
          }
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    }
  }

  Future<void> hangUp(
    String roomId,
    MediaStream localStream,
    MediaStream remoteStream,
      bool isVideo
  ) async {
    List<MediaStreamTrack> tracks = localStream.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    remoteStream.getTracks().forEach((track) => track.stop());
      if (peerConnection != null) peerConnection!.close();

    var db = FirebaseFirestore.instance;
    var roomName = isVideo ? "video_rooms" : "audio_rooms";
    var roomRef = db.collection(roomName).doc(roomId);
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    for (var document in calleeCandidates.docs) {
      document.reference.delete();
    }

    var callerCandidates = await roomRef.collection('callerCandidates').get();
    for (var document in callerCandidates.docs) {
      document.reference.delete();
    }

    await roomRef.delete();

    localStream.dispose();
    remoteStream.dispose();
  }

  Future<void> updateMediaStatus(String roomId, String userType, {bool? isCameraOn, bool? isMicOn}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('video_rooms').doc(roomId);

    var roomSnapshot = await roomRef.get();
    if (!roomSnapshot.exists) {
      if (kDebugMode) {
        print('Room does not exist: $roomId');
      }
      return;
    }

    String collectionPath = userType == 'caller' ? 'callerCandidates' : 'calleeCandidates';
    DocumentReference mediaStatusRef = roomRef.collection(collectionPath).doc('mediaStatus');

    Map<String, dynamic> updates = {};

    if (isCameraOn != null) {
      updates['camera'] = isCameraOn;
    }

    if (isMicOn != null) {
      updates['microphone'] = isMicOn;
    }

    if (updates.isNotEmpty) {
      await mediaStatusRef.update(updates);

      if (kDebugMode) {
        print('$userType media status updated: Camera - $isCameraOn, Mic - $isMicOn');
      }
    }
  }


  Stream<bool> checkRoomExists(String roomId) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('video_rooms').doc(roomId);

    return roomRef.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        if (kDebugMode) {
          print('Room does not exist: $roomId');
        }
        return false;
      }
      return true;
    });
  }


  Stream<Map<String, dynamic>?> listenToStatus(String roomId, String userType) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('video_rooms').doc(roomId);
    String collectionPath = userType == 'caller' ? 'calleeCandidates' : 'callerCandidates';
    return roomRef.collection(collectionPath).doc('mediaStatus').snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
      return null;
    });
  }


  void registerPeerConnectionListeners(MediaStream remoteStream) {

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (kDebugMode) {
        print('Connection state change: $state');
      }
      connectionState = state;
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      if (kDebugMode) {
        print('Signaling state change: $state');
      }
    };

    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      if (kDebugMode) {
        print('ICE connection state change: $state');
      }
      iceConnectionState = state;
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      if (kDebugMode) {
        print('ICE gathering state change: $state');
      }
      iceGatheringState = state;
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      if (kDebugMode) {
        print("Add remote stream");
      }
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
}
