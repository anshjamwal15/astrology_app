class VideoCallRequest {
  String userId;
  String creatorId;
  String userName;
  String callType;
  String roomId;

  VideoCallRequest({
    required this.userId,
    required this.creatorId,
    required this.userName,
    required this.callType,
    required this.roomId,
  });
}