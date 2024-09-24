import 'package:astrology_app/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);
typedef IceConnectionStateCallback = void Function(RTCIceGatheringState state);
typedef ConnectionStateCallback = void Function(RTCIceConnectionState state);

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
  IceConnectionStateCallback? onAddIceConnectionStream;
  ConnectionStateCallback? onAddConnectionStream;

  Future<String> createRoom(String roomId, MediaStream localStream,
      MediaStream remoteStream, bool isVideo) async {
    try {
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
            Map<String, dynamic> data =
                change.doc.data() as Map<String, dynamic>;
            if (kDebugMode) {
              // print('Got new remote ICE candidate: ${jsonEncode(data)}');
            }
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                // TODO: fix signaling server to send proper values for SDP media id
                // data['sdpMid'] ?? "video0",
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        }
      });
    } catch (e) {
      printError(e);
    }
    return roomId;
  }

  Future<void> joinRoom(String roomId, MediaStream localStream,
      MediaStream remoteStream, bool isVideo) async {
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

  Future<void> hangUp(String roomId, MediaStream localStream,
      MediaStream remoteStream, bool isVideo,
      [Timestamp? endedAt]) async {
    List<MediaStreamTrack> tracks = localStream.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    remoteStream.getTracks().forEach((track) => track.stop());
    if (peerConnection != null) peerConnection!.close();

    var db = FirebaseFirestore.instance;
    var roomName = isVideo ? "video_rooms" : "audio_rooms";
    var roomRef = db.collection(roomName).doc(roomId);

    // Fetch the current status of the call
    var callRef = db.collection('calls').doc(roomId);
    var callSnapshot = await callRef.get();

    if (callSnapshot.exists) {
      var currentStatus = callSnapshot['status'];

      if (currentStatus == 'active') {
        await callRef.update({
          'status': 'inactive',
          if (endedAt != null) 'endedAt': endedAt
        }).catchError((e) {
          printWarning('Error updating call status: $e');
        });
      }
    }

    // Clear candidates
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

  Future<String> createCallEntry(
    String roomId,
    String callerId,
    String calleeId,
  ) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference callRef = db.collection('calls').doc(roomId);

      // Create call entry in the 'calls' collection
      await callRef.set({
        'callerId': callerId,
        'calleeId': calleeId,
        'createdAt': Timestamp.now(),
        'status': 'active',
      }, SetOptions(merge: true));

      printWarning('Call entry created successfully $roomId');

      return roomId;
    } catch (e) {
      printWarning('Error creating call entry: $e');
      return "";
    }
  }

  Future<void> updateMediaStatusInCall(
      String roomId, String userType, bool? isCameraOn, bool? isMicOn,
      [String? callerId, String? calleeId]) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference callRef = db.collection('calls').doc(roomId);

      // Get the current call status
      DocumentSnapshot callDoc = await callRef.get();

      if (callDoc.exists) {
        Map<String, dynamic> callData = callDoc.data() as Map<String, dynamic>;
        String callStatus = callData['status'];

        if (callStatus == "active") {
          DocumentReference mediaStatusRef = callRef
              .collection('media_status')
              .doc(userType == "caller" ? callerId : calleeId);

          // Define the media status update object
          Map<String, dynamic> mediaStatus = {
            if (isCameraOn != null) 'isCameraOn': isCameraOn,
            if (isMicOn != null) 'isMicOn': isMicOn,
            'updatedAt': Timestamp.now(),
            'userType': userType,
          };

          await mediaStatusRef.set(mediaStatus, SetOptions(merge: true));

          printWarning('Media status updated successfully in calls collection');
        } else {
          printWarning(('Call is not active, not updating media status.'));
        }
      } else {
        printWarning('Call document does not exist.');
      }
    } catch (e) {
      printWarning('Error updating media status: $e');
    }
  }

  Stream<Map<String, dynamic>?> listenToStatus(
    String roomId,
    String userType,
    String? callerId,
    String? calleeId,
  ) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference callRef = db.collection('calls').doc(roomId);

    // Listen to the call's main document to check if the status is 'active'
    return callRef.snapshots().asyncExpand((callDoc) async* {
      if (callDoc.exists) {
        Map<String, dynamic> callData = callDoc.data() as Map<String, dynamic>;

        // Check if the call status is 'active'
        if (callData['status'] == 'active') {
          // Determine the media document reference based on the userType
          String? mediaDocId = userType == "caller" ? callerId : calleeId;
          if (mediaDocId != null) {
            // Now listen to media status updates only for active calls
            yield* callRef
                .collection('media_status')
                .doc(mediaDocId)
                .snapshots()
                .map((snapshot) {
              if (snapshot.exists) {
                return snapshot.data() as Map<String, dynamic>?;
              }
              return null;
            });
          } else {
            yield null;
          }
        } else {
          yield null;
        }
      } else {
        yield null;
      }
    });
  }

  void registerPeerConnectionListeners(MediaStream remoteStream) {
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (kDebugMode) {
        print('Connection state change: $state');
      }
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      if (kDebugMode) {
        print('Signaling state change: $state');
      }
    };

    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      if (kDebugMode) {
        print('ICE connection state change: $state');
        if (onAddConnectionStream != null) {
          onAddConnectionStream?.call(state);
        }
      }
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      if (kDebugMode) {
        print('ICE gathering state change: $state');
        if (onAddIceConnectionStream != null) {
          onAddIceConnectionStream?.call(state);
        }
      }
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
