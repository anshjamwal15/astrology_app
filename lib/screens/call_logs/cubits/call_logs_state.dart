part of 'call_logs_cubit.dart';

abstract class CallLogsState extends Equatable {
  const CallLogsState();

  @override
  List<Object> get props => [];
}

class CallLogsInitial extends CallLogsState {}

class CallLogsLoading extends CallLogsState {}

class CallLogsLoaded extends CallLogsState {
  final List<Future<CallLogs>> callLogs;

  const CallLogsLoaded(this.callLogs);

  @override
  List<Object> get props => [callLogs];
}

class CallLogsError extends CallLogsState {
  final String message;

  const CallLogsError(this.message);

  @override
  List<Object> get props => [message];
}
