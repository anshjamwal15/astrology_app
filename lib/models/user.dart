import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  const User({
    required this.email,
    this.id = '',
    this.name = '',
    this.mobile = '',
    this.photo = '',
    this.creationDate,
  });

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String photo;
  final Timestamp? creationDate;

  static const empty = User(
    email: '',
    id: '',
    name: '',
    mobile: '',
    photo: '',
    creationDate: null,
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, name, email, mobile, photo, creationDate];

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      mobile: map['mobile'] as String? ?? '',
      photo: map['photo'] as String? ?? '',
      creationDate: map['creation_date'] as Timestamp?,
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
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      mobile: data['mobile'] as String? ?? '',
      photo: data['photo'] as String? ?? '',
      creationDate: data['creation_date'] as Timestamp?,
    );
  }
}
