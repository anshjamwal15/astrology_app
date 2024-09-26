import 'package:astrology_app/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

class PaymentRepository {
  final firebase.FirebaseFirestore _firestore = firebase.FirebaseFirestore.instance;

  Future<Wallet?> getUserWallet(String userId) async {
    final wallet = await _firestore
        .collection('wallet')
        .where('user_id', isEqualTo: userId)
        .get();
    if (wallet.docs.isNotEmpty) {
      final doc = wallet.docs.first;
      return Wallet.fromFirestore(doc);
    }
    return null;
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    final transactionSnapshot = await _firestore
        .collection('transaction')
        .where('user', isEqualTo: userId)
        .get();
    if (transactionSnapshot.docs.isNotEmpty) {
      return transactionSnapshot.docs.map((doc) => Transaction.fromFirestore(doc)).toList();
    }
    return [];
  }

  Future<Wallet?> createUserWallet(String userId) async {
    final wallet = await _firestore
        .collection('wallet')
        .where('user_id', isEqualTo: userId)
        .get();

    if (wallet.docs.isNotEmpty) {
      final doc = wallet.docs.first;
      return Wallet.fromFirestore(doc);
    }

    final newWalletRef = _firestore.collection('wallet').doc();
    final newWallet = Wallet(
      id: newWalletRef.id,
      lastTransactionId: null,
      mentorId: null,
      balance: 100,
      dateTime: firebase.Timestamp.now(),
      currency: 'INR',
      userId: userId,
    );

    await newWalletRef.set(newWallet.toMap());
    return newWallet;
  }

  Future<String> updateWalletBalance({
    required String userId,
    required int transactionAmount,
    required bool isAdding,
  }) async {
    final walletQuery = await _firestore
        .collection('wallet')
        .where('user_id', isEqualTo: userId)
        .get();

    if (walletQuery.docs.isNotEmpty) {
      final walletDoc = walletQuery.docs.first;
      final walletRef = walletDoc.reference;

      // Get the current balance and update it based on the transaction type
      final wallet = Wallet.fromFirestore(walletDoc);
      final updatedBalance = isAdding
          ? wallet.balance + transactionAmount // Add money
          : wallet.balance - transactionAmount; // Send money

      if (updatedBalance < 0) {
        return "Insufficient balance";
      }

      // Update the wallet balance and lastTransactionId
      await walletRef.update({
        'balance': updatedBalance,
        // 'last_transaction_id': transactionId,
      });

      // Create a new transaction
      final transactionRef = _firestore.collection('transaction').doc(); // New transaction document reference
      final transactionData = {
        'id': transactionRef.id,
        'user': userId,
        'amount': transactionAmount,
        'currency': "INR",
        'date_time': firebase.Timestamp.now(),
      };

      // Add the new transaction to the 'transactions' collection
      await transactionRef.set(transactionData);
      return "Wallet updated successfully";
    } else {
      throw Exception('Wallet not found for userId: $userId');
    }
  }



}