import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Slider extends Equatable {
  final String id;
  final String dateTimeFrom;
  final String dateTimeTo;
  final String image;
  final String code;
  final String url;
  final String order;
  final String status;

  const Slider({
    required this.id,
    required this.dateTimeFrom,
    required this.dateTimeTo,
    required this.image,
    required this.code,
    required this.url,
    required this.order,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        dateTimeFrom,
        dateTimeTo,
        image,
        code,
        url,
        order,
        status,
      ];

  static Slider fromMap(Map<String, dynamic> map) {
    return Slider(
      id: map['id'] as String,
      dateTimeFrom: map['date_time_from'] as String,
      dateTimeTo: map['date_time_to'] as String,
      image: map['image'] as String,
      code: map['code'] as String,
      url: map['url'] as String,
      order: map['order'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time_from': dateTimeFrom,
      'date_time_to': dateTimeTo,
      'image': image,
      'code': code,
      'url': url,
      'order': order,
      'status': status,
    };
  }

  factory Slider.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Slider(
      id: data['id'] ?? '',
      dateTimeFrom: data['date_time_from'] ?? '',
      dateTimeTo: data['date_time_to'] ?? '',
      image: data['image'] ?? '',
      code: data['code'] ?? '',
      url: data['url'] ?? '',
      order: data['order'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
