import 'package:astrology_app/services/signaling_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'video_call_state.dart';
part 'video_call_event.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final Signaling signaling;

  VideoCallBloc({required this.signaling}) : super(VideoCallInitial()) {
    on<OpenUserMedia>(_onOpenUserMedia);
    on<CreateRoom>(_onCreateRoom);
    on<JoinRoom>(_onJoinRoom);
    on<HangUp>(_onHangUp);
  }

  void _onOpenUserMedia(OpenUserMedia event, Emitter<VideoCallState> emit) async {
    await signaling.openUserMedia(event.localRenderer, event.remoteRenderer);
    emit(VideoCallMediaOpened());
  }

  void _onCreateRoom(CreateRoom event, Emitter<VideoCallState> emit) async {
    final roomId = await signaling.createRoom(event.roomId, event.remoteRenderer);
    emit(VideoCallRoomCreated(roomId: roomId));
  }

  void _onJoinRoom(JoinRoom event, Emitter<VideoCallState> emit) async {
    await signaling.joinRoom(event.mentorId, event.remoteRenderer);
    emit(VideoCallJoined());
  }

  void _onHangUp(HangUp event, Emitter<VideoCallState> emit) async {
    await signaling.hangUp(event.roomId, event.localRenderer);
    emit(VideoCallEnded());
  }
}
