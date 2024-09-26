part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserWalletRequest extends UserEvent {
  final String userId;

  const UserWalletRequest(this.userId);

  @override
  List<Object> get props => [userId];
}

