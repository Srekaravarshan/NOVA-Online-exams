part of 'question_paper_cubit.dart';

enum QuestionPaperStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error
}

class QuestionPaperState extends Equatable {
  final String set;
  final String mode;
  final String qpStatus;
  final List sections;
  final String id;

  final QuestionPaperStatus status;
  final Failure failure;

  const QuestionPaperState(
      {required this.set,
      required this.mode,
      required this.qpStatus,
      required this.id,
      required this.sections,
      required this.status,
      required this.failure});

  factory QuestionPaperState.initial() {
    return const QuestionPaperState(
        sections: [],
        status: QuestionPaperStatus.initial,
        failure: Failure(),
        qpStatus: 'initial',
        set: '',
        mode: 'mcq',
        id: '');
  }

  QuestionPaperState copyWith({
    String? set,
    String? mode,
    String? qpStatus,
    List? sections,
    String? id,
    QuestionPaperStatus? status,
    Failure? failure,
  }) {
    if ((set == null || identical(set, this.set)) &&
        (mode == null || identical(mode, this.mode)) &&
        (qpStatus == null || identical(qpStatus, this.qpStatus)) &&
        (sections == null || identical(sections, this.sections)) &&
        (id == null || identical(id, this.id)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return QuestionPaperState(
      set: set ?? this.set,
      mode: mode ?? this.mode,
      qpStatus: qpStatus ?? this.qpStatus,
      sections: sections ?? this.sections,
      id: id ?? this.id,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [sections, status, failure];
}
