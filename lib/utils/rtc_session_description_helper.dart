import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCSessionDescriptionHelper {
  static RTCSessionDescription fromMap(Map<String, dynamic> map) {
    return RTCSessionDescription(
      map['sdp'] as String,
      map['type'] as String,
    );
  }

  static Map<String, dynamic> toMap(RTCSessionDescription description) {
    return {
      'sdp': description.sdp,
      'type': description.type,
    };
  }
}
