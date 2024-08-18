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
        emit(Authenticated());
      } catch (e) {
        if (e is SignUpWithEmailAndPasswordFailure) {
          emit(AuthError(e.message));
        } else {
          emit(AuthError('An unknown error occurred'));
        }
        emit(UnAuthenticated());
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.logInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated());
      } catch (e) {
        if (e is LogInWithEmailAndPasswordFailure) {
          emit(AuthError(e.message));
        } else {
          emit(AuthError('An unknown error occurred'));
        }
        emit(UnAuthenticated());
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
  }
}
