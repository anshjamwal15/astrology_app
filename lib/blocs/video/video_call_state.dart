part of 'video_call_bloc.dart';

abstract class VideoCallState {}

class VideoCallInitial extends VideoCallState {}

class VideoCallMediaOpened extends VideoCallState {}

class VideoCallRoomCreated extends VideoCallState {
  final String roomId;

  VideoCallRoomCreated({required this.roomId});
}

class VideoCallJoined extends VideoCallState {}

class VideoCallEnded extends VideoCallState {}
