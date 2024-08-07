import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Mentor extends Equatable {
  final String id;
  final String youtube;
  final String secondMostSuccessfulMentoringExp;
  final String mainProfession;
  final String bankBranch;
  final String whatSpecificExp;
  final String city;
  final String mostSuccessfulMentoringExp;
  final String rating;
  final String linkedin;
  final String elevatorPitch;
  final String password;
  final Timestamp dateTime;
  final String banAccount;
  final String bankName;
  final String currency;
  final String ifsc;
  final String firstName;
  final String email;
  final String address;
  final int totalExpYrs;
  final String facebook;
  final String mobile;
  final String lastName;
  final String photo;
  final String displayName;
  final String highestQualification;
  final int ratingCount;
  final String upi;
  final String nationality;
  final String userId;
  final String x;
  final DocumentReference country;
  final DocumentReference status;
  final DocumentReference gender;
  final DocumentReference languages;
  final DocumentReference pincode;
  final DocumentReference howToKnow;
  final DocumentReference currentEmployment;
  final DocumentReference skillSet;

  const Mentor({
    required this.id,
    required this.youtube,
    required this.secondMostSuccessfulMentoringExp,
    required this.mainProfession,
    required this.bankBranch,
    required this.whatSpecificExp,
    required this.city,
    required this.mostSuccessfulMentoringExp,
    required this.rating,
    required this.linkedin,
    required this.elevatorPitch,
    required this.password,
    required this.dateTime,
    required this.banAccount,
    required this.bankName,
    required this.currency,
    required this.ifsc,
    required this.firstName,
    required this.email,
    required this.address,
    required this.totalExpYrs,
    required this.facebook,
    required this.mobile,
    required this.lastName,
    required this.photo,
    required this.displayName,
    required this.highestQualification,
    required this.ratingCount,
    required this.upi,
    required this.nationality,
    required this.userId,
    required this.x,
    required this.country,
    required this.status,
    required this.gender,
    required this.languages,
    required this.pincode,
    required this.howToKnow,
    required this.currentEmployment,
    required this.skillSet,
  });

  @override
  List<Object?> get props => [
    id,
    youtube,
    secondMostSuccessfulMentoringExp,
    mainProfession,
    bankBranch,
    whatSpecificExp,
    city,
    mostSuccessfulMentoringExp,
    rating,
    linkedin,
    elevatorPitch,
    password,
    dateTime,
    banAccount,
    bankName,
    currency,
    ifsc,
    firstName,
    email,
    address,
    totalExpYrs,
    facebook,
    mobile,
    lastName,
    photo,
    displayName,
    highestQualification,
    ratingCount,
    upi,
    nationality,
    userId,
    x,
    country,
    status,
    gender,
    languages,
    pincode,
    howToKnow,
    currentEmployment,
    skillSet,
  ];

  static Mentor fromMap(Map<String, dynamic> map) {
    return Mentor(
      id: map['id'] as String,
      youtube: map['youtube'] as String,
      secondMostSuccessfulMentoringExp: map['second_most_successful_mentoring_exp'] as String,
      mainProfession: map['main_profession'] as String,
      bankBranch: map['bank_branch'] as String,
      whatSpecificExp: map['what_specific_exp'] as String,
      city: map['city'] as String,
      mostSuccessfulMentoringExp: map['most_successful_mentoring_exp'] as String,
      rating: map['rating'] as String,
      linkedin: map['linkedin'] as String,
      elevatorPitch: map['elevator_pitch'] as String,
      password: map['password'] as String,
      dateTime: map['date_time']['value'] as Timestamp,
      banAccount: map['ban_account'] as String,
      bankName: map['bank_name'] as String,
      currency: map['currency'] as String,
      ifsc: map['ifsc'] as String,
      firstName: map['first_name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      totalExpYrs: map['total_exp_yrs'] as int,
      facebook: map['facebook'] as String,
      mobile: map['mobile'] as String,
      lastName: map['last_name'] as String,
      photo: map['photo'] as String,
      displayName: map['display_name'] as String,
      highestQualification: map['highest_qualification'] as String,
      ratingCount: map['rating_count'] as int,
      upi: map['upi'] as String,
      nationality: map['nationality'] as String,
      userId: map['user_id'] as String,
      x: map['x'] as String,
      country: map['country']['value'] as DocumentReference,
      status: map['status']['value'] as DocumentReference,
      gender: map['gender']['value'] as DocumentReference,
      languages: map['languages']['value'] as DocumentReference,
      pincode: map['pincode']['value'] as DocumentReference,
      howToKnow: map['how_to_know']['value'] as DocumentReference,
      currentEmployment: map['current_employment']['value'] as DocumentReference,
      skillSet: map['skill_set']['value'] as DocumentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'youtube': youtube,
      'second_most_successful_mentoring_exp': secondMostSuccessfulMentoringExp,
      'main_profession': mainProfession,
      'bank_branch': bankBranch,
      'what_specific_exp': whatSpecificExp,
      'city': city,
      'most_successful_mentoring_exp': mostSuccessfulMentoringExp,
      'rating': rating,
      'linkedin': linkedin,
      'elevator_pitch': elevatorPitch,
      'password': password,
      'date_time': dateTime,
      'ban_account': banAccount,
      'bank_name': bankName,
      'currency': currency,
      'ifsc': ifsc,
      'first_name': firstName,
      'email': email,
      'address': address,
      'total_exp_yrs': totalExpYrs,
      'facebook': facebook,
      'mobile': mobile,
      'last_name': lastName,
      'photo': photo,
      'display_name': displayName,
      'highest_qualification': highestQualification,
      'rating_count': ratingCount,
      'upi': upi,
      'nationality': nationality,
      'user_id': userId,
      'x': x,
      'country': country,
      'status': status,
      'gender': gender,
      'languages': languages,
      'pincode': pincode,
      'how_to_know': howToKnow,
      'current_employment': currentEmployment,
      'skill_set': skillSet,
    };
  }

  factory Mentor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mentor(
      id: data['id'] ?? '',
      youtube: data['youtube'] ?? '',
      secondMostSuccessfulMentoringExp: data['second_most_successful_mentoring_exp'] ?? '',
      mainProfession: data['main_profession'] ?? '',
      bankBranch: data['bank_branch'] ?? '',
      whatSpecificExp: data['what_specific_exp'] ?? '',
      city: data['city'] ?? '',
      mostSuccessfulMentoringExp: data['most_successful_mentoring_exp'] ?? '',
      rating: data['rating'] ?? '',
      linkedin: data['linkedin'] ?? '',
      elevatorPitch: data['elevator_pitch'] ?? '',
      password: data['password'] ?? '',
      dateTime: data['date_time']['value'],
      banAccount: data['ban_account'] ?? '',
      bankName: data['bank_name'] ?? '',
      currency: data['currency'] ?? '',
      ifsc: data['ifsc'] ?? '',
      firstName: data['first_name'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      totalExpYrs: data['total_exp_yrs'] ?? 0,
      facebook: data['facebook'] ?? '',
      mobile: data['mobile'] ?? '',
      lastName: data['last_name'] ?? '',
      photo: data['photo'] ?? '',
      displayName: data['display_name'] ?? '',
      highestQualification: data['highest_qualification'] ?? '',
      ratingCount: data['rating_count'] ?? 0,
      upi: data['upi'] ?? '',
      nationality: data['nationality'] ?? '',
      userId: data['user_id'] ?? '',
      x: data['x'] ?? '',
      country: data['country']['value'],
      status: data['status']['value'],
      gender: data['gender']['value'],
      languages: data['languages']['value'],
      pincode: data['pincode']['value'],
      howToKnow: data['how_to_know']['value'],
      currentEmployment: data['current_employment']['value'],
      skillSet: data['skill_set']['value'],
    );
  }
}
