import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class PhoneOtpRequested extends AuthEvent {
  final String phoneNumber;
  PhoneOtpRequested(this.phoneNumber);
}

class VerifyPhoneOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String otp;
  VerifyPhoneOtpRequested(this.phoneNumber, this.otp);
}

class EmailOtpRequested extends AuthEvent {
  final String email;
  EmailOtpRequested(this.email);
}

class VerifyEmailOtpRequested extends AuthEvent {
  final String email;
  final String otp;
  VerifyEmailOtpRequested(this.email, this.otp);
}

class PasswordFieldRequested extends AuthEvent {}

class OtpFieldRequested extends AuthEvent {}
