import 'package:astrology_app/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astrology_app/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> saveUser(User user) async {
    final userRef = _firestore.collection('users').doc(user.id);
    // TODO: don't update token everytime
    final userToken = await FirebaseMessaging.instance.getToken();

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
        'date_time': Timestamp.now(),
        'user_token': userToken
      }, SetOptions(merge: true));
    } else {
      await userRef.set({
        'user_token': userToken
      }, SetOptions(merge: true));
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
}