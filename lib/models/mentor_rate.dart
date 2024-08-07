import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MentorRate extends Equatable {
  final String id;
  final String mentorId;
  final int videoMRate;
  final int chatMRate;
  final int chatRate;
  final int audioMRate;
  final int audioRate;
  final int videoRate;
  final Timestamp validFrom;
  final Timestamp validTo;
  final Timestamp dateTime;
  final String timings;
  final String currency;
  final String day;
  final String status;

  const MentorRate({
    required this.id,
    required this.mentorId,
    required this.videoMRate,
    required this.chatMRate,
    required this.chatRate,
    required this.audioMRate,
    required this.audioRate,
    required this.videoRate,
    required this.validFrom,
    required this.validTo,
    required this.dateTime,
    required this.timings,
    required this.currency,
    required this.day,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        mentorId,
        videoMRate,
        chatMRate,
        chatRate,
        audioMRate,
        audioRate,
        videoRate,
        validFrom,
        validTo,
        dateTime,
        timings,
        currency,
        day,
        status
      ];

  static MentorRate fromMap(Map<String, dynamic> map) {
    return MentorRate(
      id: map['id'] as String,
      mentorId: map['mentor_id']['value'] as String,
      videoMRate: map['video_mrate'] as int,
      chatMRate: int.tryParse(map['chat_mrate'] as String) ?? 0,
      chatRate: map['chate_rate'] as int,
      audioMRate: map['audio_mrate'] as int,
      audioRate: map['audio_rate'] as int,
      videoRate: map['video_rate'] as int,
      validFrom: map['valid_from']['value'] as Timestamp,
      validTo: map['valid_to']['value'] as Timestamp,
      dateTime: map['date_time']['value'] as Timestamp,
      timings: map['timings'] as String,
      currency: map['currency'] as String,
      day: map['day'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mentor_id': {'value': mentorId},
      'video_mrate': videoMRate,
      'chat_mrate': chatMRate.toString(),
      'chate_rate': chatRate,
      'audio_mrate': audioMRate,
      'audio_rate': audioRate,
      'video_rate': videoRate,
      'valid_from': validFrom,
      'valid_to': validTo,
      'date_time': dateTime,
      'timings': timings,
      'currency': currency,
      'day': day,
      'status': status,
    };
  }

  factory MentorRate.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MentorRate(
      id: data['id'] ?? '',
      mentorId: data['mentor_id']['value'] as String,
      videoMRate: data['video_mrate'] ?? 0,
      chatMRate: int.tryParse(data['chat_mrate'] as String) ?? 0,
      chatRate: data['chate_rate'] ?? 0,
      audioMRate: data['audio_mrate'] ?? 0,
      audioRate: data['audio_rate'] ?? 0,
      videoRate: data['video_rate'] ?? 0,
      validFrom: data['valid_from']['value'] as Timestamp,
      validTo: data['valid_to']['value'] as Timestamp,
      dateTime: data['date_time']['value'] as Timestamp,
      timings: data['timings'] ?? '',
      currency: data['currency'] ?? '',
      day: data['day'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
