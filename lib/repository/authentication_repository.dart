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

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        await _userDao.deleteUser();
        return User.empty;
      }

      // Get user data from Firestore
      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      var user = firebaseUser.toUser();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final isMentor = await _userRepository.isUserMentor(user.id);
        user = user.copyWith(
          isMentor: isMentor,
          isEmailVerified: firebaseUser.emailVerified,
          profileCompleted: data['is_profile_completed'] ?? false,
        );
        AppConstants.isUserMentor = isMentor;

        // Update local storage with latest states
        await _userDao.updateUserStatus(
          isEmailVerified: firebaseUser.emailVerified,
          isProfileCompleted: data['is_profile_completed'] ?? false,
        );

        await _userDao.insertUser(user);
      } else {
        // If no Firestore document exists, create one
        await _userRepository.saveUser(user.copyWith(
          isEmailVerified: firebaseUser.emailVerified,
          profileCompleted: false,
        ));
      }
      return user;
    });
  }

  Future<firebase_auth.UserCredential> signUp(
      {required String email, required String password}) async {
    try {
      // Create Firebase user first
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCred.user?.sendEmailVerification();

      // Save user to Firestore
      await _userRepository.saveUser(userCred.user!.toUser());

      return userCred;
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
      final user = await _userApiService.getUserByEmail(userCred.user!.email!);
      if (user != null) {
        // await UserManager.instance.loadUser();
        await _userRepository
            .saveUser(userCred.user!.toUser(serverId: user.id));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      printWarning(e);
      throw const LogInWithGoogleFailure();
    }
  }

  Future<firebase_auth.UserCredential> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in backend
      var user = await _userApiService.getUserByEmail(email);
      if (user == null || user.isEmpty) {
        // If user doesn't exist in backend, save them to Firestore
        await _userRepository.saveUser(userCredential.user!.toUser());
      }

      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
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

extension on firebase_auth.User {
  User toUser({String? serverId}) {
    return User(
      id: serverId ?? '',
      email: email ?? '',
      name: displayName ?? '',
    );
  }
}
