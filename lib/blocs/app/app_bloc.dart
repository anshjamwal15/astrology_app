import 'dart:async';
import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AppState.loading()) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) async {
    // Add a delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    final user = event.user;

    if (user == User.empty) {
      emit(const AppState.unauthenticated());
      return;
    }

    if (user.isEmailVerified && !user.profileCompleted) {
      emit(AppState.incompleteProfile(user));
      return;
    }

    if (user.isEmailVerified && user.profileCompleted) {
      emit(AppState.authenticated(user));
      return;
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
