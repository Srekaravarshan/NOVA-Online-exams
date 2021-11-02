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
  final QuestionPaper questionPaper;

  final QuestionPaperStatus status;
  final Failure failure;

  const QuestionPaperState(
      {required this.questionPaper,
      required this.status,
      required this.failure});

  factory QuestionPaperState.initial() {
    return QuestionPaperState(
        questionPaper: QuestionPaper.empty,
        status: QuestionPaperStatus.initial,
        failure: Failure());
  }

  QuestionPaperState copyWith({
    QuestionPaper? questionPaper,
    QuestionPaperStatus? status,
    Failure? failure,
  }) {
    if ((questionPaper == null ||
            identical(questionPaper, this.questionPaper)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return QuestionPaperState(
      questionPaper: questionPaper ?? this.questionPaper,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [questionPaper, status, failure];
}
