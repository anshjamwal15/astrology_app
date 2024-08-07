import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Gender extends Equatable {
  final bool dontWantToSpecify;
  final bool female;
  final bool male;
  final bool transgender;

  const Gender({
    required this.dontWantToSpecify,
    required this.female,
    required this.male,
    required this.transgender,
  });

  @override
  List<Object?> get props => [dontWantToSpecify, female, male, transgender];

  static Gender fromMap(Map<String, dynamic> map) {
    return Gender(
      dontWantToSpecify: map['dont_want_to_specify'] as bool,
      female: map['female'] as bool,
      male: map['male'] as bool,
      transgender: map['transgender'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dont_want_to_specify': dontWantToSpecify,
      'female': female,
      'male': male,
      'transgender': transgender,
    };
  }

  factory Gender.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Gender(
      dontWantToSpecify: data['dont_want_to_specify'] ?? false,
      female: data['female'] ?? false,
      male: data['male'] ?? false,
      transgender: data['transgender'] ?? false,
    );
  }
}
