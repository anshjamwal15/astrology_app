import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String dateTimeLogin;
  final String dateTimeLogout;
  final String ip;
  final String gps;
  final String user;
  final DocumentReference loginType;

  const Session({
    required this.id,
    required this.dateTimeLogin,
    required this.dateTimeLogout,
    required this.ip,
    required this.gps,
    required this.user,
    required this.loginType,
  });

  @override
  List<Object?> get props => [
        id,
        dateTimeLogin,
        dateTimeLogout,
        ip,
        gps,
        user,
        loginType,
      ];

  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as String,
      dateTimeLogin: map['date_time_login'] as String,
      dateTimeLogout: map['date_time_logout'] as String,
      ip: map['ip'] as String,
      gps: map['gps'] as String,
      user: map['user'] as String,
      loginType: map['login_type']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time_login': dateTimeLogin,
      'date_time_logout': dateTimeLogout,
      'ip': ip,
      'gps': gps,
      'user': user,
      'login_type': {'value': loginType},
    };
  }

  factory Session.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Session(
      id: data['id'] ?? '',
      dateTimeLogin: data['date_time_login'] ?? '',
      dateTimeLogout: data['date_time_logout'] ?? '',
      ip: data['ip'] ?? '',
      gps: data['gps'] ?? '',
      user: data['user'] ?? '',
      loginType: data['login_type']['value'] as DocumentReference,
    );
  }
}
