part of 'video_call_bloc.dart';

abstract class WebRTCEvent {}

class InitializeWebRTC extends WebRTCEvent {}

class CreateOffer extends WebRTCEvent {
  final String userIdA;
  final String userIdB;

  CreateOffer(this.userIdA, this.userIdB);
}

class JoinRoom extends WebRTCEvent {
  final String userId;
  JoinRoom(this.userId);
}

class AddCandidate extends WebRTCEvent {
  final RTCIceCandidate candidate;
  AddCandidate(this.candidate);
}

class StartCall extends WebRTCEvent {}

class EndCall extends WebRTCEvent {}
