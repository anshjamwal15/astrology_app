part of 'mentor_cubit.dart';

abstract class MentorState extends Equatable {
  const MentorState();

  @override
  List<Object> get props => [];
}

class MentorInitial extends MentorState {}

class MentorLoading extends MentorState {}

class MentorLoaded extends MentorState {
  final List<Future<Mentor>> mentors;

  const MentorLoaded(this.mentors);

  @override
  List<Object> get props => [mentors];
}

class MentorError extends MentorState {
  final String message;

  const MentorError(this.message);

  @override
  List<Object> get props => [message];
}
