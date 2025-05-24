import 'package:astrology_app/models/index.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'call_logs_state.dart';

class CallLogsCubit extends Cubit<CallLogsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CallLogsCubit() : super(CallLogsInitial());

  Future<void> loadCallLogs() async {
    try {
      emit(CallLogsLoading());
      final QuerySnapshot snapshot = await _firestore.collection('call_logs').get();
      final callLogs = snapshot.docs.map((doc) => CallLogs.fromFirestore(doc)).toList();
      emit(CallLogsLoaded(callLogs));
    } catch (e) {
      emit(CallLogsError(e.toString()));
    }
  }
}