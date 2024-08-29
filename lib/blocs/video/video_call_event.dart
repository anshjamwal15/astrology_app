part of 'video_call_bloc.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

class OpenUserMedia extends VideoCallEvent {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  const OpenUserMedia({required this.localRenderer, required this.remoteRenderer});
}

class CreateRoom extends VideoCallEvent {
  final RTCVideoRenderer remoteRenderer;
  final String roomId;

  const CreateRoom({required this.roomId, required this.remoteRenderer});
}

class JoinRoom extends VideoCallEvent {
  final RTCVideoRenderer remoteRenderer;
  final String mentorId;

  const JoinRoom({required this.remoteRenderer, required this.mentorId});
}

class HangUp extends VideoCallEvent {
  final String roomId;
  final RTCVideoRenderer localRenderer;

  const HangUp({required this.roomId, required this.localRenderer});
}
