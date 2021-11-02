part of 'question_paper_cubit.dart';

abstract class QuestionPaperEvent {
  const QuestionPaperEvent();
}

class QuestionPaperLoadUser extends QuestionPaperEvent {
  final String userId;

  const QuestionPaperLoadUser({required this.userId});
}
