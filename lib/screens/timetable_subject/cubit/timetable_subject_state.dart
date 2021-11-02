part of 'timetable_subject_cubit.dart';

enum TimetableSubjectStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error
}

class TimetableSubjectState extends Equatable {
  final String set;
  final TimetableSubjectStatus status;
  final Failure failure;

  const TimetableSubjectState(
      {required this.set, required this.status, required this.failure});

  factory TimetableSubjectState.initial() {
    return const TimetableSubjectState(
        set: 'mcq', status: TimetableSubjectStatus.initial, failure: Failure());
  }

  TimetableSubjectState copyWith({
    String? set,
    TimetableSubjectStatus? status,
    Failure? failure,
  }) {
    if ((set == null || identical(set, this.set)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return TimetableSubjectState(
      set: set ?? this.set,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [set, status, failure];
}
