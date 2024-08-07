import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OTP extends Equatable {
  final String id;
  final String smsResponse;
  final String dateTime;
  final String ip;
  final String mobile;
  final String otp;
  final String user;
  final String status;
  final DocumentReference country;
  final DocumentReference otpType;

  const OTP({
    required this.id,
    required this.smsResponse,
    required this.dateTime,
    required this.ip,
    required this.mobile,
    required this.otp,
    required this.user,
    required this.status,
    required this.country,
    required this.otpType,
  });

  @override
  List<Object?> get props => [
        id,
        smsResponse,
        dateTime,
        ip,
        mobile,
        otp,
        user,
        status,
        country,
        otpType,
      ];

  static OTP fromMap(Map<String, dynamic> map) {
    return OTP(
      id: map['id'] as String,
      smsResponse: map['sms_response'] as String,
      dateTime: map['date_time'] as String,
      ip: map['ip'] as String,
      mobile: map['mobile'] as String,
      otp: map['otp'] as String,
      user: map['user'] as String,
      status: map['status'] as String,
      country: map['country']['value'] as DocumentReference,
      otpType: map['otp_type']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sms_response': smsResponse,
      'date_time': dateTime,
      'ip': ip,
      'mobile': mobile,
      'otp': otp,
      'user': user,
      'status': status,
      'country': {'value': country},
      'otp_type': {'value': otpType},
    };
  }

  factory OTP.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OTP(
      id: data['id'] ?? '',
      smsResponse: data['sms_response'] ?? '',
      dateTime: data['date_time'] ?? '',
      ip: data['ip'] ?? '',
      mobile: data['mobile'] ?? '',
      otp: data['otp'] ?? '',
      user: data['user'] ?? '',
      status: data['status'] ?? '',
      country: data['country']['value'] as DocumentReference,
      otpType: data['otp_type']['value'] as DocumentReference,
    );
  }
}
