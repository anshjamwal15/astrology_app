part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated
}

final class AppState extends Equatable {
  const AppState._({required this.status, required this.user});

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  AppState.unauthenticated() : this._(status: AppStatus.unauthenticated, user: User.empty);

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}