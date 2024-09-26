part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {

  @override
  List<Object> get props => [];
}

class UserWalletResponse extends UserState {
  final Wallet wallet;
  final List<Transaction> transactions;

  const UserWalletResponse(this.wallet, this.transactions);

  @override
  List<Object> get props => [wallet, transactions];
}

