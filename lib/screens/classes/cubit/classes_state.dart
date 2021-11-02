part of 'classes_cubit.dart';

enum ClassStatus { initial, loading, loaded, error }

class ClassesState {
  final List<Class> classes;
  final ClassStatus status;
  final Failure failure;

  ClassesState(
      {required this.classes, required this.status, required this.failure});

  factory ClassesState.initial() {
    return ClassesState(
        classes: [], status: ClassStatus.initial, failure: const Failure());
  }

  ClassesState copyWith({
    List<Class>? classes,
    ClassStatus? status,
    Failure? failure,
  }) {
    if ((classes == null || identical(classes, this.classes)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return ClassesState(
      classes: classes ?? this.classes,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
