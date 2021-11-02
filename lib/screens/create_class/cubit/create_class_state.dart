part of 'create_class_cubit.dart';

enum CreateClassStatus { initial, submitting, success, error }

class CreateClassState extends Equatable {
  final String name;
  final String? section, room, subject;
  final CreateClassStatus status;
  final Failure failure;

  CreateClassState(
      {required this.name,
      this.section,
      this.room,
      this.subject,
      required this.status,
      required this.failure});

  factory CreateClassState.initial() {
    return CreateClassState(
        name: '',
        subject: '',
        section: '',
        room: '',
        status: CreateClassStatus.initial,
        failure: const Failure());
  }

  CreateClassState copyWith({
    String? name,
    String? section,
    String? room,
    String? subject,
    CreateClassStatus? status,
    Failure? failure,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (section == null || identical(section, this.section)) &&
        (room == null || identical(room, this.room)) &&
        (subject == null || identical(subject, this.subject)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return CreateClassState(
      name: name ?? this.name,
      section: section ?? this.section,
      room: room ?? this.room,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [name, section, room, subject];
}
