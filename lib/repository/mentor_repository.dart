import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentorRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Mentor?> getMentorById(String mentorId) async {
    final mentorRef = _firestore.collection('mentor').doc(mentorId);
    final doc = await mentorRef.get();
    if (doc.exists) {
      return Mentor.fromFirestore(doc);
    }
    return null;
  }

  Future<MentorRate?> getMentorRateById(String mentorId) async {
    final mentorRef = _firestore.collection('mentor').doc(mentorId);
    final querySnapshot = await _firestore
        .collection('mentor_rate')
        .where('mentor_id', isEqualTo: mentorRef)
        .get();
    printWarning(querySnapshot.docs);
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return MentorRate.fromFirestore(doc);
    }
    return null;
  }




}