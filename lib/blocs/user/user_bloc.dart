import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final PaymentRepository _paymentRepository = PaymentRepository();

  UserBloc() : super(UserInitial()) {
    on<UserWalletRequest>((event, emit) async {
      final wallet = await _paymentRepository.getUserWallet(event.userId);
      final transactions = await _paymentRepository.getUserTransactions(event.userId);
      if (wallet != null && transactions.isNotEmpty) {
        emit(UserWalletResponse(wallet, transactions));
      }
    });
  }
}