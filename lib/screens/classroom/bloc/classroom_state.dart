part of 'classroom_bloc.dart';

enum ClassroomStatus { initial, loading, loaded, error }

class ClassroomState extends Equatable {
  final Class classroom;
  final List subjects;
  final ClassroomStatus status;
  final Failure failure;

  const ClassroomState(
      {required this.classroom,
      required this.subjects,
      required this.status,
      required this.failure});

  factory ClassroomState.initial() {
    return ClassroomState(
        classroom: Class.empty,
        subjects: [],
        status: ClassroomStatus.initial,
        failure: const Failure());
  }

  ClassroomState copyWith({
    Class? classroom,
    List? subjects,
    ClassroomStatus? status,
    Failure? failure,
  }) {
    if ((classroom == null || identical(classroom, this.classroom)) &&
        (subjects == null || identical(subjects, this.subjects)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return ClassroomState(
      classroom: classroom ?? this.classroom,
      subjects: subjects ?? this.subjects,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [classroom, subjects, status];
}
