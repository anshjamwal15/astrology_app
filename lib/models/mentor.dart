import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Mentor extends Equatable {
  final String id;
  final String? youtube;
  final String? secondMostSuccessfulMentoringExp;
  final String? mainProfession;
  final String? bankBranch;
  final String? whatSpecificExp;
  final String? city;
  final String? mostSuccessfulMentoringExp;
  final String rating;
  final String? linkedin;
  final String? elevatorPitch;
  final String? password;
  final Timestamp? dateTime;
  final String? banAccount;
  final String? bankName;
  final String? currency;
  final String? ifsc;
  final String firstName;
  final String email;
  final String? address;
  final int totalExpYrs;
  final String? facebook;
  final String? mobile;
  final String lastName;
  final String? photo;
  final String? displayName;
  final String? highestQualification;
  final int? ratingCount;
  final String? upi;
  final String? nationality;
  final String userId;
  final String? userName;
  final String? x;
  final String? country;
  final String status;
  final String? gender;
  final String? languages;
  final String? pincode;
  final String? howToKnow;
  final String? currentEmployment;
  final String skillSet;
  final MentorRate? mentorRate;

  const Mentor({
    required this.id,
    this.youtube,
    this.secondMostSuccessfulMentoringExp,
    this.mainProfession,
    this.bankBranch,
    this.whatSpecificExp,
    this.city,
    this.mostSuccessfulMentoringExp,
    required this.rating,
    this.linkedin,
    this.elevatorPitch,
    this.password,
    this.dateTime,
    this.banAccount,
    this.bankName,
    this.currency,
    this.ifsc,
    required this.firstName,
    required this.email,
    this.address,
    required this.totalExpYrs,
    this.facebook,
    this.mobile,
    required this.lastName,
    this.photo,
    this.displayName,
    this.highestQualification,
    this.ratingCount,
    this.upi,
    this.nationality,
    required this.userId,
    this.userName,
    this.x,
    this.country,
    required this.status,
    this.gender,
    this.languages,
    this.pincode,
    this.howToKnow,
    this.currentEmployment,
    required this.skillSet,
    this.mentorRate
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
    userName,
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

  static Future<Mentor> initialDataFromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final user = await getRefDocumentData(data['user_id']);
    final status = await getRefDocumentData(data['status']);
    final skillSet = await getRefDocumentData(data['skill_set']);
    final mentorRate = await UserRepository().getMentorRates(data['id']);
    return Mentor(
      id: data['id'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      userId: await user?['id'] ?? '',
      rating: data['rating'].toString(),
      skillSet: await skillSet?['title'] ?? '',
      status: await status?['title'] ?? '',
      totalExpYrs: data['total_exp_yrs'] ?? 0,
      mentorRate: mentorRate
    );
  }

  static Future<Mentor> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final user = await getRefDocumentData(data['user_id']);
    final country = await getRefDocumentData(data['country']);
    final status = await getRefDocumentData(data['status']);
    final gender = await getRefDocumentData(data['gender']);
    final languages = await getRefDocumentData(data['languages']);
    final pincode = await getRefDocumentData(data['pincode']);
    final howToKnow = await getRefDocumentData(data['how_to_know']);
    final currentEmployment = await getRefDocumentData(data['current_employment']);
    final skillSet = await getRefDocumentData(data['skill_set']);
    final mentorRate = await UserRepository().getMentorRates(data['id']);
    return Mentor(
      id: data['id'] ?? '',
      youtube: data['youtube'] ?? '',
      secondMostSuccessfulMentoringExp: data['second_most_successful_mentoring_exp'] ?? '',
      mainProfession: data['main_profession'] ?? '',
      bankBranch: data['bank_branch'] ?? '',
      whatSpecificExp: data['what_specific_exp'] ?? '',
      city: data['city'] ?? '',
      mostSuccessfulMentoringExp: data['most_successful_mentoring_exp'] ?? '',
      rating: data['rating'].toString(),
      linkedin: data['linkedin'] ?? '',
      elevatorPitch: data['elevator_pitch'] ?? '',
      password: data['password'] ?? '',
      dateTime: data['date_time'],
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
      ratingCount: data['rating_count'],
      upi: data['upi'] ?? '',
      nationality: data['nationality'] ?? '',
      userName: await user?['name'] ?? '',
      userId: await user?['id'] ?? '',
      x: data['x'] ?? '',
      country: await country?['name'] ?? '',
      status: await status?['title'] ?? '',
      gender: filterTrueValues(gender!),
      languages: await languages?['language'] ?? '',
      pincode: (await pincode?['pincode']).toString(),
      howToKnow: await howToKnow?['title'] ?? '',
      currentEmployment: filterTrueValues(currentEmployment!),
      skillSet: await skillSet?['title'] ?? '',
      mentorRate: mentorRate
    );
  }


}
