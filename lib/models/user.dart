import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.photo,
    required this.creationDate,
  });

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String photo;
  final Timestamp creationDate;

  static final empty = User(
    id: '',
    name: '',
    email: '',
    mobile: '',
    photo: '',
    creationDate: Timestamp(0, 0),
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, name, email, mobile, photo, creationDate];

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] as String,
      photo: map['photo'] as String,
      creationDate: map['creation_date'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'photo': photo,
      'creation_date': creationDate,
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      photo: data['photo'] ?? '',
      creationDate: data['creation_date'] ?? Timestamp(0, 0),
    );
  }
}
