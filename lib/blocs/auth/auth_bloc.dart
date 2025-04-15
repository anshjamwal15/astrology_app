import 'dart:developer';

import 'package:astrology_app/blocs/auth/auth_event.dart';
import 'package:astrology_app/blocs/auth/auth_state.dart';
import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(
          email: event.email,
          password: event.password,
        );
        emit(CheckEmailVerification());
      } catch (e) {
        if (e is SignUpWithEmailAndPasswordFailure) {
          if (e.message == "An account already exists for that email.") {
            try {
              await authRepository
                  .logInWithEmailAndPassword(
                    email: event.email,
                    password: event.password,
                  )
                  .timeout(const Duration(seconds: 5));
              emit(Authenticated());
            } catch (e) {
              emit(AuthError("Please provide correct email and password"));
              emit(UnAuthenticated());
            }
          } else {
            emit(AuthError(e.message));
            emit(UnAuthenticated());
          }
        } else {
          emit(AuthError('An unknown error occurred'));
          emit(UnAuthenticated());
        }
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.logInWithGoogle();
        emit(Authenticated());
      } catch (e) {
        if (e is LogInWithGoogleFailure) {
          emit(AuthError(e.message));
        } else {
          emit(AuthError('An unknown error occurred'));
        }
        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.logOut();
      emit(UnAuthenticated());
    });

    on<PhoneOtpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.sendOtpToPhone(event.phoneNumber);
        emit(OtpSent());
      } catch (e) {
        emit(OtpError(e.toString()));
      }
    });

    on<VerifyPhoneOtpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.verifyPhoneOtp(event.phoneNumber, event.otp);
        emit(OtpVerified());
        emit(Authenticated());
      } catch (e) {
        emit(OtpError(e.toString()));
      }
    });

    on<EmailOtpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.sendOtpToEmail(event.email);
        emit(OtpSent());
      } catch (e) {
        emit(OtpError(e.toString()));
      }
    });

    on<VerifyEmailOtpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.verifyEmailOtp(event.email, event.otp);
        emit(OtpVerified());
        emit(Authenticated());
      } catch (e) {
        emit(OtpError(e.toString()));
      }
    });

    on<PasswordFieldRequested>((event, emit) {
      emit(Loading());
      try {
        emit(ShowPasswordField());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<OtpFieldRequested>((event, emit) {
      emit(Loading());
      try {
        emit(ShowOtpField());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<HideFieldRequested>((event, emit) {
      emit(Loading());
      try {
        emit(HidePassOrOtpField());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
