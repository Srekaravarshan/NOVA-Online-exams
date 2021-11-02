part of 'create_subject_cubit.dart';

enum CreateSubjectStatus { initial, submitting, success, error }

class CreateSubjectState extends Equatable {
  final String name;
  final CreateSubjectStatus status;
  final Failure failure;

  const CreateSubjectState(
      {required this.name, required this.status, required this.failure});

  factory CreateSubjectState.initial() {
    return const CreateSubjectState(
        name: '', status: CreateSubjectStatus.initial, failure: Failure());
  }

  CreateSubjectState copyWith({
    String? name,
    CreateSubjectStatus? status,
    Failure? failure,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return CreateSubjectState(
      name: name ?? this.name,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [name];
}
