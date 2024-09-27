import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_messaging/firebase_messaging.dart' as firebase;

class UserRepository {
  UserRepository({cf.FirebaseFirestore? firestore})
      : _firestore = firestore ?? cf.FirebaseFirestore.instance;

  final cf.FirebaseFirestore _firestore;
  final PaymentRepository _paymentRepository = PaymentRepository();

  Future<void> saveUser(User user) async {
    final userRef = _firestore.collection('users').doc(user.id);
    // TODO: don't update token everytime
    final userToken = await firebase.FirebaseMessaging.instance.getToken();

    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      await userRef.set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'mobile': user.mobile,
        'date_time': cf.Timestamp.now(),
        'user_token': userToken
      }, cf.SetOptions(merge: true));
      _paymentRepository.createUserWallet(user.id);
    } else {
      await userRef.set({'user_token': userToken}, cf.SetOptions(merge: true));
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update(data);
  }

  Future<User?> getUserById(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final doc = await userRef.get();
    if (doc.exists) {
      return User.fromFirestore(doc);
    }
    return null;
  }

  Future<void> deleteUser(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.delete();
  }

  Stream<User?> getUserStream(String userId) {
    final userRef = _firestore.collection('users').doc(userId);
    return userRef.snapshots().map((doc) {
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<bool> isUserMentor(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final querySnapshot = await _firestore
          .collection('mentor')
          .where('user_id', isEqualTo: userRef)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<MentorRate?> getMentorRates(String mentorId) async {
    try {
      final rateRef = await _firestore
          .collection('mentor_rate')
          .where('mentor_id', isEqualTo: mentorId)
          .get();

      if (rateRef.docs.isNotEmpty) {
        final doc = rateRef.docs.first;
        return MentorRate.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

}
