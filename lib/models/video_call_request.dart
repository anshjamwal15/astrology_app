class VideoCallRequest {
  String userId;
  String userName;
  String callType;
  String roomId;

  VideoCallRequest({
    required this.userId,
    required this.userName,
    required this.callType,
    required this.roomId,
  });
}