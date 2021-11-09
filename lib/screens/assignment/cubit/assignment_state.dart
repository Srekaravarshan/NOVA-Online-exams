part of 'assignment_cubit.dart';

enum AssignmentStatus { initial, loading, loaded, error }

class AssignmentState extends Equatable {
  final AssignmentStatus status;
  final Failure failure;

  const AssignmentState({required this.failure, required this.status});

  factory AssignmentState.initial() {
    return AssignmentState(
        status: AssignmentStatus.initial, failure: const Failure());
  }

  @override
  List<Object?> get props => [];
}
