part of 'create_assignment_cubit.dart';

enum CreateAssignmentStatus { initial, submitting, success, error }

class CreateAssignmentState extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List fileUrls;
  final CreateAssignmentStatus status;
  final Failure failure;

  const CreateAssignmentState(
      {required this.title,
      required this.id,
      this.description,
      required this.fileUrls,
      required this.status,
      required this.failure});

  factory CreateAssignmentState.initial() {
    return const CreateAssignmentState(
        title: '',
        id: '',
        description: '',
        status: CreateAssignmentStatus.initial,
        failure: Failure(),
        fileUrls: []);
  }

  CreateAssignmentState copyWith({
    String? id,
    String? title,
    String? description,
    List? fileUrls,
    CreateAssignmentStatus? status,
    Failure? failure,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (title == null || identical(title, this.title)) &&
        (description == null || identical(description, this.description)) &&
        (fileUrls == null || identical(fileUrls, this.fileUrls)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return CreateAssignmentState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrls: fileUrls ?? this.fileUrls,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [title, description, fileUrls, status, failure];
}
