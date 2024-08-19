import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  const User({
    required this.email,
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
  });

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
  ];

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      mobile: map['mobile'] as String? ?? '',
      dateTime: map['date_time'] as Timestamp?,
      // country: map['country'] as String? ?? '',
      // howToKnow: map['how_to_know'] as String? ?? '',
      // password: map['password'] as String? ?? '',
      // rating: map['rating'] as String? ?? '',
      // ratingCount: map['rating_count'] as String? ?? '',
      // status: map['status'] as String? ?? '',
      // token: map['token'] as String? ?? '',
      // userType: map['user_type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'date_time': dateTime,
      // 'country': country,
      // 'how_to_know': howToKnow,
      // 'password': password,
      // 'rating': rating,
      // 'rating_count': ratingCount,
      // 'status': status,
      // 'token': token,
      // 'user_type': userType,
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
}
