import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/utils/firebase_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class WebRTCBloc extends Bloc<WebRTCEvent, WebRTCState> {
  final FirebaseDataSource _firebaseDataSource;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  WebRTCBloc(this._firebaseDataSource) : super(WebRTCState()) {
    on<InitializeWebRTC>(_onInitializeWebRTC);
    on<CreateOffer>(_onCreateOffer);
    on<JoinRoom>(_onJoinRoom);
    on<EndCall>(_onEndCall);
  }

  static const Map<String, dynamic> _configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ],
      },
    ],
  };

  Future<void> _onInitializeWebRTC(InitializeWebRTC event, Emitter<WebRTCState> emit) async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _onCreateOffer(CreateOffer event, Emitter<WebRTCState> emit) async {
    // Step 1: Get media from the device (camera and microphone)
    final localStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});

    // Step 2: Create the peer connection
    final peerConnection = await createPeerConnection(_configuration);

    // Step 3: Add tracks from the local stream to the peer connection
    for (MediaStreamTrack track in localStream.getTracks()) {
      peerConnection.addTrack(track, localStream);
    }
    // Update state with peer connection and local stream
    WebRTCState state = WebRTCState(peerConnection: peerConnection, localStream: localStream);

    // Step 4: Create an offer
    final offer = await peerConnection.createOffer();


    // Step 5: Save the offer in the database
    final roomId = await VideoCallRoom.createRoom(event.userIdA, event.userIdB, offer);

    // Step 6: Set the offer as a local description
    await peerConnection.setLocalDescription(offer);

    // Step 7: Set event listeners
    peerConnection.onTrack = (RTCTrackEvent event) {
      state = state.copyWith(remoteStream: event.streams[0]);
    };

    // Step 8: Generate ICE candidates and save them in the database
    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      VideoCallRoom.addCandidateToRoom(roomId: roomId, candidate: candidate, userId: event.userIdA);
    };

    // Step 9: Listen for an answer in the database
    VideoCallRoom.getRoomDataStream(roomId: roomId).listen((answer) async {
      if (answer != null) {
        await state.peerConnection?.setRemoteDescription(answer);
        state = state.copyWith(isCallActive: true);
      } else {
        state = WebRTCState();
      }
    });

    VideoCallRoom.getCandidatesAddedToRoomStream(roomId: roomId, userId: event.userIdA).listen(
          (candidates) {
        for (final candidate in candidates) {
          state.peerConnection?.addCandidate(candidate);
        }
      },
    );
    emit(state);
  }


  Future<void> _onJoinRoom(JoinRoom event, Emitter<WebRTCState> emit) async {
  //   final room = await VideoCallRoom.findActiveRoom(event.userId);
  //
  //   if (room != null && room.offer != null) {
  //     final peerConnection = await createPeerConnection(_configuration);
  //     emit(state.copyWith(peerConnection: peerConnection));
  //
  //     final stream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
  //     emit(state.copyWith(localStream: stream));
  //
  //     state.localStream?.getTracks().forEach((track) {
  //       state.peerConnection?.addTrack(track, state.localStream!);
  //     });
  //
  //     await state.peerConnection!.setRemoteDescription(room.offer!);
  //
  //     final answer = await state.peerConnection!.createAnswer();
  //     await state.peerConnection!.setLocalDescription(answer);
  //     await FirebaseFirestore.instance
  //         .collection('video_call_rooms')
  //         .doc(room.roomId)
  //         .update({'answer': answer.toMap()});
  //
  //     _registerPeerConnectionListeners(room.roomId, emit);
  //     emit(state.copyWith(isCallActive: true));
  //   }
  }

  void _registerPeerConnectionListeners(String roomId, WebRTCState state) {
    print(state.peerConnection?.iceConnectionState);
    state.peerConnection?.onIceCandidate = (candidate) {
      _firebaseDataSource.addCandidateToRoom(roomId: roomId, candidate: candidate);
    };

    state.peerConnection?.onTrack = (event) {
      final remoteStream = event.streams[0];
      remoteStream.getTracks().forEach((track) {
        state.remoteStream?.addTrack(track);
      });
      state = state.copyWith(remoteStream: remoteStream);
    };

    _firebaseDataSource.getRoomDataStream(roomId: roomId).listen((answer) async {
      if (answer != null) {
        await state.peerConnection?.setRemoteDescription(answer);
        state = state.copyWith(isCallActive: true);
      } else {
        state = WebRTCState();
      }
    });

    _firebaseDataSource.getCandidatesAddedToRoomStream(roomId: roomId, listenCaller: false).listen(
          (candidates) {
        for (final candidate in candidates) {
          state.peerConnection?.addCandidate(candidate);
        }
      },
    );
  }


  Future<void> _onEndCall(EndCall event, Emitter<WebRTCState> emit) async {
    state.peerConnection?.close();
    emit(WebRTCState());  // Reset the state
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
  }

  @override
  Future<void> close() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    state.peerConnection?.close();
    return super.close();
  }
}
