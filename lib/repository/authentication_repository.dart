import 'dart:async';
import 'package:astrology_app/constants/app_constants.dart';
import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/network/services/user_api_service.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/services/DAOs/user_dao.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:astrology_app/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'too-many-requests':
        return const LogInWithEmailAndPasswordFailure(
          'Access temporarily blocked due to too many attempts. Please try again later or reset your password.',
        );
      case 'invalid-credential':
        return const LogInWithEmailAndPasswordFailure(
            'Invalid credentials, Please try again.');
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
  final String message;
}

class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }
  final String message;
}

class LogOutFailure implements Exception {}

const userCacheKey = 'dkgnfoigdfmgdflkmgkldfmglkdfmlkgmdf';

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserDao? userDao,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: ['profile', 'email']),
        _userDao = userDao ?? UserDao(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserDao _userDao;
  final UserRepository _userRepository = UserRepository();
  final UserApiService _userApiService = UserApiService();
  final FirebaseFirestore _firestore;

  Future<void> refreshUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      final freshUser =
          await _userRepository.fetchAndSyncUser(firebaseUser, _userDao);
      AppConstants.localUser = freshUser;
      AppConstants.isUserMentor = freshUser.isMentor;
      await _userDao.insertUser(freshUser);
    }
  }

  Future<User> _getUserData(firebase_auth.User firebaseUser) async {
    final localUser = await _userDao.getUser();
    final backendUser =
        await _userApiService.getUserByEmail(firebaseUser.email!);

    if (backendUser == null || backendUser.isEmpty) {
      await _userDao.deleteUser();
      return User.empty;
    }

    final userDocRef = _firestore.collection('users').doc(backendUser.id);
    final userDoc = await userDocRef.get();
    final firestoreData = userDoc.data() as Map<String, dynamic>? ?? {};

    if (localUser != null && localUser.email == firebaseUser.email) {
      final updatedUser = localUser.copyWith(
        isEmailVerified: firebaseUser.emailVerified,
        profileCompleted: firestoreData['is_profile_completed'] ?? false,
      );
      return updatedUser;
    }

    var newUser = User(
      id: backendUser.id,
      email: firebaseUser.email!,
      isEmailVerified: firebaseUser.emailVerified,
    );

    final isMentor = await _userRepository.isUserMentor(newUser.id);
    newUser = newUser.copyWith(
      isMentor: isMentor,
      profileCompleted: firestoreData['is_profile_completed'] ?? false,
    );
    if (!userDoc.exists) {
      await _userRepository.saveUser(newUser);
    }

    return newUser;
  }

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        await _userDao.deleteUser();
        AppConstants.localUser = User.empty;
        AppConstants.isUserMentor = false;
        return User.empty;
      }

      final user = await _userRepository.fetchAndSyncUser(
        firebaseUser,
        _userDao,
      );
      AppConstants.localUser = user;
      AppConstants.isUserMentor = user.isMentor;
      await _userDao.insertUser(user);
      return user;
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      var backendUser = await _userApiService.getUserByEmail(email);
      if (backendUser == null || backendUser.isEmpty) {
        throw const SignUpWithEmailAndPasswordFailure(
          'User not found',
        );
      }

      // Create Firebase user
      final firebaseUserCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user with backend ID and save to Firestore
      final user = User(
          id: backendUser.id,
          email: email,
          isEmailVerified: firebaseUserCredential.user?.emailVerified ?? false);

      // Save to Firestore
      await _userRepository.saveUser(user);

      // Save to local storage
      await _userDao.insertUser(user);

      // Send email verification
      if (firebaseUserCredential.user != null &&
          !firebaseUserCredential.user!.emailVerified) {
        await firebaseUserCredential.user!.sendEmailVerification();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      AppLogger.error(e.toString());
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      AppLogger.error(e.toString());
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);

      // Get user from backend
      final backendUser =
          await _userApiService.getUserByEmail(userCred.user!.email!);
      if (backendUser != null) {
        final user = User(id: backendUser.id, email: userCred.user!.email!);
        await _userRepository.saveUser(user);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      printWarning(e);
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Check if user exists in backend first
      var user = await _userApiService.getUserByEmail(email);
      if (user == null || user.isEmpty) {
        throw const LogInWithEmailAndPasswordFailure(
          'User not found.',
        );
      }

      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on firebase_auth.FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          // Log the error for monitoring
          AppLogger.error('Rate limit exceeded for user: $email');
          throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
        }
        throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
      }

      await _userRepository.saveUser(User(id: user.id, email: email));
    } catch (e) {
      if (e is LogInWithEmailAndPasswordFailure) {
        rethrow;
      }
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _userDao.deleteUser(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future<void> sendOtpToPhone(String phoneNumber) async {
    print("OTP sent to $phoneNumber");
    // upcoming logic
  }

  Future<bool> verifyPhoneOtp(String phoneNumber, String enteredOtp) async {
    if (enteredOtp == "0000") {
      return true;
    }
    return false;
  }

  Future<void> sendOtpToEmail(String email) async {
    print("OTP sent to $email");
    // upcoming logic
  }

  Future<bool> verifyEmailOtp(String email, String enteredOtp) async {
    if (enteredOtp == "0000") {
      return true;
    }
    return false;
  }
}
