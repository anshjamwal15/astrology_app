part of 'app_bloc.dart';

enum AppStatus {
  loading,
  unauthenticated,
  incompleteProfile,
  authenticated,
}

final class AppState extends Equatable {
  const AppState._({required this.status, required this.user});

  const AppState.loading()
      : this._(status: AppStatus.loading, user: User.empty);

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.incompleteProfile(User user)
      : this._(status: AppStatus.incompleteProfile, user: user);

  const AppState.unauthenticated()
      : this._(status: AppStatus.unauthenticated, user: User.empty);

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
