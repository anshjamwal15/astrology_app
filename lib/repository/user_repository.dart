import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/network/services/user_api_service.dart';
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:astrology_app/services/DAOs/user_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_messaging/firebase_messaging.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserRepository {
  UserRepository({cf.FirebaseFirestore? firestore})
      : _firestore = firestore ?? cf.FirebaseFirestore.instance;

  final cf.FirebaseFirestore _firestore;
  final PaymentRepository _paymentRepository = PaymentRepository();
  final _userApiservice = UserApiService();

  Future<User> fetchAndSyncUser(
    firebase_auth.User firebaseUser,
    UserDao userDao,
  ) async {
    // Step 1: Ensure the email is available
    final email = firebaseUser.email;
    if (email == null) return User.empty;

    // Step 2: Fetch backend user using email
    final backendUser = await _userApiservice.getUserByEmail(email);
    if (backendUser == null || backendUser.isEmpty) {
      await userDao.deleteUser(); // Clear invalid local user
      return User.empty;
    }

    // Step 3: Fetch Firestore data
    final userDocRef = _firestore.collection('users').doc(backendUser.id);
    final userDoc = await userDocRef.get();
    final firestoreData = userDoc.data() as Map<String, dynamic>? ?? {};

    // Step 4: Build updated user object
    final updatedUser = User(
      id: backendUser.id,
      email: email,
      isEmailVerified: firebaseUser.emailVerified,
      name: firestoreData['name'] ?? '',
      mobile: firestoreData['mobile'] ?? '',
      country: firestoreData['country'] ?? '',
      profileCompleted: firestoreData['is_profile_completed'] ?? false,
    );

    // Step 5: Determine user type (mentor or not)
    final isMentor = await isUserMentor(updatedUser.id);
    final finalUser = updatedUser.copyWith(isMentor: isMentor);

    // Step 6: Save to Firestore if not already there
    if (!userDoc.exists) {
      await saveUser(finalUser);
    }

    // Step 7: Save to local DB
    await userDao.insertUser(finalUser);

    return finalUser;
  }

  Future<void> saveUser(User user) async {
    if (user.id.isEmpty) {
      throw Exception('Cannot save user with empty ID');
    }

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
        'user_token': userToken,
        'is_profile_completed': false,
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

  // Mentor APIs
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

  Future<bool> changeUserToMentor(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);

    // Check if the user is already a mentor
    final querySnapshot = await _firestore
        .collection('mentor')
        .where('user_id', isEqualTo: userRef)
        .get();

    // If not found, add them to the mentor collection
    if (querySnapshot.docs.isEmpty) {
      final mentorRef = _firestore.collection('mentor').doc();
      final skillSet =
          _firestore.collection('skill_set').doc('CRUcuOl3IU7DYovD3krK');
      final status =
          _firestore.collection('status').doc('iYFuhutPfVPhaVk0Sx56');
      final mentorRateRef = _firestore.collection('mentor_rate').doc();

      // Retrieve user data to copy over as mentor data
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        final nameMap = splitName(userData?['name']);
        // Create mentor data from user data
        final mentorData = {
          'id': mentorRef.id,
          'first_name': nameMap['firstName'],
          'last_name': nameMap['lastName'],
          'email': userData?['email'],
          'user_id': userRef,
          'rating': 4,
          'total_exp_yrs': 2,
          'skill_set': skillSet,
          'status': status,
        };

        // Save mentor data
        await mentorRef.set(mentorData);

        final mentorRateData = {
          'audio_mrate': 5,
          'audio_rate': 50,
          'chat_mrate': 5,
          'chat_rate': 10,
          'currency': "INR",
          'date_time': cf.Timestamp.now(),
          'id': mentorRateRef.id,
          'mentor_id': mentorRef.id,
          'valid_from': cf.Timestamp.now(),
          'valid_to': cf.Timestamp.now(),
          'video_mrate': 5,
          'video_rate': 100,
        };

        await mentorRateRef.set(mentorRateData);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Map<String, String> splitName(String name) {
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      String firstName = parts.first;
      String lastName = parts.sublist(1).join(' ');
      return {'firstName': firstName, 'lastName': lastName};
    } else {
      return {'firstName': name, 'lastName': ''};
    }
  }
}
