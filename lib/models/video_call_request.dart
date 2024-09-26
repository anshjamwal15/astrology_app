class CallRequest {
  String userId;
  String creatorId;
  String userName;
  String? mentorName;
  String callType;
  String roomId;

  CallRequest({
    required this.userId,
    required this.creatorId,
    required this.userName,
    this.mentorName,
    required this.callType,
    required this.roomId,
  });
}