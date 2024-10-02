import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'mentor_state.dart';

class MentorCubit extends Cubit<MentorState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MentorCubit() : super(MentorInitial());

  Future<void> loadMentors() async {
    try {
      emit(MentorLoading());
      final QuerySnapshot snapshot = await _firestore.collection('mentor').get();
      final mentors = snapshot.docs.map((doc) => Mentor.initialDataFromFirestore(doc)).toList();
      emit(MentorLoaded(mentors));
    } catch (e) {
      emit(MentorError(e.toString()));
    }
  }

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
}
