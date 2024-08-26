part of 'video_call_bloc.dart';

class WebRTCState {
  final RTCPeerConnection? peerConnection;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final bool isCallActive;

  WebRTCState({
    this.peerConnection,
    this.localStream,
    this.remoteStream,
    this.isCallActive = false,
  });

  WebRTCState copyWith({
    RTCPeerConnection? peerConnection,
    MediaStream? localStream,
    MediaStream? remoteStream,
    bool? isCallActive,
  }) {
    return WebRTCState(
      peerConnection: peerConnection ?? this.peerConnection,
      localStream: localStream ?? this.localStream,
      remoteStream: remoteStream ?? this.remoteStream,
      isCallActive: isCallActive ?? this.isCallActive,
    );
  }
}
