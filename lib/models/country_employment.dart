import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CurrentEmployment extends Equatable {
  final String id;
  final String notWorking;
  final String ownABusiness;
  final bool mentoringFullTime;
  final bool workingInOtherFieldFullTime;
  final bool workingInOtherFieldPartTime;

  const CurrentEmployment({
    required this.id,
    required this.notWorking,
    required this.ownABusiness,
    required this.mentoringFullTime,
    required this.workingInOtherFieldFullTime,
    required this.workingInOtherFieldPartTime,
  });

  @override
  List<Object?> get props => [id, notWorking, ownABusiness, mentoringFullTime, workingInOtherFieldFullTime, workingInOtherFieldPartTime];

  static CurrentEmployment fromMap(Map<String, dynamic> map) {
    return CurrentEmployment(
      id: map['id'] as String,
      notWorking: map['not_working'] as String,
      ownABusiness: map['own_a_business'] as String,
      mentoringFullTime: map['mentoring_full_time'] as bool,
      workingInOtherFieldFullTime: map['working_in_other_field_full_time'] as bool,
      workingInOtherFieldPartTime: map['working_in_other_field_part_time'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'not_working': notWorking,
      'own_a_business': ownABusiness,
      'mentoring_full_time': mentoringFullTime,
      'working_in_other_field_full_time': workingInOtherFieldFullTime,
      'working_in_other_field_part_time': workingInOtherFieldPartTime,
    };
  }

  factory CurrentEmployment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CurrentEmployment(
      id: data['id'] ?? '',
      notWorking: data['not_working'] ?? '',
      ownABusiness: data['own_a_business'] ?? '',
      mentoringFullTime: data['mentoring_full_time'] ?? false,
      workingInOtherFieldFullTime: data['working_in_other_field_full_time'] ?? false,
      workingInOtherFieldPartTime: data['working_in_other_field_part_time'] ?? false,
    );
  }
}
