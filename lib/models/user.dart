import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  const User(
      {required this.email,
      this.id = '',
      this.name = '',
      this.mobile = '',
      this.country = '',
      this.dateTime,
      this.howToKnow = '',
      this.password = '',
      this.rating = '',
      this.ratingCount = '',
      this.status = '',
      this.token = '',
      this.userType = '',
      this.isMentor = false});

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final Timestamp? dateTime;
  final String howToKnow;
  final String password;
  final String rating;
  final String ratingCount;
  final String status;
  final String token;
  final String userType;
  final bool isMentor;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        mobile,
        country,
        dateTime,
        howToKnow,
        password,
        rating,
        ratingCount,
        status,
        token,
        userType,
        isMentor
      ];

  static User fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        mobile: map['mobile'] as String? ?? '',
        dateTime: map['date_time'] as Timestamp?,
        isMentor: map['is_mentor'] == 0 ? false : true);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'date_time': dateTime,
      'is_mentor': isMentor == false ? 0 : 1
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      mobile: data['mobile'] as String? ?? '',
      country: data['country'] as String? ?? '',
      dateTime: data['date_time'] as Timestamp?,
      howToKnow: data['how_to_know'] as String? ?? '',
      password: data['password'] as String? ?? '',
      rating: data['rating'] as String? ?? '',
      ratingCount: data['rating_count'] as String? ?? '',
      status: data['status'] as String? ?? '',
      token: data['token'] as String? ?? '',
      userType: data['user_type'] as String? ?? '',
    );
  }

  static const empty = User(email: '');

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? country,
    Timestamp? dateTime,
    String? howToKnow,
    String? password,
    String? rating,
    String? ratingCount,
    String? status,
    String? token,
    String? userType,
    bool? isMentor,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      country: country ?? this.country,
      dateTime: dateTime ?? this.dateTime,
      howToKnow: howToKnow ?? this.howToKnow,
      password: password ?? this.password,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      token: token ?? this.token,
      userType: userType ?? this.userType,
      isMentor: isMentor ?? this.isMentor,
    );
  }
}
