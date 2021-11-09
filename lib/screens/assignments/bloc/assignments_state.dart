part of 'assignments_bloc.dart';

enum AssignmentsStatus { initial, loading, loaded, error }

class AssignmentsState {
  final List assignments;
  final AssignmentsStatus status;
  final Failure failure;

  AssignmentsState(
      {required this.assignments, required this.status, required this.failure});

  factory AssignmentsState.initial() {
    return AssignmentsState(
        assignments: [],
        status: AssignmentsStatus.initial,
        failure: const Failure());
  }

  AssignmentsState copyWith({
    List? assignments,
    AssignmentsStatus? status,
    Failure? failure,
  }) {
    if ((assignments == null || identical(assignments, this.assignments)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return AssignmentsState(
      assignments: assignments ?? this.assignments,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
